from DataFormatter import DataFormatter
from StudentTransaction import StudentTransaction

class StudentFormatter(DataFormatter):

    def __init__(self, in_filename, field_separator=','):
        DataFormatter.__init__(self, in_filename, StudentTransaction, field_separator)
        self.extract_transactions()

        self.cleanup()

    def cleanup(self):
        for transaction in self.transactions:
            # TODO: do something to each transaction
            pass
