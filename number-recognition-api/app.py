# coding: utf-8
from flask import Flask
from two_layer_net import TwoLayerNet
from train_neural_network import train_neural_network


app = Flask(__name__)


@app.route('/train', methods=['GET'])
def train():
    return 'train'


@app.route('/predict', methods=['POST'])
def predict():
    return 'predict'


if __name__ == '__main__':
    app.run(debug=True, host='localhost', port=3000)
