trigger ContactTrigger on Contact (before insert,before update,after insert, after update) {

    switch on trigger.OperationType {
        when BEFORE_INSERT{
            // ContactTriggerHandler.updatePhoneWithCountryCode(trigger.new);
        }
        when AFTER_INSERT{
            ContactTriggerHandler.updateContactCount(trigger.new);
        }
        when BEFORE_UPDATE{
            // ContactTriggerHandler.updatePhoneWithCountryCode(trigger.new);
        }
        when AFTER_UPDATE{
            ContactTriggerHandler.updateContactCount(trigger.new);
        }
    }
}