public class SelfAssignLeadController {
    
    @AuraEnabled
    public static void selfAssign(String leadId){
        try {
            Lead leadRecord = [SELECT Id,OwnerId FROM Lead WHERE Id = :leadId LIMIT 1];
                
            leadRecord.OwnerId = UserInfo.getUserId();

            update leadRecord;

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}