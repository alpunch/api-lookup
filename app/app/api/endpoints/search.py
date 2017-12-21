from flask import jsonify
from flask import request

from ...main import app


@app.route('/search/', methods=['POST'])
def route_search():
    url = "https://api-adresse.data.gouv.fr/search/"
#    params = { 'q': '11 impasse canart', 'hn': '11', 'st': 'Impasse Canart', 'pc': '75012', 'ct': 'Paris', 'limit': '1' }

    if request.method == 'POST':
        params = request.data.get('data', '')
        r = requests.get(url, params)
        rq = r.json()

        for items in rq['features']:
            if (    items['properties']['housenumber'].lower() == params['hn'].lower()
                and items['properties']['street'].lower() == params['st'].lower()
                and items['properties']['postcode'].lower() == params['pc'].lower()
                and items['properties']['city'].lower() == params['ct'].lower()
            ):
                result = "Valid"
            else:
                result = "Invalid"
            return jsonify(result)
