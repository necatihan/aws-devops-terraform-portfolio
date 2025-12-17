import json
import os
import time
import uuid
import boto3
from boto3.dynamodb.conditions import Key
from decimal import Decimal

TABLE_NAME = os.environ["TABLE_NAME"]
ddb = boto3.resource("dynamodb")
table = ddb.Table(TABLE_NAME)

class DecimalEncoder(json.JSONEncoder):
    def default(self, o):
        if isinstance(o, Decimal):
            # convert integers cleanly, otherwise float
            return int(o) if o % 1 == 0 else float(o)
        return super().default(o)

def _json(body):
    return json.dumps(body, cls=DecimalEncoder)

def _resp(status, body):
    return {
        "statusCode": status,
        "headers": {"content-type": "application/json"},
        "body": _json(body),
    }

def _log(level, msg, **fields):
    payload = {"level": level, "msg": msg, "ts": int(time.time()), **fields}
    print(json.dumps(payload))

def handler(event, context):
    http = (event.get("requestContext") or {}).get("http") or {}
    method = http.get("method")
    path = http.get("path")
    request_id = getattr(context, "aws_request_id", None)

    _log("INFO", "request", requestId=request_id, method=method, path=path)

    # ---- ROUTES ----
    if method == "GET" and path == "/health":
        return _resp(200, {
            "service": "portfolio-serverless",
            "message": "healthy",
            "table": TABLE_NAME,
            "timestamp": int(time.time()),
        })

    if method == "POST" and path == "/items":
        # Body required
        raw = event.get("body")
        if not raw:
            return _resp(400, {"error": "Missing JSON body"})

        try:
            body = json.loads(raw)
        except json.JSONDecodeError:
            return _resp(400, {"error": "Invalid JSON body"})

        pk = body.get("pk")
        data = body.get("data")

        if not pk or not isinstance(pk, str):
            return _resp(400, {"error": "pk is required and must be a string"})
        if data is None or not isinstance(data, dict):
            return _resp(400, {"error": "data is required and must be an object"})

        sk = body.get("sk") or f"{int(time.time() * 1000)}#{uuid.uuid4().hex[:8]}"

        item = {
            "pk": pk,
            "sk": sk,
            "data": data,
            "created_at": int(time.time()),
        }

        table.put_item(Item=item)

        _log("INFO", "item_created", requestId=request_id, pk=pk, sk=sk)
        return _resp(201, {"pk": pk, "sk": sk, "item": item})

    if method == "GET" and path and path.startswith("/items/"):
        # /items/{pk}
        path_params = event.get("pathParameters") or {}
        pk = path_params.get("pk")
        if not pk:
            return _resp(400, {"error": "pk path parameter is required"})

        resp = table.query(
            KeyConditionExpression=Key("pk").eq(pk),
            ScanIndexForward=True,
        )

        items = resp.get("Items", [])
        _log("INFO", "items_listed", requestId=request_id, pk=pk, count=len(items))
        return _resp(200, {"pk": pk, "count": len(items), "items": items})

    return _resp(404, {"error": "Not Found", "method": method, "path": path})