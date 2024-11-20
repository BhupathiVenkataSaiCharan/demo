public class RelateMdtToOppController {
    
    @AuraEnabled(cacheable=true)
    public static List<Opportunity_Metadata__mdt> getMetadata(){
        try {
            List<Opportunity_Metadata__mdt> mdtList = [SELECT Id, Label FROM Opportunity_Metadata__mdt];
            return mdtList;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }


    @AuraEnabled
    public static void updateOpportunity(String oppId, String jsonData){
        try {
            Opportunity opp = new Opportunity(
                Id = oppId,
                MetadataJson__c = jsonData
            );
            update opp;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }


    @AuraEnabled(cacheable=true)
    public static String preCheckMetadata(String oppId){
        try {
            Opportunity opp = [SELECT Id, MetadataJson__c FROM Opportunity WHERE Id = :oppId];
            return opp.MetadataJson__c;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}