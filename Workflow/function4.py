from __future__ import print_function

import json

print("Loading Function...")

def lambda_handler(event, context):

    print("sum of A and B is {}".format(event['sumAB']))

    return(event)