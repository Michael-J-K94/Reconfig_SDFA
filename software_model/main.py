import torch
import torchvision
import torchvision.transforms as transforms
import numpy as np
import sys
import time
import argparse
import os
from model import *
from util import *

parser = argparse.ArgumentParser(description='Stochastic Network Training')
parser.add_argument('--gpu', default=0, type=int, help='Which GPU to use. 0~3')
parser.add_argument('--TRAIN_BS', default=20, type=int, help='Batch size')
parser.add_argument('--HS1', default=200, type=int, help='Hidden Layer 1 node size')
parser.add_argument('--HS2', default=200, type=int, help='Hidden Layer 2 node size')
parser.add_argument('--lrh', default=0.1, type=float, help='Learning rate of hidden layers')
parser.add_argument('--lro', default=0.02, type=float, help='Learning rate of output layers')
parser.add_argument('--num_sample', default=20, type=int, help='Number of samples in test')
parser.add_argument('--name', default='tmp', type=str, help='Name of your trial')
parser.add_argument('--max_epochs', default=200, type=int, help='Maximum number of epochs to run')
parser.add_argument('-d', '--dataset', default='MNIST', type=str, help='Dataset')
parser.add_argument('--graph', default=True, type=bool, help='Whether to make a training graph file')
parser.add_argument('--FL', default=11, type=int, help='Fractional Length used for integer training')
parser.add_argument('--int',default=True, help='Whether to use integers for training')
parser.add_argument('--v', default='Long', help='Display training process?')
cuda = torch.cuda.is_available()


def main():
#%%
    args = parser.parse_args()
    TRAIN_SIZE = args.TRAIN_BS
    verbose = args.v
    HS1 = args.HS1
    HS2 = args.HS2
    device_id = args.gpu
    lrh = args.lrh
    lro = args.lro
    use_int = args.int
    print(use_int)
    FL = args.FL
    num_sample = args.num_sample
    TEST_SIZE = 100
    name = args.name
    dataset = args.dataset
    max_epochs = args.max_epochs

    if not os.path.isdir('Results/' + name):
        os.mkdir('Results/' + name)

    if dataset == 'MNIST':
        transform = transforms.Compose([transforms.ToTensor()])
        trainset = torchvision.datasets.MNIST(root='./data', train=True, download=True, transform=transform)
        trainloader = torch.utils.data.DataLoader(trainset, batch_size=TRAIN_SIZE, shuffle=True, num_workers=2)
        testset = torchvision.datasets.MNIST(root='./data', train=False, transform=transform)
        testloader = torch.utils.data.DataLoader(testset, batch_size=TEST_SIZE, shuffle=False, num_workers=2)
    if use_int:
        model = StoSequential(StoLinear_Int(784,HS1,10,FL), StoLinear_Int(HS1,HS2,10,FL), StoOutput_Int(HS2,10,10,FL))
        model.apply(init_w_int)
        #model[2].weight = model[2].weight - 32
    else:
        model = StoSequential(StoLinear(784, HS1, 10, lrh), StoLinear(HS1, HS2, 10, lrh), StoOutput(HS2, 10, 10, lro))
        model.apply(init_w)
    if cuda:
        torch.cuda.set_device(device_id)
        model.cuda(device_id)
    tr_graph = []
    tt_graph = []
    model.save('Init_mem.npy')
    for e in range(max_epochs):
        #f = open('Guess_True_{0}.txt'.format(str(e)),'w')
        tr_cor = train(model, trainloader, device_id, verbose)
        tt_cor = test(model, testloader, num_sample, device_id)
        print('Epoch {0}: Training Accuracy is {1:.3f}%, Test Accuracy is {2:.3f}%'.format(e,float(tr_cor) / 600.0,
                                                                                         float(tt_cor) / 100.0))
        tr_graph.append(100 - tr_cor / 60000.0)
        tt_graph.append(100 - float(tt_cor) / 10000.0)
        if e % 10 == 0:
            model.save('Results/' + name + '/Epoch_' + str(e))
        #or th in np.arange(0.1,1,0.05):
        #    tt_cor = test(model,testloader,1, device_id, th=th)
        #    print('Test with th of {0:.3f} : {1:.3f}%'.format(th,float(tt_cor)/100.0))
    np.save('test_graph.npy',tt_graph)
