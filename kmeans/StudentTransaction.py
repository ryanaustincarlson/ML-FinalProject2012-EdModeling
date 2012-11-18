from Transaction import Transaction

class StudentTransaction(Transaction):

    # assign each one we want to extract its own variable name for convenience
    # and reference later on
    _student_id = "Anon.Student.Id"
    _condition = "Condition"
    _hints_req = "hints_req"
    _num_errors = "num_errors"
    _min_spent = "minSpent"
    _inc_cor = "Inc..Cor"
    _inc_hint = "Inc..Hint"
    _inc_inc = "Inc..Inc"
    _num_boh = "NumBOH"

    # list the properties you want to extract
    # 
    # this lets us easily put in and take out columns we don't want 
    property_list = [
            _student_id, _condition,
            _hints_req, _num_errors, _min_spent, _inc_cor, _inc_hint,
            _inc_inc, _num_boh
            ]

    all_mappings = {
            _hints_req:(
                (lambda x:x<.67,'Low'),
                (lambda x:x<1.24,'Low-Mid'),
                (lambda x:x<1.72,'Mid'),
                (lambda x:x<3,'High-Mid'),
                (lambda x:x>=3,'High')
                ),
            _num_errors:(
                (lambda x:x<.83,'Low'),
                (lambda x:x<1.51,'Low-Mid'),
                (lambda x:x<2.41,'Mid'),
                (lambda x:x<3.95,'High-Mid'),
                (lambda x:x>=3.95,'High')
                ),
            _min_spent:(
                (lambda x:x<2.3,'Low'),
                (lambda x:x<5.2,'Low-Mid'),
                (lambda x:x<9,'Mid'),
                (lambda x:x<15.5,'High-Mid'),
                (lambda x:x>=15.5,'High')
                ),
            _inc_cor:(
                (lambda x:x<.618,'Low'),
                (lambda x:x<.658,'Low-Mid'),
                (lambda x:x<.728,'Mid'),
                (lambda x:x<.825,'High-Mid'),
                (lambda x:x>=.825,'High')
                ),
            _inc_hint:(
                (lambda x:x<.0195,'Low'),
                (lambda x:x<.043,'Low-Mid'),
                (lambda x:x<.109,'Mid'),
                (lambda x:x<.211,'High-Mid'),
                (lambda x:x>=.211,'High')
                ),
            _inc_inc:(
                (lambda x:x<.116,'Low'),
                (lambda x:x<.144,'Low-Mid'),
                (lambda x:x<.203,'Mid'),
                (lambda x:x<.296,'High-Mid'),
                (lambda x:x>=.296,'High')
                ),
            _num_boh:(
                (lambda x:x<.015,'Low'),
                (lambda x:x<.036,'Low-Mid'),
                (lambda x:x<.067,'Mid'),
                (lambda x:x<.157,'High-Mid'),
                (lambda x:x>=.157,'High')
                )
            }

    # transaction-level cleanup operations
    #
    # note this gets called before valid() in DataFormatter, 
    # so we can set invalid stuff to null and then check it later
    def cleanup(self):
        for prop in self.property_list:
            try:
                self.properties[prop] = float(self.properties[prop])
            except ValueError:
                pass

        for prop_key in self.all_mappings:
            mapping = self.all_mappings[prop_key]
            for fcn,tag in mapping:
                if fcn(self.properties[prop_key]):
                    self.properties[prop_key] = tag
                    break

    # what defines a valid property?
    def valid(self):
        # for now, any transaction with a valid duration
        return True
        
