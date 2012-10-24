#!/usr/bin/env python

# reads in a raw datashop file (.csv) and outputs a more useful spreadsheet 
# that only includes the columns that we want, and will eventually also add our
# own features (that's a big important TODO)

from EdLogFormatter import EdLogFormatter
from EdLogTransaction import EdLogTransaction

import logging, sys

def main(args):
    if len(args[1:]) != 2:
        print "usage: %s <raw-logdata.csv> <processed-logdata.csv>" % args[0]
        sys.exit(1)

    raw_fname = args[1]
    processed_fname = args[2]

    logging.info("input file: %s" % raw_fname)
    logging.info("processed file: %s" % processed_fname)

    formatter = EdLogFormatter(raw_fname)

    formatter.write(processed_fname)


if __name__ == '__main__':
    LOGGING_LEVEL = logging.DEBUG; #LOGGING_LEVEL = logging.INFO; #LOGGING_LEVEL = None
    logging.basicConfig(level=LOGGING_LEVEL, format="%(levelname)s: %(message)s")
    main(sys.argv)
