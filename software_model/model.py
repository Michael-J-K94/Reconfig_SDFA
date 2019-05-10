import torch
import torch.nn as nn
from util import *


class StoLinear(nn.Module):
    def __init__(self, in_features, out_features, fb_features, lr, bias=True):
        super(StoLinear, self).__init__()
        self.in_features = in_features
        self.out_features = out_features
        self.fb_features = fb_features
        self.weight = torch.Tensor(in_features, out_features)
        self.fb_weight = torch.Tensor(fb_features, out_features)
        self.lr = lr
        self.train = True
        self.bias_use = bias
        self.dw_buf0 = torch.FloatTensor(in_features,out_features).zero_()
        self.dw_buf1 = torch.FloatTensor(in_features,out_features).zero_()
        if bias:
            self.bias = torch.Tensor(out_features)

    def cuda(self, device_id=None):
        self.weight = self.weight.cuda(device_id)
        self.fb_weight = self.fb_weight.cuda(device_id)
        if self.bias_use:
            self.bias = self.bias.cuda(device_id)
        return

    def forward(self, input):
        out = torch.mm(input, self.weight)# + self.bias
        if self.bias_use:
            out += self.bias
        if self.train:
            self.fire_p = out.clone()
            self.il = input.clone()
        if self.train:
            return sample(out)
        else:
            return out

    def record(self, input):
        """
        :param input: is the spikes of output layer
        :return:
        """
        fb = torch.mm(input, self.fb_weight)
        self.fb_f = fb.clone()
        return

    def backward(self, input):
        """
        :param input: input is a onehot encoded vector of correct labels
        performs a backward pass
        :return:
        """
        out = torch.mm(input, self.fb_weight)
        d = torch.sigmoid(self.fire_p) * (1 - torch.sigmoid(self.fire_p)) * (
                torch.sigmoid(out) - torch.sigmoid(self.fb_f))
        dw = torch.sum(torch.bmm(self.il.unsqueeze_(2), d.unsqueeze_(1)), 0)
        db = torch.sum(d, 0).view(self.out_features)
        self.weight = self.weight + self.lr * self.dw_buf1
        self.bias = self.bias + self.lr * db
        self.dw_buf1 = self.dw_buf0
        self.dw_buf0 = self.dw
        return

    def __repr__(self):
        return 'StoLinear({0} X {1})'.format(self.in_features, self.out_features)


class StoOutput(nn.Module):
    def __init__(self, in_features, out_features, fb_features, lr, bias=True):
        super(StoOutput, self).__init__()
        self.in_features = in_features
        self.out_features = out_features
        self.fb_features = fb_features
        self.weight = torch.Tensor(in_features, out_features)
        self.fb_weight = torch.Tensor(fb_features, out_features)
        self.lr = lr
        self.train = True
        self.dw_buf0 = torch.FloatTensor(in_features,out_features).zero_().cuda() 

        if bias:
            self.bias = torch.Tensor(out_features)
    def cuda(self, device_id=None):
        self.weight = self.weight.cuda(device_id)
        self.fb_weight = self.fb_weight.cuda(device_id)
        self.bias = self.bias.cuda(device_id)
        return

    def forward(self, input):
        out = torch.mm(input, self.weight) + self.bias
        if self.train:
            self.fire_p = out.clone()
            self.il = input.clone()
        return out

    def backward(self, input):
        d = torch.sigmoid(self.fire_p) * (1 - torch.sigmoid(self.fire_p)) * (input - torch.sigmoid(self.fire_p))
        dw = torch.sum(torch.bmm(self.il.unsqueeze(2), d.unsqueeze(1)), 0)
        db = torch.sum(d, 0).view(self.out_features)
        self.weight = self.weight + (self.lr * self.dw_buf0)
        self.bias = self.bias + (self.lr * db)
        self.dw_buf0 = dw
        return

    def record(self, input):
        self.fb_f = input

    def __repr__(self):
        return 'StoOutput({0} X {1})'.format(self.in_features, self.out_features)


class StoSequential(nn.Sequential):
    def __init__(self, *args):
        super(StoSequential, self).__init__(*args)
        self.class_nums = args[-1].out_features

    def backward(self, input):
        """
        :param input: labels
        :return: trains the nn
        """
        onehot = torch.FloatTensor(list(input.shape)[0], self.class_nums).zero_().cuda()
        input = input.unsqueeze(1)
        onehot.scatter_(1, input, 1).float()
        for module in self._modules.values():
            module.backward(onehot)

    def record(self, input):
        for module in self._modules.values():
            module.record(input)

    def cuda(self, device_id=None):
        for module in self._modules.values():
            module.cuda(device_id)

    def apply(self, fn):
        for module in self._modules.values():
            module.apply(fn)

    def save(self, name):
        t = []
        for module in self._modules.values():
            t.append([module.weight.cpu().numpy(), module.bias.cpu().numpy(), module.fb_weight.cpu().numpy()])
        np.save(name, t)

    def load(self,name):
        t = np.load(name)
        for module,tt in zip(self._modules.values(),t):
            module.weight, module.bias, module.fb_weight = torch.from_numpy(tt[0]).cuda(),torch.from_numpy(tt[1]).cuda(),torch.from_numpy(tt[2]).cuda()



