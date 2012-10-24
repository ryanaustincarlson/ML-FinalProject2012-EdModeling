from Transaction import Transaction

class EdLogTransaction(Transaction):

    # this is just a multiline comment, by the way
    """
    here are all of the fields we have to play with

    sort,Sample Name,Anon Student Id,Condition,Session Id,Time,Day,monthVal,dayVal,date,Time Zone,Duration (sec),myDuration,myDuration_woTPA,Student Response Type,Student Response Subtype,studentResponseType_woTPA,Tutor Response Type,Tutor Response Subtype,Level(ProblemSet),Problem Name,Step Name,Attempt At Step,Outcome,Outcome_woTPA,Selection,Action,Input,Feedback Text,Feedback Classification,Help Level,Total Num Hints,KC(Default),KC Category(Default),KC(Single-KC),KC Category(Single-KC),KC(Unique-step),KC Category(Unique-step),School,Class,CF(tool_event_time),CF(tutor_event_time)
    """

    # assign each one we want to extract its own variable name for convenience
    # and reference later on
    _student_id = "Anon Student Id"
    _condition = "Condition"
    _duration = "myDuration_woTPA"
    _outcome = "Outcome"
    # TODO: add more later

    # list the properties you want to extract
    # 
    # this lets us easily put in and take out columns we don't want 
    property_list = [
            _student_id, _condition, 
            _duration, _outcome
            ]

    # transaction-level cleanup operations
    #
    # note this gets called before valid() in DataFormatter, 
    # so we can set invalid stuff to null and then check it later
    def cleanup(self):
        # make sure duration is either something legit or null, rather
        # than just an empty string, which is bullshit
        #
        # TODO: may also want to convert it to a real number rather than
        #       a string in the "0:04.0" format..
        duration = self.properties[self._duration]
        if len(duration) == 0:
            self.properties[self._duration] = None
        else:
            duration_list = duration.split(':')
            minute = int(duration_list[0])
            second = int(duration_list[1].split('.')[0])
            self.properties[self._duration] = minute * 60 + second


    # what defines a valid property?
    def valid(self):
        # for now, any transaction with a valid duration
        return self.properties[self._duration] != None

