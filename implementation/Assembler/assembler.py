#todo
    #need correct split lines


import os
import re
import argparse 

def openFileWrite(file_name):
    temp_file = open(file_name, 'w')

def openFileRead(file_name):
    temp_file = open(file_name, 'r')
    
def closeFile():
    temp_file.close()
    
def main():

    label_dict = dict()
    line_num = 0
    
    #remove sids
    temp_file = open(temp_file_name, 'r')
    #fix formatting and find labels
    Lines = temp_file.readlines()
    temp_file.close()
    temp_file = open(temp_file_name, 'w')
    for line in Lines:
        #remove sid
        regLine = re.sub('[SID]', "", line)
        if sidless:
            outputFile.write(regLine)
        temp_file.write(regLine)
    temp_file.close()
    
    
    
    temp_file = open(temp_file_name, 'r')
    #fix formatting and find labels
    Lines = temp_file.readlines()
    temp_file.close()
    temp_file = open(temp_file_name, 'w')
    for line in Lines:
        #fix reg alises
        regLine = re.sub(r'zero', "0", line)
        regLine = re.sub(r'ra', "1", regLine)
        regLine = re.sub(r'sp', "2", regLine)
        regLine = re.sub(r't0', "3", regLine)
        regLine = re.sub(r't1', "4", regLine)
        regLine = re.sub(r't2', "5", regLine)
        regLine = re.sub(r't3', "6", regLine)
        regLine = re.sub(r't4', "7", regLine)
        regLine = re.sub(r't5', "8", regLine)
        regLine = re.sub(r't6', "9", regLine)
        regLine = re.sub(r'arg0', "10", regLine)
        regLine = re.sub(r'ret0', "10", regLine)
        regLine = re.sub(r'arg1', "11", regLine)
        regLine = re.sub(r'ret1', "11", regLine)
        regLine = re.sub(r's0', "12", regLine)
        regLine = re.sub(r's1', "13", regLine)
        regLine = re.sub(r's2', "14", regLine)
        regLine = re.sub(r'ass', "15", regLine)
        #no clue what this line does
        splitLine = re.split(',|\(|\)', regLine)

        #adds label definitons to dictionary
        match = re.search('^[a-zA-Z0-9]+:$', line)
        if match:
            # Store label location in dictionary
            label = match.group().rstrip(':')
            label_dict[label] = line_num
        temp_file.write(regLine)
        line_num += 1
        
    

    temp_file.close()
    
    #fix labels
    print(label_dict)
    temp_file = open(temp_file_name, 'r')
    Lines = temp_file.readlines()
    temp_file.close()
    
    #quit()
    
    
    temp_file = open(temp_file_name , 'w')
    line_num = 0
    for line in Lines:
        
        # Check for label
        match = re.search('^[a-zA-Z0-9]+:$', line)
        if match:
            # print(line + "aaaa")
            # Skip label defenition lines
            continue
        # Check for jump/branch instructions
        elif re.search('^(beq|bge|blt)', line, re.IGNORECASE): #may need to add jalr back here depending how it goes
            # print('found')
            # Split instruction into parts
            parts = line.split()
            # Check for label operand
            label = parts[-1]
            label = re.sub(":", "", label)
            print(label)
            # print(label_dict)
            if label in label_dict:
                # Calculate offset from current line to label
                offset = (label_dict[label] - line_num)
                if(offset > 0):
                    offset -= 1
                
                # Replace label with offset in instruction
                parts[-1] = ' ' + str(offset) + '\n'
                print(offset)
                line = ''.join(parts)
        # if(verbose_mode):
            # print(line)
        temp_file.write(line)

        line_num += 1


    temp_file.close()
    #quit()
    #fix formatting
    temp_file = open(temp_file_name, 'r')
    #fix formatting and find labels
    Lines = temp_file.readlines()
    temp_file.close()
    temp_file = open(temp_file_name, 'w')
    for line in Lines:
        #regLine = re.sub('[ ]', "", line)
        regLine = re.sub(r'\t', "", line)
        regLine = regLine.lower()
        temp_file.write(regLine)
    temp_file.close()
    
    # quit()
    

    temp_file = open(temp_file_name, 'r')
    Lines = temp_file.readlines()
    temp_file.close()

    #assemble
    for line in Lines:
        splitLine = re.split(',|\(|\)', line)
        
        splitLine = [item.replace(" ", "").replace("\n", "") for item in splitLine]
        print(splitLine)
        
        regLine = splitLine[0]
        
        if(regLine[0:4] == 'addi'):
            iType('1100', int(splitLine[0][4:(len(splitLine[0]))]), int(splitLine[1]))
        elif(regLine[0:4] == 'slli'):
            iType('1110', int(splitLine[0][4:(len(splitLine[0]))]), int(splitLine[1]))
        elif(regLine[0:4] == 'srli'):
            iType('1101', int(splitLine[0][4:(len(splitLine[0]))]), int(splitLine[1]))
        elif(regLine[0:3] == 'lui'):
            iType('1111', int(splitLine[0][3:(len(splitLine[0]))]), int(splitLine[1]))
        elif(regLine[0:3] == 'add'):
            rType('0000', int(splitLine[0][3:(len(splitLine[0]))]), int(splitLine[1]), int(splitLine[2]))
        elif(regLine[0:3] == 'sub'):
            rType('0001', int(splitLine[0][3:(len(splitLine[0]))]), int(splitLine[1]), int(splitLine[2]))
        elif(regLine[0:3] == 'xor'):
            rType('0010', int(splitLine[0][3:(len(splitLine[0]))]), int(splitLine[1]), int(splitLine[2]))
        elif(regLine[0:2] == 'or'):
            rType('0011', int(splitLine[0][2:(len(splitLine[0]))]), int(splitLine[1]), int(splitLine[2]))
        elif(regLine[0:3] == 'and'):
            rType('0100', int(splitLine[0][3:(len(splitLine[0]))]), int(splitLine[1]), int(splitLine[2]))
        elif(regLine[0:3] == 'tst'):
            rType('0101', 15, int(splitLine[0][3:(len(splitLine[0]))]), int(splitLine[1]))
        elif(regLine[0:2] == 'lw'):
            sType('0110', int(splitLine[0][2:(len(splitLine[0]))]), int(splitLine[2]), int(splitLine[1]))
        elif(regLine[0:2] == 'sw'):
            sType('0111', int(splitLine[0][2:(len(splitLine[0]))]), int(splitLine[2]), int(splitLine[1]))
        elif(regLine[0:4] == 'jalr'):
            sType('1011', int(splitLine[0][4:(len(splitLine[0]))]), int(splitLine[2]), int(splitLine[1]))
        elif(regLine[0:3] == 'beq'):
            bType('1000', int(splitLine[0][3:(len(splitLine[0]))]))
        elif(regLine[0:3] == 'bge'):
            bType('1001', int(splitLine[0][3:(len(splitLine[0]))]))
        elif(regLine[0:3] == 'blt'):
            bType('1010', int(splitLine[0][3:(len(splitLine[0]))]))



