from flask import jsonify
from flask import request

from ...main import app


@app.route('/search/', methods=['POST'])
def route_search():
#    params = { 'q': '11 impasse canart', 'hn': '11', 'st': 'Impasse Canart', 'pc': '75012', 'ct': 'Paris', 'limit': '1' }

    if request.method == 'POST':
        # Gather parameters of the user's request
        params = request.data.get('data', '')

        # Request address API with user's params
        url = "https://api-adresse.data.gouv.fr/search/" 
        r = requests.get(url, params)
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
