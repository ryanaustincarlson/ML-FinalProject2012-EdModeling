#!/usr/bin/env python

# reads in a raw datashop file (.csv) and outputs a more useful spreadsheet 
# that only includes the columns that we want, and will eventually also add our
# own features (that's a big important TODO)

from EdLogFormatter import EdLogFormatter
from EdLogTransaction import EdLogTransaction

import logging, sys
from pprint import pprint

def template_transactions_by_problem(transactions):
    """
    transactions that only contain student_id, problem, day 
    """
    interesting_ftrs_set = set()
    for t in transactions:
        student_id = t.properties[EdLogTransaction._student_id]
        problem_name = t.properties[EdLogTransaction._problem_name]
        day = t.properties[EdLogTransaction._day]
        condition = t.properties[EdLogTransaction._condition]
        
        interesting_ftrs_set.add( (student_id, problem_name, day, condition) )
    
    new_transactions = []
    for student_id,problem_name,day,condition in interesting_ftrs_set:
        new_transactions.append({EdLogTransaction._student_id:student_id,
             EdLogTransaction._problem_name:problem_name,
             EdLogTransaction._day:day,
             EdLogTransaction._condition:condition
             })
    return new_transactions

def get_number_attempts_per_problem(student_id, student_transactions):
    pass

def main(args):
    if len(args[1:]) != 2:
        print "usage: %s <raw-logdata.csv> <processed-logdata.csv>" % args[0]
        sys.exit(1)

    raw_fname = args[1]
    processed_fname = args[2]

    logging.info("input file: %s" % raw_fname)
    logging.info("processed file: %s" % processed_fname)

    formatter = EdLogFormatter(raw_fname)
    logging.debug("Done Formatting")
    
    template = template_transactions_by_problem(formatter.transactions)
    
    for student_id, transactions in formatter.split_transactions(EdLogTransaction._student_id):
        print student_id  

    #formatter.write(processed_fname)


if __name__ == '__main__':
    LOGGING_LEVEL = logging.DEBUG; #LOGGING_LEVEL = logging.INFO; #LOGGING_LEVEL = None
    logging.basicConfig(level=LOGGING_LEVEL, format="%(levelname)s: %(message)s")
    main(sys.argv)
