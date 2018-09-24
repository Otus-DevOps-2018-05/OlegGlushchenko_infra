#!/usr/bin/env python
import sys

if len(sys.argv) > 1:
    if sys.argv[1] == '--list':
        f = open ('inventory.json', 'r')
        for line in f:
            print (line),
        f.close
    else:
        print '{}',
else:
    print '{}',
