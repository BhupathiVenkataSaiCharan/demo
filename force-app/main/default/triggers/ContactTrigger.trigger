trigger ContactTrigger on Contact (before insert,before update) {

    switch on trigger.OperationType {
        when BEFORE_INSERT{
            ContactTriggerHandler.updatePhoneWithCountryCode(trigger.new);
        }
        when BEFORE_UPDATE{
            ContactTriggerHandler.updatePhoneWithCountryCode(trigger.new);
        }
    }
}