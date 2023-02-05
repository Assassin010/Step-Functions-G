from __future__ import print_function

import json

print("Loading Function...")

def lambda_handler(event, context):

    value1 = int(event['A'])

    value2 = int(event['B'])

    sum_value = value1 + value2

    returnvalue = {"A" : value1, "B" : value2, "sumAB" : sum_value} 

    return(returnvalue)