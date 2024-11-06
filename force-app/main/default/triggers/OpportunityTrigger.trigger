trigger OpportunityTrigger on Opportunity (before insert, after insert) {

    switch on trigger.OperationType{

        when BEFORE_INSERT{
            OpportunityTriggerHandler.descAsHotOpportuntiy(trigger.new);
        }

        when AFTER_INSERT{
            OpportunityTriggerHandler.latestOppAmount(trigger.new);
        }
    }
}