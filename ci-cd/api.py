import os
from flask import Flask, jsonify

HOSTNAME = os.environ.get('HOSTNAME', 'unknown')


def create_app():
    app = Flask(__name__)

    @app.route('/')
    def hello_world():
        return jsonify(
            message='Hello, Kubernetes!',
            pod=HOSTNAME
        )

    @app.route('/healthz')
    def health_check():
        return jsonify(status='ok')

    return app


if __name__ == '__main__':
    app = create_app()
    app.run(port=5000)
