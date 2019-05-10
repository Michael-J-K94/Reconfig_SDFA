
"""
Created on Mon Apr 16 20:42:52 2018

Creater : Jeongwoo Park (jeffjw@snu.ac.kr)

Usage: python autopad.py [file_name]
Will create [file_name]_padded.v file.
Input file should only include single module!
Errors could arise if file contiains "module" outside of top module declaration. 
(ex: having variable named "a_module", or comment that includes the word "module") 
It will not be a critical error, only that the created module name might be weird.

If '^M' is added at *_padded.v file, to remove this check out:
    http://mwultong.blogspot.com/2007/08/vim-vi-m-m.html



"""
import sys
file = sys.argv[1]

try:
    CORE_VDD_NUM = int(sys.argv[2])
except:
    print('No CORE_VDD_NUM was specified. Defaults to CORE_VDD_NUM=4...')
    CORE_VDD_NUM = 4
try:
    RING_VDD_NUM = int(sys.argv[3])
except:
    print('No RING_VDD_NUM was specified. Defaults to RING_VDD_NUM=4...')
    RING_VDD_NUM = 4

def trim(line):
    return line.replace(' ','').replace('\t','').replace('\n','').replace(';','')

with open(file) as f:
    lines = f.readlines()

#Finding input/output specs.
inputs = dict()
outputs = dict()

for line in lines:
    if (line.find('module ')!=-1 and line.find('endmodule')==-1):
        moduleline = line
        tt = trim(line).split('module')[1]
        modulename = tt[:tt.find('(')]
    if line.find(' input ')!=-1:
        if line.find('[')==-1:
            in_vars = trim(line.replace(' input ','')).split(',')
            width = 1
            for in_var in in_vars:
                inputs[in_var] = width
        else:
            start = line.find('[')+1
            end = line.find(']')
            x = line[start:end].split(':')
            width = abs(int(x[1])-int(x[0]))+1
            in_vars = trim(line).split(']')[-1].split(',')
            for in_var in in_vars:
                inputs[in_var] = width
    if line.find(' output ')!=-1:
        if line.find('[')==-1:
            out_vars = trim(line.replace(' output ','')).split(',')
            width = 1
            for out_var in out_vars:
                outputs[out_var] = width
        else:
            start = line.find('[')+1
            end = line.find(']')
            x = line[start:end].split(':')
            width = abs(int(x[1])-int(x[0]))+1
            out_vars = trim(line).split(']')[-1].split(',')
            for out_var in out_vars:
                outputs[out_var] = width


lines = []
#I/O Declarations
lines.append('module %s_padded (\n'%modulename)
for key in inputs.keys():
    lines.append('\t\tBD_to_PAD_%s,\n'%key)
lines.append('\n')
for key in outputs.keys():
    lines.append('\t\tPAD_to_BD_%s,\n'%key)
lines[-1] = lines[-1].replace(',\n',' );\n')
lines.append('\n')

for key in inputs.keys():
    if inputs[key]==1:
        lines.append('\tinput BD_to_PAD_%s;\n'%key)
    else:
        lines.append('\tinput [%i:0] BD_to_PAD_%s;\n'%(inputs[key]-1, key))
lines.append('\n')
for key in outputs.keys():
    if outputs[key]==1:
        lines.append('\toutput PAD_to_BD_%s;\n'%key)
    else:
        lines.append('\toutput [%i:0] PAD_to_BD_%s;\n'%(outputs[key]-1, key))

lines.append('\n')

lines.append('\t//PAD_to_DUT input pad wire declaration\n')
for key in inputs.keys():
    if inputs[key]==1:
        lines.append('\twire PAD_to_DUT_%s;\n'%key)
    else:
        lines.append('\twire [%i:0] PAD_to_DUT_%s;\n'%(inputs[key]-1, key))
        
lines.append('\n')
lines.append('\t//DUT_to_PAD output pad wire declaration\n')

