# -*- coding: utf-8 -*-
"""
Created on 2019 2 14

@author: Yeonsoo Jeon
"""
import sys
import numpy as np
import ok
import time

OK_BIT_FILE = 'bf_a75_test.bit'
MEMORY_INIT_FILE = 'mem_dump.txt.2'
TRAIN_IMAGE_FILE = 'MNIST_BYTEARRAY_TRAIN_1line.txt'
TRAIN_LABEL_FILE = 'MNIST_labels_60000.txt'
TEST_IMAGE_FILE = 'MNIST_BYTEARRAY_TEST_1line.txt'
TEST_LABEL_FILE = 'MNIST_TEST_labels.txt'
OUTPUT_LOG_FILE = 'stonet_output.txt'

WRITE_BLOCK_SIZE_BYTES = 256
READ_BLOCK_SIZE_BYTES = 64
#%%
def connect(xem) :
    deviceCount = xem.GetDeviceCount()
    for i in range(deviceCount):
        print ('Device[{0}] Model: {1}'.format(i, xem.GetDeviceListModel(i)))
        print ('Device[{0}] Serial: {1}'.format(i, xem.GetDeviceListSerial(i)))
    # open device
    is_open = xem.OpenBySerial("")
    if is_open == 0:
        print("Device is opened")

def configure(xem) :
    error = xem.ConfigureFPGA(OK_BIT_FILE)
    if error == 0:
        print("Input bit file is connected to the device!")
    if xem.IsFrontPanelEnabled():
         print ("FrontPanel host interface enabled.")

def ok_init(xem) :
    connect(xem)
    configure(xem)

def reset(xem):
    xem.SetWireInValue(0x00, 0x00000001)            # fifo reset high
    xem.SetWireInValue(0x01, 0x00000001)            # rstn reset high
    xem.UpdateWireIns()
    time.sleep(0.001)
    xem.SetWireInValue(0x00, 0x00000000)            # fifo reset low
    xem.SetWireInValue(0x01, 0x00000000)            # rstn set low
    xem.SetWireInValue(0x02, 0x00000000)            # train low
    # xem.SetWireInValue(0x03, 0x00000000)
    # xem.SetWireInValue(0x04, 0x00000000)
    # xem.SetWireInValue(0x06, 0x00000000)
    xem.UpdateWireIns()
    time.sleep(0.001)
    xem.SetWireInValue(0x01, 0x00000001)            # rstn set high
    xem.UpdateWireIns()
    time.sleep(0.001)

def pause(xem, n) :

    xem.SetWireInValue(0x02, n)
    xem.UpdateWireIns()

# def train(xem, n) :
#     xem.SetWireInValue(0x03, n)
#     xem.UpdateWireIns()

def infer(xem, n) :
    xem.SetWireInValue(0x04, n)
    xem.UpdateWireIns()

# Don't need to initialize memory
def memory_init(xem) :
    mem_init = []
    with open(MEMORY_INIT_FILE, 'r') as f_init :
        mem_init = f_init.read()
        mem_init = mem_init.split()

    mem_init_barray = []

    for i, l in enumerate(mem_init) :
        mem_init_barray.append(int(l[6:],2))
        mem_init_barray.append(int('1'+l[:6],2))
        mem_init_barray.append(0)
        mem_init_barray.append(0)

    for j in range(32) :
        mem_init_barray.append(0)
        mem_init_barray.append(64)
        mem_init_barray.append(0)
        mem_init_barray.append(0)

    for i in range(0,466) :
        num = i*2048
        if(xem.WriteToBlockPipeIn(0x83, 64, bytearray(mem_init_barray[num:num+2048])) != 2048) :
            print('breaking')
            break
    xem.UpdateWireOuts()
    init_fin = xem.GetWireOutValue(0x2e)
    init_cycle_count = xem.GetWireOutValue(0x2f)
    if(init_fin==1) :
        print ('MEMORY INITIALIZE SUCCESS !!!, init_count : {}'.format(init_cycle_count))
    else :
        print ('MEMORY INITIALIZE FAIL !!!, init_count : {}'.format(init_cycle_count))

def two2dec(s):
  if s[0] == '1':
    return -1 * (int(''.join('1' if x == '0' else '0' for x in s), 2) + 1)
  else:
    return int(s, 2)

def get_IR(xem):
    xem.UpdateWireOuts()
    return xem.GetWireOutValue(0x23)


def get_LR(xem):
    xem.UpdateWireOuts()
    return xem.GetWireOutValue(0x22)

def get_TA(xem):
    xem.UpdateWireOuts()
    return xem.GetWireOutValue(0x34)

def get_OV(xem):
    xem.UpdateWireOuts()
    return xem.GetWireOutValue(0x35)


def fifo_reset(xem):
    xem.SetWireInValue(0x00, 0x00000001)
    xem.UpdateWireIns()
    time.sleep(0.001)
    xem.SetWireInValue(0x00, 0x00000000)
    xem.UpdateWireIns()
    time.sleep(0.001)
    return