class StoLinear_Int(nn.Module):
    def __init__(self, in_features, out_features, fb_features, FL=11, FL_use = 6, IL = 2, bias=False):
        super(StoLinear_Int, self).__init__()
        self.in_features = in_features
        self.out_features = out_features
        self.fb_features = fb_features
        self.weight = torch.IntTensor(in_features, out_features)
        self.fb_weight = torch.IntTensor(fb_features, out_features)
        self.FL = FL
        self.FL_use = FL_use
        self.IL = IL
        self.offset = 1 << FL
        self.offset_ = 1<<FL_use
        self.weight_use_offset = 1 << (FL-FL_use)
        self.train = True
        
        self.bias_use = bias

        self.bias = torch.IntTensor(out_features)
        self.dw_buf0 = torch.FloatTensor(in_features,out_features).zero_().int()
        self.dw_buf1 = torch.FloatTensor(in_features,out_features).zero_().int()
        self.dw_buf2 = torch.FloatTensor(in_features,out_features).zero_().int()
        self.dw_buf3 = torch.FloatTensor(in_features,out_features).zero_().int()





    def cuda(self, device_id=None):
        self.weight = self.weight.cuda(device_id)
        self.fb_weight = self.fb_weight.cuda(device_id)
        self.bias = self.bias.cuda(device_id)
        self.dw_buf0 = self.dw_buf0.cuda(device_id)
        self.dw_buf1 = self.dw_buf0.cuda(device_id)
        self.dw_buf2 = self.dw_buf0.cuda(device_id)
        self.dw_buf3 = self.dw_buf0.cuda(device_id) 
        return
        
        
        
        return

    def forward(self, input):
        out = torch.matmul(input, (self.weight.float()/ self.weight_use_offset).floor()).int() + (self.bias.float()/self.weight_use_offset).floor().int()# Must be divided by (1<<FL_use) to recover
        if self.train:
            self.fire_p = out.clone() 
            self.il = input.clone() 
      
        return sample(out.float() / self.offset_, train=self.train)


    def record(self, input):
        """
        :param input: is the spikes of output layer
        :return:
        """
        fb = torch.matmul(input, (self.fb_weight/self.weight_use_offset).float().floor()).int() 
        self.fb_f = fb.clone()
        return

    def backward(self, input):
        """
        :param input: input is a onehot encoded vector of correct labels
        performs a backward pass
        :return:
        """
         
        out = torch.matmul(input, (self.fb_weight.float()/self.weight_use_offset).floor()).int()
       
        d = intsigdiff(self.fire_p.float() / self.offset_) * (
                intsigmoid(out.float() / self.offset_) - intsigmoid(self.fb_f.float() / self.offset_))  # (Divide by 2^20 to recover)
        
        
        dw = torch.sum(torch.bmm(self.il.unsqueeze_(2).float(), d.unsqueeze_(1).float()), 0)  # (Divide by 2^20 to recover)
        db = torch.sum(d, 0).view(self.out_features)

        dw = (dw.float() / (1 << (23 - self.FL))).round().int()
        db = (db.float() / (1 << (23 - self.FL))).round().int()
        
        dw_use = self.dw_buf3
        self.dw_buf3 = self.dw_buf2
        self.dw_buf2 = self.dw_buf1
        self.dw_buf1 = self.dw_buf0
        self.dw_buf0 = dw

        self.weight = self.weight + dw_use#(dw.float()/8).round().int()
        
        if self.bias_use:
            self.bias = self.bias + db#(db.float()/8).round().int()
        else:
            self.bias = self.bias
        return

    def __repr__(self):
        return 'StoLinear_Int({0} X {1})'.format(self.in_features, self.out_features)


class StoOutput_Int(StoLinear_Int):
    def __init__(self, *args):
        super(StoOutput_Int, self).__init__(*args)

    def forward(self, input):
        out = torch.matmul(input.float(), (self.weight.float()/self.weight_use_offset).floor()).int() + (self.bias.float()/self.weight_use_offset).floor().int()
        if self.train:
            self.fire_p = out.clone()
            self.il = input.clone()
            #self.il = torch.bernoulli(torch.FloatTensor(input.shape).zero_().add_(0.5).cuda())
        
            
        return out.float()/self.offset_

    def backward(self, input):
        input = input.int()
        d = intsigdiff(self.fire_p.float() / self.offset_) * (1024 * input - intsigmoid((self.fire_p.float()/ self.offset_).float())) 
      
       
        dw = torch.sum(torch.bmm(self.il.unsqueeze(2).float(), d.unsqueeze(1).float()), 0)
        db = torch.sum(d, 0).view(self.out_features)
        #self.upvalbuff = dw
        dw = (dw.float() / (1 << (25 - self.FL))).round().int()
        db = (db.float() / (1 << (25 - self.FL))).round().int()
        dw_use = self.dw_buf0
        self.dw_buf3 = self.dw_buf2
        self.dw_buf2 = self.dw_buf1
        self.dw_buf1 = self.dw_buf0
        self.dw_buf0 = dw
        #self.dw_buf0 = dw

        self.weight = self.weight + dw_use#(dw.float()/32).round().int()
        if self.bias_use:
            self.bias = self.bias + db#(db.float()/32).round().int()
        else:
            self.bias = self.bias
        return

    def record(self, input):
        self.fb_f = input

    def __repr__(self):
        return 'StoOutput_Int({0} X {1})'.format(self.in_features, self.out_features)
#%%
