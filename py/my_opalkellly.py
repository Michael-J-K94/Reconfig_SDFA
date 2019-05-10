import sys
import numpy as np
import ok
import time

# Data Set path
MNIST_TEST_FILE = 'MNIST_TEST.txt'
MNIST_TEST_LABEL_FILE = 'MNIST_TEST_labels.txt'

# return bytearray list data that read txt file
MEMORY_INIT_FILE = ['BLOCK_0_Weights.txt','BLOCK_1_Weights.txt','BLOCK_2_Weights.txt','BLOCK_3_Weights.txt',
                    'BLOCK_4_Weights.txt','BLOCK_5_Weights.txt','BLOCK_6_Weights.txt','BLOCK_7_Weights.txt',
                    'BLOCK_8_Weights.txt']
USING_BLOCK = [0, 1, 2, 3, 4, 5, 8]

MASTER_SETUP_FILE = 'master_inform.txt'
BLOCK_SETUP_FILE = 'block_inform.txt'
CONVERTER_SETUP_FILE = 'setup_inform.txt'


def Read_data(path):
	data_bit = []
	with open(path, 'r') as f :
		feature_data = f.read()
		feature_data = feature_data.replace('\n', '')
		data_bit = [feature_data[i:i+2] for i in range(0, len(feature_data), 2)]

		data = []
		for db in data_bit:
			data.append(int(db, 16))

		data = bytearray(data)
		#addr, block size, data
		# xem.WriteToBlockPipeIn(0x80, 128, data)
	return data

def accuracy_calib(out, labels, offset):
	correct = 0
	for i in range(len(out)):
		maxIndex = int(out[i], 2)
		trueIndex = labels[i-offset] # 4개 뒤 label이랑 matching # TO DO
		if(maxIndex == trueIndex) :
			correct +=1
	return correct

def accuracy(mylist, labels):
	count = 0
	for i in range(len(labels)):
		if(labels[i] == mylist[i]):
			count = count + 1

	return count / float(len(labels))

# return accuracy comparing my list with the txt
def compare(mylist, path):
	labels_int = []
	with open(path, 'r') as f:
		labels = f.read()
		labels = labels.split()
		for l in labels:
			labels_int.append(int(l, 2))

		return accuracy(mylist, labels_int) * 100

def connect(xem) :
	deviceCount = xem.GetDeviceCount()
	for i in range(deviceCount):
		print ('Device[{0}] Model: {1}'.format(i, xem.GetDeviceListModel(i)))
		print ('Device[{0}] Serial: {1}'.format(i, xem.GetDeviceListSerial(i)))
	# open device
	is_open = xem.OpenBySerial("")
	if is_open == 0:
		print("Device is opened")
	else:
		print("Device COnnection ERROR")

def configure(xem) :
	error = xem.ConfigureFPGA(OK_BIT_FILE)
	if error == 0:
		print("Input bit file is connected to the device!")
	else:
		print("Configure ERROR")

	if xem.IsFrontPanelEnabled():
		 print ("FrontPanel host interface enabled.")
	else:
		print("FrontPanel ERROR")


def reset(xem):
	xem.SetWireInValue(0x00, 0x00000001)            # fifo reset high
	xem.SetWireInValue(0x01, 0x00000001)            # rstn reset high
	xem.UpdateWireIns()
	time.sleep(0.001)
	xem.SetWireInValue(0x00, 0x00000000)            # fifo reset low
	xem.SetWireInValue(0x01, 0x00000000)            # rstn set low
	xem.SetWireInValue(0x02, 0x00000000)            # train low
	xem.UpdateWireIns()
	time.sleep(0.001)
	xem.SetWireInValue(0x01, 0x00000001)            # rstn set high
	xem.UpdateWireIns()
	time.sleep(0.001)

def ok_init(xem) :
	connect(xem)
	configure(xem)

# Just load opal kelly
# It will initialize by self
def load_device():
	xem = ok.okCFrontPanel()
	ok_init(xem)
	reset(xem)
	return xem

def mem_init(xem, blk_array) :
    for f in range(0, 9):
        if f in blk_array :
            mem_init = []
            with open(MEMORY_INIT_FILE[f], 'r') as f_init :
                mem_init = f_init.read()
                mem_init = mem_init.split()
            mem_init_barray = []
            for i, w in enumerate(mem_init) :
                for j in range(0, len(w), 8) :
                    mem_init_barray.append(int(w[j:j+8],2))

            for i in range(0, len(mem_init_barray), 256) :
                xem.WriteToBlockPipeIn(0x81, 64, bytearray(mem_init_barray[i:i+256]))

        else :
            if (f == 8):
                size = 35840
            else:
                size = 114688

            for i in range(0, size, 256) :
                xem.WriteToBlockPipeIn(0x81, 64, bytearray(256))

def part_init(xem, SETUP_FILE, addr) :
    part_init = []
    with open(SETUP_FILE, 'r') as f_init :
        part_init = f_init.read()
        part_init = part_init.split()

    part_init_barray = []
    for i, w in enumerate(part_init) :
        part_init_barray.append(int(w,2))

    xem.WriteToBlockPipeIn(addr, 32, bytearray(part_init_barray))

def run_test(xem, testset, labelset):
	data = Read_data(testset)
	n = 784 # byte
	FPGA_out = bytearray(40000) # 4 * 10000 byte
	for i in range(len(data)):
		# push data
		xem.WriteToBlockPipeIn(0x80, 128, data[i:i+n]) # a feature
		# pop data
		xem.ReadFromBlockPipeOut(0xa0, 64, FPGA_out)
		my_list = [bin(x)[2:].zfill(8) for x in list(FPGA_out)[0::4]]

		accuracy = compare(my_list, labelset)
		print(accuracy)

def main():
	xem = load_device()

	mem_init(xem, USING_BLOCK)
	part_init(xem, MASTER_SETUP_FILE, '0x82')
	part_init(xem, BLOCK_SETUP_FILE, '0x83')
	part_init(xem, CONVERTER_SETUP_FILE, '0x84')

	run_test(xem, MNIST_TEST_FILE, MNIST_TEST_LABEL_FILE)


if __name__ == '__main__':
	main()
