from __future__ import print_function

import json

print("Loading Function...")

def lambda_handler(event, context):

    B = event['B']

    B = B + 1

    returnvalue = {"B": B}

    return(returnvalue)