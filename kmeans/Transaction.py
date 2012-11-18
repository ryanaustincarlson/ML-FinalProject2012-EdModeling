
class Transaction:

    property_list = None

    def __init__(self, properties):
        self.properties = properties

    def eq(self, other):
        assert self.property_list

        """ True if transactions are the same, False otherwise """
        for prop in self.property_list:
            if self.properties[prop] != other.properties[prop]:
                return False
        return True

    def valid(self):
        return True

    def cleanup(self):
        assert False

    def __repr__(self):
        from pprint import pformat
        return pformat(self.properties)
