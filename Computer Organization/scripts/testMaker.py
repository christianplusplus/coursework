import os
tests = [file for file in os.listdir() if '.tst' in file]
outFile = open('superTest.tst','a')
for test in tests:
    testFile = open(test,'r')
    outFile.write(testFile.read())
    testFile.close()
outFile.close()