# def accuracy_old(deci, labels) :
#     trueIndex = 0
#     maxIndex = 0
#     correct = 0
#     for i in range(0,len(labels)/16) :
#         for j in range(0,160,10) :
#             if(i==0 and j < 40) :
#                 pass
#             else :
#                 maxIndex = np.asarray(deci[i][j:j+10]).argmax()
#                 trueIndex = int(labels[j/10 + i*16-4], 2)
#                 if(maxIndex == trueIndex) :
#                     correct += 1

#     return correct / float(len(labels))
# #%%
def accuracy(out, labels, TYPE) :
    correct = max([accuracy_calib(out,labels,offset) for offset in range(2,6)])
    return correct / float(len(out))


def accuracy_calib(out, labels, offset):
    correct = 0
    for i in range(len(out)):
        maxIndex = int(out[i], 2)
        trueIndex = labels[i-offset] # 4개 뒤 label이랑 matching
        if(maxIndex == trueIndex) :
            correct +=1
    return correct

def decode_bin(labels):
    return np.asarray([int(label,2) for label in labels])


#%%
def load_images(i=0, path='data/'):
	train_img1 = bytearray(open(path+'train_imgs1_%i'%i,'rb').read())
	train_img2 = bytearray(open(path+'train_imgs2_%i'%i,'rb').read())
	test_img1 = bytearray(open(path+'test_imgs1','rb').read())
	test_img2 = bytearray(open(path+'test_imgs2','rb').read())
	train_labels = np.load(path+'train_labels_%i.npy'%i)
	test_labels = np.load(path+'test_labels.npy')
	return train_img1, train_img2, test_img1, test_img2, train_labels, test_labels


#%%
def load_device():
	xem = ok.okCFrontPanel()
	ok_init(xem)
	reset(xem)
	return xem


#%%
def mem_init(xem):
    memory_init(xem)


#%%
def run_full_train(xem, tt_pack, epoch=200):
    train_buf = bytearray(240000)
    test_buf = bytearray(40000)
    train_img1, train_img2, test_img1, test_img2, train_labels, test_labels = tt_pack

    for i in range(epoch):
        fifo_reset(xem)
        train(xem, 1)
        xem.WriteToBlockPipeIn(0x81, 128, bytearray(train_labels.tobytes()))                    # 128 = 4bytes*32 words, 240000/128 = 1875
        t0 = time.time()
        xem.WriteToBlockPipeIn(0x80, WRITE_BLOCK_SIZE_BYTES*2, train_img1)  # 512 = 4bytes*128 words, 47040000/512 = 91875
        t_train = time.time() - t0
        xem.WriteToBlockPipeIn(0x80, 64, train_img2)
        xem.ReadFromBlockPipeOut(0xa1, 128, train_buf)
        out_train = [bin(x)[2:].zfill(8) for x in list(train_buf)[0::4]]
        fifo_reset(xem)
        train(xem, 0)
        pause(xem, 1)
        time.sleep(0.001)
        fifo_reset(xem)
        #------------------------------TEST LOOP-------------------------------
        pause(xem, 0)
        infer(xem, 1)
    #for i in range(20):
        xem.WriteToBlockPipeIn(0x81, 64, bytearray(test_labels))                      # 64 = 4bytes*16 words, 40000/64 = 625
        xem.WriteToBlockPipeIn(0x80, WRITE_BLOCK_SIZE_BYTES, test_img1)     # 256 = 4bytes*64 words, 7840000/256 = 30625
        xem.WriteToBlockPipeIn(0x80, 32, test_img2)
        xem.ReadFromBlockPipeOut(0xa1, 64, test_buf)
        out_test = [bin(x)[2:].zfill(8) for x in list(test_buf)[0::4]]

        train_accuracy = accuracy(out_train, train_labels, 'TRAIN')*100
        test_accuracy = accuracy(out_test, test_labels, 'TEST')*100

        sys.stdout.write("\x1b[1A\x1b[2K\rEpoch : {0}/{1}\tTraining Accuracy : {2:.3f} %\tTest Accuracy : {3:.3f} %\t, Epoch Time: {4:.3f}".
                 format(i+1, epoch, train_accuracy, test_accuracy, t_train))

        pause(xem, 1)
        fifo_reset(xem)
        #print('test finished')
        time.sleep(0.001)
        pause(xem, 0)
        infer(xem, 0)