def rType(op, rd, rs0, rs1):
    txt = "{op}{rd}{rs0}{rs1}\n"
    outputFile.write(txt.format(op = op, rd = '{0:04b}'.format(rd), rs0 = '{0:04b}'.format(rs0), rs1 = '{0:04b}'.format(rs1)))
    if(verbose_mode):
        print(txt.format(op = op, rd = '{0:04b}'.format(rd), rs0 = '{0:04b}'.format(rs0), rs1 = '{0:04b}'.format(rs1)))

def iType(op, rd, imm):
    txt = "{op}{rd}{imm}\n"
    outputFile.write(txt.format(op = op, rd = '{0:04b}'.format(rd), imm = '{0:08b}'.format(imm & 0xff)))
    if(verbose_mode):
        print(txt.format(op = op, rd = '{0:04b}'.format(rd), imm = '{0:08b}'.format(imm & 0xff)))

def bType(op, imm):
    txt = "{op}{imm}\n"
    outputFile.write(txt.format(op = op, imm = '{0:012b}'.format(imm & 0xfff)))
    if(verbose_mode):
        print(txt.format(op = op, imm = '{0:012b}'.format(imm & 0xfff)))    

def sType(op, rd, rs0, imm):
    txt = "{op}{rd}{rs0}{imm}\n"
    outputFile.write(txt.format(op = op, rd = '{0:04b}'.format(rd), rs0 = '{0:04b}'.format(rs0), imm = '{0:04b}'.format(imm & 0xf)))
    if(verbose_mode):
        print(txt.format(op = op, rd = '{0:04b}'.format(rd), rs0 = '{0:04b}'.format(rs0), imm = '{0:04b}'.format(imm & 0xf)))




if __name__ == "__main__":
    # Create an ArgumentParser object
    parser = argparse.ArgumentParser(description='The Super Cool SID++ Assembler')

    # Add a positional argument for the filename
    parser.add_argument('filename', help='input file name')

    # Add an optional argument for verbose mode
    parser.add_argument('-v', '--verbose', action='store_true', help='enable verbose mode')
    
    #just remove "sid"s
    parser.add_argument('-s', '--sidless', action='store_true', help='only output as .sidless file')

    # Parse the arguments from the command line
    args = parser.parse_args()

    # Access the values of the arguments
    filename = args.filename
    verbose_mode = args.verbose
    sidless = args.sidless

    #open file
    input_file = open(filename, 'r')
    input_lines = input_file.readlines()
    
    #figure out extension
    if sidless:
        outputFileName = filename + 'less'
    else:
        outputFileName = filename + 'sm'
        
    #create output file and working file
    outputFile = open(outputFileName, 'w')
    temp_file_name = 'temp_' + outputFileName

    #temp_file - ensures input file is unchanged
    temp_file = open(temp_file_name, 'w')

    for line in input_lines:
        temp_file.write(line)

    #now have duplicate file to work out of
    input_file.close()
    temp_file.close()
    main()

    temp_file.close()
    #os.remove(temp_file_name)
    