import torch
import numpy as np


def storound(inttensor,  offset):
    base = inttensor.float()/offset
    prob = base - base.floor()
    stobits = torch.bernoulli(prob)
    return (base.floor() + stobits).int()


def init_w(m):
    t = 6. / np.sqrt(m.in_features + m.out_features)
    #m.weight.uniform_(-t, t)
    m.weight.zero_()
    m.bias.zero_()
    m.fb_weight.uniform_(-1, 1)
    return

def PLANSIG(xvals, FL):
    yvals = torch.sigmoid(xvals)
    x0 = -8
    y0 = 0
    for x, y in zip(xvals, yvals):
        k = (y-y0)/(x-x0)
        
    


def init_w_int(m):
    t = 6. / np.sqrt(m.in_features + m.out_features)
    W = torch.FloatTensor(m.weight.size()).uniform_(-t, t)
    m.weight = (W * m.offset).round().int()
    m.bias.zero_()
    fb = torch.FloatTensor(m.fb_weight.size()).uniform_(-1, 1)
    m.fb_weight = (fb * m.offset).round().int()
    return

def hard_sigmoid(tensor):
    return tensor.mul_(0.2).add_(0.5).clamp_(0, 1)


def sample(tensor, is_input=False, train=True, th=0.7):
    if train:
        if is_input:
            out = torch.bernoulli(tensor)
        else:
            out = torch.bernoulli(hard_sigmoid(tensor))
    else:
        if is_input:
            out = (tensor>th).float()
        else:
            out = (tensor>0.5).float()
    return out


def set_train(m):
    m.train = True
    return


def set_test(m):
    m.train = False
    return


def quantize(tensor, intbits, fracbits, signed=True):
    return tensor.mul(1 << fracbits).round().div(1 << fracbits).clamp(-1 << intbits, 1 << intbits)


def intsigmoid(tensor):
    """
    :param tensor: must be transformed into float value before calling
    :return: Sigmoid value translated to Integer value, ranging from 0~1024
    """
    return (1024 * torch.sigmoid(tensor)).round().int()


def intsigdiff(tensor):
    """
    :param tensor: must be transformed into float value before calling
    :return: differentiated sigmoid value translated to integer value, ranging from 0~1024
    """
    return (1024 * (torch.sigmoid(tensor) * (1 - torch.sigmoid(tensor)))).round().int()
#%%