#%%%

def train(model, dataloader, device_id=None, verbose='Long'):
    correct = 0
    model.apply(set_train)
    f = open('guess_True_2.txt','w')
    for j in range(4):
        outputs = model(torch.FloatTensor(1,784).zero_().cuda(device_id))
        model.record(sample(outputs))
        model.backward(torch.LongTensor([0]).cuda(device_id))
        
    for i, data in enumerate(dataloader):
            
        images, labels = data
        bs = list(images.shape)[0]
        if cuda:
            images = images.view(bs, 784).cuda(device_id)
            #if (i<10):
            #    for k in range(bs):
            #        images[k][1::4] = torch.FloatTensor(196).uniform_(0,1).cuda()
            #        images[k][2::4] = torch.FloatTensor(196).uniform_(0,1).cuda()
            #        images[k][3::4] = torch.FloatTensor(196).uniform_(0,1).cuda()



            labels = labels.cuda(device_id)
        outputs = model(sample(images, True))
        model.record(sample(outputs))
        model.backward(labels)
        _, guess = torch.max(outputs,1)
        correct += torch.sum(torch.eq(guess, labels))
        f.write('Guess Label: {0}\n'.format(str(guess[0])))
        f.write('True Label:  {0}\n'.format(str(labels[0])))
        if verbose == 'Long':
            sys.stdout.write(
                "\x1b[2K\rbatch {0}/{1}. Training accuracy: {2:05.2f}%. ".format(
                    i + 1, 60000 / bs, (100 * correct) / float((i+1) * bs)))
            sys.stdout.flush()
    f.close()
    return correct

