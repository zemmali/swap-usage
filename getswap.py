#!/usr/bin/python3

# Licence: 
# Author:  Saddam ZEMMALI
# Source:  Equipe Optim
# V1.0      23 Oct 2017     Initial release

import re
import glob

# Search file class
class searchfile:
    def __init__(self, file, searchstring1, searchstring2, searchstring3, searchstring4 ):
        self.file = file
        self.searchstring1 = searchstring1
        self.searchstring2 = searchstring2
        self.searchstring3 = searchstring3
        self.searchstring4 = searchstring4

# Set Search Parameters
class searchparm(searchfile):
    def printsearch(self):
        hand = open(self.file)
        for line in hand:
            line = line.rstrip()
            if re.search(self.searchstring1, line):
                print (line)
            if re.search(self.searchstring2, line):
                print (line)
            if re.search(self.searchstring3, line):
                print (line)
            if re.search(self.searchstring4, line):
                print (line)

# Get result
for file in glob.glob('/proc/*/status'):
    search_proc = searchparm(file, 'Name', 'VmSwap', 'Pid:', 'VmSize:' )
    print("#########################################")
    print("#########################################")
    print(search_proc.printsearch())