for key in outputs.keys():
    if outputs[key]==1:
        lines.append('\twire DUT_to_PAD_%s;\n'%key)
    else:
        lines.append('\twire [%i:0] DUT_to_PAD_%s;\n'%(outputs[key]-1, key))
        
lines.append('\n\t//Input pads\n')
for key in inputs.keys():
    if inputs[key]==1:
        lines.append("\tPDDW0204CDG PAD_IN_{0}\t(.PAD(BD_to_PAD_{0}), .C(PAD_to_DUT_{0}), .OEN(1'b1), .DS(1'b0), .I(1'b0), .IE(1'b1), .PE(1'b1));\n".format(key))
    else:
        for i in range(inputs[key]):
            lines.append("\tPDDW0204CDG PAD_IN_{0}_{1}\t(.PAD(BD_to_PAD_{0}[{1}]), .C(PAD_to_DUT_{0}[{1}]), .OEN(1'b1), .DS(1'b0), .I(1'b0), .IE(1'b1), .PE(1'b1));\n".format(key,i))

lines.append('\n')
lines.append('\t//Output pads\n')

for key in outputs.keys():
    if outputs[key]==1:
        lines.append("\tPDDW0204CDG PAD_OUT_{0}\t(.PAD(PAD_to_BD_{0}), .I(DUT_to_PAD_{0}), .OEN(1'b0), .DS(1'b1), .IE(1'b0), .PE(1'b1));\n".format(key))
    else:
        for i in range(outputs[key]):
            lines.append("\tPDDW0204CDG PAD_OUT_{0}_{1}\t(.PAD(PAD_to_BD_{0}[{1}]), .I(DUT_to_PAD_{0}[{1}]), .OEN(1'b0), .DS(1'b1),  .IE(1'b0), .PE(1'b1));\n".format(key,i))

lines.append('\n\t//Power rings and ESD protection\n')
lines.append('\tPCLAMP1ANA CORE_ESD_PROTECTION();\n')
lines.append('\tPCLAMP2ANA IO_ESD_PROTECTION();\n')
lines.append('\n\t//Core VDD\n')
for i in range(CORE_VDD_NUM):
    lines.append('\tPVDD2ANA PAD_POWER_VDD_CORE_%i ();\n'%(i))

lines.append('\n\t//Core VSS\n')
for i in range(CORE_VDD_NUM):
    lines.append('\tPVSS2ANA PAD_POWER_VSS_%i ();\n'%(i))

lines.append('\n\t//clean VDD on RING\n')
for i in range(RING_VDD_NUM):
    lines.append('\tPVDD2CDG PADRING_CVDD_%i ();\n'%(i))
lines.append('\n\t//dirty VDD on RING\n')
for i in range(RING_VDD_NUM):
    lines.append('\tPVDD2CDG PADRING_DVDD_%i ();\n'%(i))
lines.append('\n\t//PADRING VSS\n')
for i in range(RING_VDD_NUM):
    lines.append('\tPVSS2CDG PADRING_VSS_%i ();\n'%(i))

lines.append('\n\t//PAD CORNERS\n')
lines.append('\tPCORNER PADRING_CORNER_LT ();\n')
lines.append('\tPCORNER PADRING_CORNER_LB ();\n')
lines.append('\tPCORNER PADRING_CORNER_RT ();\n')
lines.append('\tPCORNER PADRING_CORNER_RB ();\n')




lines.append('\n\ttop dut(')
for key in inputs.keys():
    lines.append('.{0}(BD_to_PAD_{0}), '.format(key))
    
for key in outputs.keys():
    lines.append('.{0}(PAD_to_BD_{0}), '.format(key)) 



lines[-1] = lines[-1].replace(',',');\n\n');
lines.append('endmodule')


fw = open(modulename+'_padded.v','w')

for line in lines:
    fw.write(line)
fw.close()
