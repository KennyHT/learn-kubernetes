from flask import url_for


class TestApp:
    def test_root(self, client):
        res = client.get(url_for('hello_world'))
        assert res.status_code == 200
        assert res.json == {'message': 'Hello, Kubernetes!'}

    def test_healthcheck(self, client):
        res = client.get(url_for('health_check'))
        assert res.status_code == 200
        assert res.json == {'status': 'ok'}
