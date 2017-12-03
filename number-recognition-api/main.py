# coding: utf-8
from flask import Flask, jsonify, request
from trainer import Trainer
import threading


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
    if trainer.train_status != 'now training':
        start_training()
    return jsonify({
        'train_status': trainer.train_status
    })


@app.route('/predict', methods=['POST'])
def predict():
    json = request.get_json(force=True, silent=True)
    data = json["data"]
    answer, confidence = trainer.predict(data)
    return jsonify({
        "answer": answer,
        "confidence": predict,
    })

@app.route('/status', methods=['GET'])
def status():
    return jsonify({
        'train_status': trainer.train_status
    })


def start_training():
    th = threading.Thread(target=trainer.train, name='th', args=())
    th.setDaemon(True)
    th.start()


if __name__ == '__main__':
    start_training()
    app.run(debug=True, host='localhost', port=3000)
