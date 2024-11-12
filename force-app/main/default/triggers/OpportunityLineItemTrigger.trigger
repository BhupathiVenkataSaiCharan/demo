trigger OpportunityLineItemTrigger on OpportunityLineItem (after insert,after update, after delete) {

    switch on trigger.OperationType {
        when AFTER_INSERT {
            OpportunityLineItemTriggerHandler.ProductInformation(trigger.new);
        }
        when AFTER_UPDATE {
            OpportunityLineItemTriggerHandler.ProductInformation(trigger.new);
        }
        when AFTER_DELETE {
            OpportunityLineItemTriggerHandler.ProductInformation(trigger.old);
        }
    }
}