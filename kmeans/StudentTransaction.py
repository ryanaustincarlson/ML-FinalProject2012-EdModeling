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

    _delta_errors = "deltaErrors"
    _delta_hints = "deltaHints"
    _intrcp_errors = "intrcpErrors"

    _first_hint_geom = "firstHintGeom"
    _hints_geom = "hintsGeom"
    _errors_geom = "errorsGeom"
    _stuborn_geom = "stubbornGeom"

    _num_errors1 = "numErrors1"
    _num_errors2 = "numErrors2"
    _num_errors3 = "numErrors3"
    _num_errors4 = "numErrors4"

    _num_hints1 = "numHints1"
    _num_hints2 = "numHints2"
    _num_hints3 = "numHints3"
    _num_hints4 = "numHints4"

    _step_time1 = "steptime1"
    _step_time2 = "steptime2"
    _step_time3 = "steptime3"
    _step_time4 = "steptime4"

    _first_hint1 = "firstHint1"
    _first_hint2 = "firstHint2"
    _first_hint3 = "firstHint3"
    _first_hint4 = "firstHint4"

    # list the properties you want to extract
    # 
    # this lets us easily put in and take out columns we don't want 
    property_list = [
            _student_id, _condition,
            _hints_req, _num_errors, _min_spent, _inc_cor, _inc_hint,
            _inc_inc, _num_boh, _intrcpErrors
            ]

    all_mappings = {

            _delta_errors:(
                (lambda x:x<,1),
                (lambda x:x<,2),
                (lambda x:x<,3),
                (lambda x:x<,4),
                (lambda x:x>=,5),
                ),
-0.0851343785 -0.0185661480 -0.0120204359 -0.0065888109 -0.0002492945  0.0647924891 
            

            _hints_req:(
                (lambda x:x<.056,1),
                (lambda x:x<.186,2),
                (lambda x:x<.495,3),
                (lambda x:x<1.312,4),
                (lambda x:x>=1.312,5)
                ),

            _num_errors:(
                (lambda x:x<.344,1),
                (lambda x:x<1.152,1),
                (lambda x:x<1.699,2),
                (lambda x:x<2.177,3),
                (lambda x:x<3.188,4)
                (lambda x:x>=3.188,4)
                ),

            _min_spent:(
                (lambda x:x<1.152,1),
                (lambda x:x<1.699,2),
                (lambda x:x<2.177,3),
                (lambda x:x<3.188,4),
                (lambda x:x>=3.188,5)
                ),

            _inc_cor:(
                (lambda x:x<.641,1),
                (lambda x:x<.710,2),
                (lambda x:x<.764,3),
                (lambda x:x<.815,4),
                (lambda x:x>=.815,5)
                ),

            _inc_hint:(
                (lambda x:x<.009,1),
                (lambda x:x<.030,2),
                (lambda x:x<.077,3),
                (lambda x:x<.126,4),
                (lambda x:x>=.126,5)
                ),

            _inc_inc:(
                (lambda x:x<.135,1),
                (lambda x:x<.173,2),
                (lambda x:x<.206,3),
                (lambda x:x<.246,4),
                (lambda x:x>=.246,5)
                ),

            _num_boh:(
                (lambda x:x<.010,1),
                (lambda x:x<.047,2),
                (lambda x:x>=.047,3)
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
        
