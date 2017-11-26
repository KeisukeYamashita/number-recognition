# coding: utf-8
from flask import Flask, jsonify
from trainer import Trainer


app = Flask(__name__)
trainer = Trainer()


@app.route('/train', methods=['GET'])
def train():
    trainer.train()
    return jsonify({ 'train_status': trainer.train_status })


@app.route('/predict', methods=['POST'])
def predict():
    # trainer.network.predict()
    return 'predict'


if __name__ == '__main__':
    app.run(debug=True, host='localhost', port=3000)
    trainer.train()
