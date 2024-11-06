trigger LeadTrigger on Lead (before insert, before update) {

    switch on trigger.OperationType {
        
        when BEFORE_INSERT{
            // LeadTriggerHandler.sourceBasedRating(trigger.new);    
        }
        when BEFORE_UPDATE{
            // LeadTriggerHandler.sourceBasedRating(trigger.new);    
        }
    }

}