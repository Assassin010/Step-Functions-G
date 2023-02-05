from __future__ import print_function

import json

print("Loading Function...")

def lambda_handler(event, context):

    returnvalue = {"A":event[0]['A'], "B":event[1]['B']}

    return(returnvalue)