trigger LeadTrigger on Lead (before insert, after insert, before update, after update) {

    switch on trigger.OperationType {
        
        when BEFORE_INSERT{
            // LeadTriggerHandler.sourceBasedRating(trigger.new);    
            // LeadTriggerHandler.duplicateLeadCheck(trigger.new);
            // LeadTriggerHandler.recursiveCheck1(trigger.new);
        }
        when AFTER_INSERT {
            LeadTriggerHandler.checkDecryptChange(trigger.new);
            // LeadTriggerHandler.recursionCheck(trigger.new);
        }
        when BEFORE_UPDATE{
            // LeadTriggerHandler.sourceBasedRating(trigger.new); 
            // LeadTriggerHandler.duplicateLeadCheck(trigger.new);   
            // LeadTriggerHandler.recursiveCheck1(trigger.new);
        }
        when AFTER_UPDATE {
            LeadTriggerHandler.checkDecryptChange(trigger.new);
            // LeadTriggerHandler.recursionCheck(trigger.new);
        }
    }

}