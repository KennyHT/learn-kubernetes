import json
import os
import random

from flask import Flask, render_template, jsonify

HOSTNAME = os.environ.get('HOSTNAME', 'unknown')
IMAGES = json.load(open('cats.json'))


def create_app():
    app = Flask(__name__)

    @app.route('/')
    def index():
        url = random.choice(IMAGES)
        return render_template('index.html', url=url)

    @app.route('/kubernetes')
    def kubernetes():
        return jsonify(pod=HOSTNAME)

    @app.route('/healthz')
    def health_check():
        return jsonify(status='ok')

    return app


if __name__ == '__main__':
    app = create_app()
    app.run()
