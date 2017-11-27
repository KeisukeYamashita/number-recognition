# coding: utf-8
from flask import Flask, jsonify
from trainer import Trainer


app = Flask(__name__)
trainer = Trainer()


@app.route('/')
def index():
    return jsonify({
        'endpoints': [
            {
                'path': '/train',
                'method': ['GET']
            },
            {
                'path': '/status',
                'method': ['GET']
            },
            {
                'path': '/predict',
                'method': ['POST']
            }
        ]
    })


@app.route('/train', methods=['GET'])
def train():
    trainer.train()
    return jsonify({
        'train_status': trainer.train_status
    })


@app.route('/predict', methods=['POST'])
def predict():
    # trainer.network.predict()
    return 'predict'


@app.route('/status', methods=['GET'])
def status():
    return jsonify({
        'train_status': trainer.train_status
    })


if __name__ == '__main__':
    app.run(debug=True, host='localhost', port=3000)
    trainer.train()
