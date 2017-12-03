# coding: utf-8
import sys
import os
import numpy as np
from dataset.mnist import load_mnist
from two_layer_net import TwoLayerNet


sys.path.append(os.pardir)


class Trainer:
    def __init__(self):
        self.network = TwoLayerNet(input_size=784, hidden_size=50, output_size=10)
        self.train_status = 'not trained'

    def train_status(self):
        return self.train_status

    def train(self):
        self.train_status = 'now training'

        (x_train, t_train), (x_test, t_test) = load_mnist(normalize=True, one_hot_label=True)

        iters_num = 10000
        train_size = x_train.shape[0]
        batch_size = 100
        learning_rate = 0.1

        iter_per_epoch = max(train_size / batch_size, 1)

        for i in range(iters_num):
            batch_mask = np.random.choice(train_size, batch_size)
            x_batch = x_train[batch_mask]
            t_batch = t_train[batch_mask]

            grad = self.network.gradient(x_batch, t_batch)

            for key in ('W1', 'b1', 'W2', 'b2'):
                self.network.params[key] -= learning_rate * grad[key]

            loss = self.network.loss(x_batch, t_batch)

            if i % iter_per_epoch == 0:
                train_acc = self.network.accuracy(x_train, t_train)
                test_acc = self.network.accuracy(x_test, t_test)
                print("loss\t\ttrain_acc\t\ttest_acc\t\titerations")
                print(str(loss) + "\t\t" + str(train_acc) + "\t\t" + str(test_acc) + "\t\t" + str(i) + "/" + str(iters_num))

        self.train_status = 'well trained'

    def predict(self, x):
        x = np.array(x)
        y = self.network.predict(x)
        i = np.argmax(y)
        return (i, y[i])
