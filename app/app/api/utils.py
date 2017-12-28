from flask import jsonify
from flask import request
import requests

def senseless_print():
    # Print something, just to demonstrate how to import modules
    print('Senseless print')

def query_addr(params):
    # Request address API with user's params
        url = "https://api-adresse.data.gouv.fr/search/"
        r = requests.get(url, params)
        #return jsonify(r.json())
        rq = r.json()

        # Check the address
        for items in rq['features']:
            if (    items['properties']['housenumber'].lower() == params['hn'].lower()
                and items['properties']['street'].lower()      == params['st'].lower()
                and items['properties']['postcode'].lower()    == params['pc'].lower()
                and items['properties']['city'].lower()        == params['ct'].lower()
            ):
                result = "Valid"
            else:
                result = "Invalid"
            # Return json
            return jsonify(result)