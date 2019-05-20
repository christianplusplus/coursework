import os
hdlFiles = [file for file in os.listdir() if '.hdl' in file]
for fileName in hdlFiles:
    file = open(fileName,'r')
    text = file.readlines()
    text = [line.replace('\t','    ') for line in text]
    file.close()
    file = open(fileName, 'w').close()
    file = open(fileName, 'a')
    for line in text:
        file.write(line)
    file.close()
    print('changed ' + fileName)
print('done',end='')