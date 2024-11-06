trigger AccountTrigger on Account (before insert, after insert, after update) {

    switch on trigger.OperationType{

        when BEFORE_INSERT{
            // AccountTriggerHandler.industryBasedRating(trigger.new);
            // AccountTriggerHandler.copyBillingToShipping(trigger.new);
        }

        when AFTER_INSERT{
            // AccountTriggerHandler.createAssociatedContact(trigger.new);
            // AccountTriggerHandler.createConIfIndustryBanking(trigger.new);
            // AccountTriggerHandler.numberOfLocations(trigger.new);  
        }
        when AFTER_UPDATE{
            // AccountTriggerHandler.updateNumberOfLocations(trigger.new);
            AccountTriggerHandler.updatePhone(trigger.new);
        }
    }
}