from DataFormatter import DataFormatter
from EdLogTransaction import EdLogTransaction

class EdLogFormatter(DataFormatter):

    def __init__(self, in_filename, field_separator=','):
        DataFormatter.__init__(self, in_filename, EdLogTransaction, field_separator)
        self.extract_transactions()

        self.cleanup()

    def cleanup(self):
        for transaction in self.transactions:
            # TODO: do something to each transaction
            pass
