#!/usr/bin/env python

import re, csv #@UnresolvedImport
from pprint import pformat, pprint #@UnresolvedImport

import sys, logging

class DataFormatter:

    def __init__(self, in_filename, TransactionClass, field_separator=','):
        """
        Input:
          TransactionClass: tells us what type of transaction we're insterested
                            in. Could use CogTutorTransaction for example. This
                            contains information about which properties to search
                            for.

        """
        self.in_filename = in_filename
        self.TransactionClass = TransactionClass
        self.field_separator = field_separator
        self.transactions = []

    def extract_transactions(self):
        in_file = open(self.in_filename, 'rU') # rU = universal read; more robust to newline chars / carriage returns
        reader = csv.reader(in_file, delimiter=self.field_separator, quotechar='"')

        header = reader.next()

        property_to_column_map = {}
        for property in self.TransactionClass.property_list:
            property_columns = [column_index for column_index,column_value \
                in enumerate(header) if column_value.strip('"').strip().lower() == property.strip('"').strip().lower()]

            if len(property_columns) == 0:
                ## TODO make this throw an exception at some point
                print "Could not find property (%s). Since every property is necessary, I'm going to exit now" % property
                print "here's the header, by the way:", header
                exit(1)

            property_to_column_map[property] = property_columns

        # now grab all data from the specified columns
        for line in reader:
            
            line_properties = {}
            for property,property_columns in property_to_column_map.iteritems():
                property_column = property_columns[0]
                line_properties[property] = line[property_column]

            self.transactions.append(self.TransactionClass(line_properties))

        for transaction in self.transactions: transaction.cleanup()
        self.transactions = [transaction for transaction in self.transactions if transaction.valid()]

        return self.transactions
    
    def split_transactions(self, splitting_property):
        # key:splitting_property, val:list of transactions for each unique property value
        split_vals = set( (t.properties[splitting_property] for t in self.transactions) )
        for val in split_vals:
            split_transactions = []
            for transaction in self.transactions:
                prop = transaction.properties[splitting_property]
                if prop != val:
                    continue
                
                split_transactions.append(prop)
            yield (val, split_transactions)

    def finalize_transactions(self, mapping):
        """ assumes every transaction has a value for the keys in the mapping...
        i.e. if mapping contains rule A -> B, then transaction.properties[A] should exist
        """
        old_transactions = self.transactions
        self.transactions = []
        for transaction in old_transactions:
            properties = {}
            for key,value in mapping.iteritems():
                properties[value] = transaction.properties[key]
            self.transactions.append(self.TransactionClass(properties))

    def property_distribution(self, property):
        """ returns a list of the properties and how often
        they appear in the transactions """
        from operator import itemgetter
        property_distribution = {}

        for transaction in self.transactions:
            property_value = transaction.properties[property]

            if not property_value in property_distribution:
                property_distribution[property_value] = 0
            property_distribution[property_value] += 1

        return sorted([(property,count,float("%.4f" % (float(count)/len(self.transactions)))) for property,count in property_distribution.iteritems()], key=itemgetter(1), reverse=True)
        return property_distribution


    def write(self, outfilename="processed-data.csv", property_list=None):

        if not outfilename.endswith('.csv'):
            outfilename += '.csv'

        if property_list is None:
            # if there's a final_property_list, use it
            # otherwise, fall back on the property_list
            try:
                property_list = self.TransactionClass.final_property_list
            except:
                property_list = self.TransactionClass.property_list

        csv_file = open(outfilename, "wb")
        writer = csv.writer(csv_file, delimiter=',')

        # write the names of each column
        writer.writerow(property_list)

        for transaction in self.transactions:
            row = []
            for property in property_list:
                row.append(transaction.properties[property])
            writer.writerow(row)
        csv_file.close()

        logging.info("==> written to disk: %s" % outfilename)
