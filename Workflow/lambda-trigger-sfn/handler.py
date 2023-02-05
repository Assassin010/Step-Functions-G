import json
import boto3
import pprint

client = boto3.client('stepfunctions')

def lambda_handler(event, context):
	#INPUT -> { "A": "1", "B": "1"}

	input= {
        'A': 1,
        'B': 1
    }
	response = client.start_execution(
		stateMachineArn='arn:aws:states:us-east-1:XXXXXXXXXX:stateMachine:FirstStateMachine',
		input=json.dumps(input)	
		)