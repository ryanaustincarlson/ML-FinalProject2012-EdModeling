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
                (lambda x:x<.67,1),
                (lambda x:x<1.24,2),
                (lambda x:x<1.72,3),
                (lambda x:x<3,4),
                (lambda x:x>=3,5)
                ),
            _num_errors:(
                (lambda x:x<.83,1),
                (lambda x:x<1.51,2),
                (lambda x:x<2.41,3),
                (lambda x:x<3.95,4),
                (lambda x:x>=3.95,5)
                ),
            _min_spent:(
                (lambda x:x<2.3,1),
                (lambda x:x<5.2,2),
                (lambda x:x<9,3),
                (lambda x:x<15.5,4),
                (lambda x:x>=15.5,5)
                ),
            _inc_cor:(
                (lambda x:x<.618,1),
                (lambda x:x<.658,2),
                (lambda x:x<.728,3),
                (lambda x:x<.825,4),
                (lambda x:x>=.825,5)
                ),
            _inc_hint:(
                (lambda x:x<.0195,1),
                (lambda x:x<.043,2),
                (lambda x:x<.109,3),
                (lambda x:x<.211,4),
                (lambda x:x>=.211,5)
                ),
            _inc_inc:(
                (lambda x:x<.116,1),
                (lambda x:x<.144,2),
                (lambda x:x<.203,3),
                (lambda x:x<.296,4),
                (lambda x:x>=.296,5)
                ),
            _num_boh:(
                (lambda x:x<.015,1),
                (lambda x:x<.036,2),
                (lambda x:x<.067,3),
                (lambda x:x<.157,4),
                (lambda x:x>=.157,5)
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
        
