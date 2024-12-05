trigger ContactTrigger on Contact (before insert,after insert,before update, after update) {

    switch on trigger.OperationType {
        when BEFORE_INSERT{
            // ContactTriggerHandler.updatePhoneWithCountryCode(trigger.new);
        }
        when AFTER_INSERT{
            // ContactTriggerHandler.updateContactCount(trigger.new);
            ContactTriggerHandler.updateStatusCountOnAccount(trigger.new);
        }
        when BEFORE_UPDATE{
            // ContactTriggerHandler.updatePhoneWithCountryCode(trigger.new);
        }
        when AFTER_UPDATE{
            // ContactTriggerHandler.updateContactCount(trigger.new);
            ContactTriggerHandler.updateStatusCountOnAccount(trigger.new);
        }
    }
}