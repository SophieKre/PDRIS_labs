from flask import Flask
from flask import request
from flask import jsonify
import os
import time
import json
import logging

logging.basicConfig(level=logging.DEBUG)

app = Flask(__name__)

@app.route('/', methods = ['GET'])
def get_la_info():
    la_list = list(os.getloadavg())

    text = f"""
        <!DOCTYPE html>
        <html>
            <style>
                table, th, td {{
                    border: 1px solid black;
                    text-align: center;
                }}
            </style>
            <body>
                <p>Timestamp: {time.time()} </p>
                <table style="width:20%">
                <tr>
                    <td>la1</td>
                    <td>{la_list[0]}</td>
                </tr>
                <tr>
                    <td>la10</td>
                    <td>{la_list[1]}</td>
                </tr>
                <tr>
                    <td>la15</td>
                    <td>{la_list[2]}</td>
                </tr>
            </table>

            </body>
        </html>
    """

    data = {
        "timestamp": time.time(),
        "la1": la_list[0],
        "la5": la_list[1],
        "la15": la_list[2]
    }

    data = json.dumps(data)
    # data = data.encode()
    return text


if __name__ == '__main__':
    try:
        app.run(host='0.0.0.0')
    except Exception as exc:
        logging.error(exc)
