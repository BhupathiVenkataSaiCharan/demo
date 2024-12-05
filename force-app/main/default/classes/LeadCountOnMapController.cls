public class LeadCountOnMapController {
    
    @AuraEnabled(cacheable=true)
    public static List<leadWrapper> getLeadCount(){
        try {

            List<leadWrapper> leadList = new List<leadWrapper>();            
            for(AggregateResult agr : [SELECT COUNT(Id)cnt,City__c FROM Lead WHERE City__c != '' GROUP BY City__c]){
                
                leadWrapper lw = new leadWrapper();
                lw.city = (String)agr.get('City__c');
                lw.count = ((Integer)agr.get('cnt'));

                leadList.add(lw);
            }
            return leadList;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }


    public class leadWrapper{
        @AuraEnabled public String city { get; set; }
        @AuraEnabled public Integer count { get; set;}  
    }
}