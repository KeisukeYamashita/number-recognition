# coding: utf-8
import sys
import os
import numpy as np
from dataset.mnist import load_mnist


sys.path.append(os.pardir)


def train_neural_network(network):
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

        grad = network.gradient(x_batch, t_batch)

        for key in ('W1', 'b1', 'W2', 'b2'):
            network.params[key] -= learning_rate * grad[key]

        loss = network.loss(x_batch, t_batch)

        if i % iter_per_epoch == 0:
            train_acc = network.accuracy(x_train, t_train)
            test_acc = network.accuracy(x_test, t_test)
            print(loss, train_acc, test_acc)

        print(str(i) + " / " + str(iters_num))

    return network
