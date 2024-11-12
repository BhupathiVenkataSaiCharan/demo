public class FilterCasesOnClientSideController {
    
    @AuraEnabled(cacheable=true)
    public static objectsWrapper getCaseRecords(String accId){
        try {
            List<Contact> conList = [SELECT Id,AccountId FROM Contact WHERE AccountId = :accId];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    public class objectsWrapper{
        public List<Contact> contacts = new List<Contact>();
        public List<Case> cases = new List<Case>();
    }
}