import json
import os
import time

TABLE_NAME = os.environ.get("TABLE_NAME", "unknown")

def handler(event, context):
    method = event.get("requestContext", {}).get("http", {}).get("method")
    path = event.get("requestContext", {}).get("http", {}).get("path")

    return {
        "statusCode": 200,
        "headers": {"content-type": "application/json"},
        "body": json.dumps({
            "service": "portfolio-serverless",
            "method": method,
            "path": path,
            "table": TABLE_NAME,
            "timestamp": int(time.time()),
            "message": "healthy"
        })
    }
