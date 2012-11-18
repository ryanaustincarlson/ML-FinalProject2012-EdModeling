#!/usr/bin/env python

from StudentFormatter import StudentFormatter
from StudentTransaction import StudentTransaction
from pprint import pprint

import sys, os

def main(args):
    if len(args[1:]) != 1:
        print 'usage: %s <students.csv>' % args[0]
        sys.exit(1)

    students_filename = args[1]

    formatter = StudentFormatter(students_filename)

    pprint(formatter.transactions)

    splitext = os.path.splitext(students_filename)
    outfilename = splitext[0] + '-nominalized' + splitext[1]
    formatter.write(outfilename)


if __name__ == '__main__':
    main(sys.argv)
