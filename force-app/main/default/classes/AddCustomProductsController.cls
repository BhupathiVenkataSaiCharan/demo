public class AddCustomProductsController {
    
    @AuraEnabled(cacheable=true)
    public static List<CustomProduct__c> getProducts(){
        try {
            List<CustomProduct__c> prodList = [SELECT Id,Name FROM CustomProduct__c];

            return prodList;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void createLineItems(List<CustomOppLineItem__c> lineItemList){
        try {
            List<CustomOppLineItem__c> coliList = new List<CustomOppLineItem__c>();
            for(CustomOppLineItem__c coli : lineItemList){
                coliList.add(new CustomOppLineItem__c(
                        Name = coli.Name,
                        CustomOpportunity__c = coli.CustomOpportunity__c,
                        CustomProduct__c = coli.CustomProduct__c,
                        Price__c = coli.Price__c,
                        Quantity__c = coli.Quantity__c
                ));
            }
            insert coliList;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}