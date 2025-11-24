import json
import os
import uuid
import boto3
from boto3.dynamodb.conditions import Key

TABLE_NAME = os.environ.get('TABLE_NAME', 'NotesTable')
dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table(TABLE_NAME)

def response(status_code, body):
    return {
        "statusCode": status_code,
        "headers": {
            "Content-Type": "application/json",
            "Access-Control-Allow-Origin": "*"
        },
        "body": json.dumps(body)
    }

def lambda_handler(event, context):
    http_method = event.get('httpMethod', '')
    path = event.get('path', '')
    path_params = event.get('pathParameters') or {}
    body = {}
    if event.get('body'):
        try:
            body = json.loads(event['body'])
        except:
            body = {}

    try:
        if path.startswith('/notes/') and path_params.get('id'):
            note_id = path_params['id']
            if http_method == 'GET':
                res = table.get_item(Key={'noteId': note_id})
                item = res.get('Item')
                if not item:
                    return response(404, {"message": "Note not found"})
                return response(200, item)
            if http_method == 'DELETE':
                table.delete_item(Key={'noteId': note_id})
                return response(200, {"message": "Deleted"})
            return response(405, {"message": "Method not allowed"})

        if path == '/notes':
            if http_method == 'POST':
                title = body.get('title', 'Untitled')
                content = body.get('content', '')
                note_id = str(uuid.uuid4())
                item = {
                    "noteId": note_id,
                    "title": title,
                    "content": content
                }
                table.put_item(Item=item)
                return response(201, item)

            if http_method == 'GET':
                res = table.scan()
                items = res.get('Items', [])
                return response(200, items)

            return response(405, {"message": "Method not allowed"})

        return response(404, {"message": "Not found"})
    except Exception as e:
        print("Error:", e)
        return response(500, {"message": "Internal server error", "error": str(e)})
