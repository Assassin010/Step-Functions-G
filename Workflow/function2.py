from __future__ import print_function

import json

print("Loading Function...")

def lambda_handler(event, context):

    A = event['A']

    A = A + 1

    returnvalue = {"A": A}

    return(returnvalue)