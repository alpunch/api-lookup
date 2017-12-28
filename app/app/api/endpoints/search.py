from flask import jsonify
from flask import request

from ...main import app
from ..utils import query_addr

@app.route('/search/', methods=['POST'])
def route_search():
#    params = { 'q': '11 impasse canart', 'hn': '11', 'st': 'Impasse Canart', 'pc': '75012', 'ct': 'Paris', 'limit': '1' }

    if request.method == 'POST':
        # Gather parameters of the user's request
        params = request.get_json()
        # Query the address api using our moudule
        return query_addr(params)