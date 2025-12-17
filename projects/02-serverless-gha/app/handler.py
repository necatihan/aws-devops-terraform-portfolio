import json
import os
import time

TABLE_NAME = os.environ.get("TABLE_NAME", "unknown")

def handler(event, context):
    return {
        "statusCode": 200,
        "headers": {"content-type": "application/json"},
        "body": json.dumps({
            "service": "portfolio-serverless",
            "table": TABLE_NAME,
            "timestamp": int(time.time()),
            "message": "ok"
        })
    }