def train_debug(model, dataloader, device_id=None, verbose='Long'):
    correct = 0
    model.apply(set_train)
   
    f = open('Debugger.txt','w')
    for i, data in enumerate(dataloader):
        images, labels = data
        bs = list(images.shape)[0]
        
        if i%1000<100:
            debug = True
        else:
            debug = False
        if cuda:
            images = images.view(bs, 784).cuda(device_id)
            labels = labels.cuda(device_id)
        outputs = model(sample(images, True))
        model.record(sample(outputs))
        f.write('IMAGE_%i\n'%i)
        fp_OL = (model[2].fire_p.view(10).cpu().numpy())
        fp_HL1 = (model[1].fire_p.view(200).cpu().numpy())
        fp_HL2 = (model[0].fire_p.view(200).cpu().numpy())
        f.write('HL1_FIRE_P\n')
        for j,fp in enumerate(fp_HL1[:10]):
            f.write('HL1_FP of %i: %i\n'%(j,fp))
        for j,fp in enumerate(fp_HL2[:10]):
            f.write('HL2_FP of %i: %i\n'%(j,fp)) 
        for j,fp in enumerate(fp_OL):
            f.write('OL_fire_p of %i: %i\n'%(j,fp))
        W2 = model[2].weight
        model.backward(labels)
        
        fb_f_HL1 = model[0].fb_f.view(200).cpu().numpy()
        fb_f_HL2 = model[1].fb_f.view(200).cpu().numpy()
      
        
        fb_b_HL1 = model[0].fb_b.view(200).cpu().numpy()
        fb_b_HL2 = model[1].fb_b.view(200).cpu().numpy()
       
        f.write('\n') 
        for j,fb_f in enumerate(fb_f_HL1[:10]):
            f.write('HL1_fb_f of %i: %i\n'%(j,fb_f))
        for j,fb_f in enumerate(fb_f_HL2[:10]):
            f.write('HL2_fb_f of %i: %i\n'%(j,fb_f)) 
        
        f.write('\n')
        
        for j,fb_b in enumerate(fb_b_HL1[:10]):
            f.write('HL1_fb_b of %i: %i\n'%(j,fb_b))
        for j,fb_b in enumerate(fb_b_HL2[:10]):
            f.write('HL2_fb_b of %i: %i\n'%(j,fb_b)) 
      
        f.write('\n')
         
        upvalbuff_HL1 = (model[0].upvalbuff).int().cpu().numpy().transpose().mean(axis=1)
        Y3_HL1 = (model[0].y3).int().cpu().numpy().transpose().mean(axis=1)
        Y_sub_HL1 = (model[0].y_sub).int().cpu().numpy().transpose().mean(axis=1)
       
        upvalbuff_HL2 = (model[1].upvalbuff).int().cpu().numpy().transpose().mean(axis=1)
        Y3_HL2 = (model[1].y3).int().cpu().numpy().transpose().mean(axis=1)
        Y_sub_HL2 = (model[1].y_sub).int().cpu().numpy().transpose().mean(axis=1)
          

        upvalbuff = (model[2].upvalbuff).int().cpu().numpy().transpose().mean(axis=1)
        Y3 = (model[2].y3).int().cpu().numpy().transpose().mean(axis=1)
        Y_sub = (model[2].y_sub).int().cpu().numpy().transpose().mean(axis=1)
            
        
        for j, y3 in enumerate(Y3_HL1[:10]):
            f.write('HL_y3 of %i: %i\n'%(j,int(y3)))
        for j, y_sub in enumerate(Y_sub_HL1[:10]):
            f.write('HL_y_sub of %i: %i\n'%(j,int(y_sub)))
        for j, upvalbuf in enumerate(upvalbuff_HL1[:10]):
            f.write('HL_upvalbuff of %i: %i\n'%(j,int(upvalbuf)))                
        
        f.write('\n')
        for j, y3 in enumerate(Y3_HL2[:10]):
            f.write('HL_y3 of %i: %i\n'%(j,int(y3)))
        for j, y_sub in enumerate(Y_sub_HL2[:10]):
            f.write('HL_y_sub of %i: %i\n'%(j,int(y_sub)))
        for j, upvalbuf in enumerate(upvalbuff_HL2[:10]):
            f.write('HL_upvalbuff of %i: %i\n'%(j,int(upvalbuf)))                
        
        f.write('\n')
        
        for j, y3 in enumerate(Y3):
            f.write('OL_y3 of %i: %i\n'%(j,int(y3)))
        for j, y_sub in enumerate(Y_sub):
            f.write('OL_y_sub of %i: %i\n'%(j,int(y_sub)))
        for j, upvalbuf in enumerate(upvalbuff):
            f.write('OL_upvalbuff of %i: %i\n'%(j,int(upvalbuf)))                
        
        
        f.write('\n')
        time.sleep(0.01)
        _, guess = torch.max(outputs,1)
        correct += torch.sum(torch.eq(guess, labels))
        #if debug:
            
        f.write('Guess Label: {0}\n'.format(str(guess[0])))
        f.write('True Label:  {0}\n\n\n\n'.format(str(labels[0])))
        if verbose == 'Long':
            sys.stdout.write(
                "\x1b[2K\rbatch {0}/{1}. Training accuracy: {2:05.2f}%. ".format(
                    i + 1, 60000 / bs, (100 * correct) / float((i + 1) * bs)))
            sys.stdout.flush()
    f.close()
    return correct




def test(model, dataloader, num_sample=10, device_id=None, th=0.7):
    correct = 0
    model.apply(set_test)
    for i, data in enumerate(dataloader):
        images, labels = data
        if cuda:
            images = images.view(list(images.shape)[0], 784).cuda(device_id)
            labels = labels.cuda(device_id)

        outputs = torch.FloatTensor(list(images.shape)[0], 10).zero_().cuda()
        for i in range(num_sample):
            outputs += model(sample(images,train=False,is_input=True,th=th))
        _, guess = torch.max(outputs,1)
        correct += torch.sum(torch.eq(guess, labels))
    return correct


if __name__ == '__main__':
    main()
#%%