def run_single_train(xem, tt_pack):
    train_img1, train_img2, test_img1, test_img2, train_labels, test_labels = tt_pack
    train_buf = bytearray(240000)
    fifo_reset(xem)
    train(xem, 1)
    xem.WriteToBlockPipeIn(0x81, 128, bytearray(train_labels.tobytes()))                    # 128 = 4bytes*32 words, 240000/128 = 1875
    t0 = time.time()
    xem.WriteToBlockPipeIn(0x80, WRITE_BLOCK_SIZE_BYTES*2, train_img1)  # 512 = 4bytes*128 words, 47040000/512 = 91875
    get_levels(xem)
    t1 = time.time() - t0
    xem.WriteToBlockPipeIn(0x80, 64, train_img2)
    xem.ReadFromBlockPipeOut(0xa1, 128, train_buf)
    out_train = [bin(x)[2:].zfill(8) for x in list(train_buf)[0::4]]
    fifo_reset(xem)
    train(xem, 0)
    pause(xem, 1)
    time.sleep(0.001)
    fifo_reset(xem)
    train_accuracy = accuracy(out_train, train_labels, 'TRAIN')*100
    return train_accuracy, t1


def run_single_test(xem, tt_pack):
    test_buf = bytearray(40000)
    train_img1, train_img2, test_img1, test_img2, train_labels, test_labels = tt_pack
    pause(xem, 0)
    infer(xem, 1)
#for i in range(20):
    xem.WriteToBlockPipeIn(0x81, 64, bytearray(test_labels))
    t0 = time.time()                  # 64 = 4bytes*16 words, 40000/64 = 625
    xem.WriteToBlockPipeIn(0x80, WRITE_BLOCK_SIZE_BYTES, test_img1)     # 256 = 4bytes*64 words, 7840000/256 = 30625
    t1 = time.time() - t0
    xem.WriteToBlockPipeIn(0x80, 32, test_img2)
    xem.ReadFromBlockPipeOut(0xa1, 64, test_buf)
    out_test = [bin(x)[2:].zfill(8) for x in list(test_buf)[0::4]]
    test_accuracy = accuracy(out_test, test_labels, 'TEST')*100
    pause(xem, 1)
    fifo_reset(xem)
    #print('test finished')
    time.sleep(0.001)
    pause(xem, 0)
    infer(xem, 0)
    return test_accuracy, t1

def get_levels(xem):
    xem.UpdateWireOuts()
    #print(xem.GetWireOutValue(0x37))
    #print(xem.GetWireOutValue(0x38))
    #print(xem.GetWireOutValue(0x39))
    #olevel = [xem.GetWireOutValue(i) for i in range(55, 64)]
    #olevel.append(xem.GetWireOutValue(0x27))
    output_levels = [decode_out(xem.GetWireOutValue(i)) for i in range(55,64)]
    output_levels.append(decode_out(xem.GetWireOutValue(0x27)))
    return softmax(output_levels)
    #return olevel


def find_confidences(xem, drawing):
    '''
    Reset fifo , and adjust ctrl signals as same as test phase
    Inputs a drawing of 28 * 28 ; and Sample/Pack into 1-bit values.
    Sends that image through BlockPipeIn module
    Read out right after, through get_levels (returns softmax value)
    '''
    test_buf = bytearray(256)
    pause(xem, 0)
    infer(xem, 1)
    encoded_barray = encode_barray(drawing)
    xem.WriteToBlockPipeIn(0x80, 256, encoded_barray)
    #drawn_image  # Drawn image should be sampled here
    o_levels = get_levels(xem)
    xem.ReadFromBlockPipeOut(0xa1, 64, test_buf)
    pause(xem, 1)
    fifo_reset(xem)
    time.sleep(0.001)
    infer(xem, 1)
    pause(xem, 0)
    return o_levels



def main():
    #tt_pack = load_images()
    xem = load_device()
    memory_init(xem)
    max_epoch = 1
    for e in range(max_epoch):
        tt_pack = load_images(i=e%50, path='new_data/')
        tr_acc, tr_t = run_single_train(xem, tt_pack)
        te_acc, te_t = run_single_test(xem, tt_pack)
        sys.stdout.write("\x1b[1A\x1b[2K\rEpoch : {0}/{1}\tTraining Accuracy : {2:.3f} %\tTest Accuracy : {3:.3f} %\t, Train Time: {4:.3f}, Test Time: {5:.3f}".
                 format(e, max_epoch, tr_acc, te_acc, tr_t, te_t))
#%%
def softmax(nparr):
    return np.exp(nparr)/np.sum(np.exp(nparr))

def decode_out(val):
    bits = 10
    if (val & (1<<(bits-1))) != 0:
        val = val - (1<<bits)
    return float(val)/128.0
#%%
def decode_barray(bytearr):
    nparr = np.zeros(784)
    x = np.asarray(bytearray(bytearr), dtype='uint8')
    for i in range(7,-1,-1):
        nparr[i::8] = x % 2
        x = x // 2
    return 255 * nparr

def encode_barray(nparr):
    '''
    numpy array to byte-type list.
    '''
    x = np.asarray(np.greater(nparr,128),dtype='uint8').reshape(98,8)
    k = np.power(0.5, range(-7,1,1))
    y = np.matmul(x, k).reshape(98)
    return bytearray(list(np.asarray(y,dtype='uint8'))*256)

if __name__ == '__main__':
    main()
