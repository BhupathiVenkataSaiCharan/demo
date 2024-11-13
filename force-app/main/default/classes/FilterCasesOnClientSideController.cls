public class FilterCasesOnClientSideController {
    
    @AuraEnabled(cacheable=true)
    public static objectsWrapper getCaseRecords(String accId){
        
        objectsWrapper wrapper = new objectsWrapper();
        try {

            List<Contact> conList = [SELECT Id,AccountId FROM Contact WHERE AccountId = :accId];
            wrapper.contacts.addAll(conList);

            List<Case> caseList = [SELECT CaseNumber,Status,CreatedDate,LastModifiedDate,ContactId FROM Case WHERE ContactId IN :conList];
            wrapper.cases.addAll(caseList);

            return wrapper;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    public class objectsWrapper{
        public List<Contact> contacts = new List<Contact>();
        public List<Case> cases = new List<Case>();
    }
}