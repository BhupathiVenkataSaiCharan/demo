/**
 * CH-01            Charan              18-11-2024              practice Scenarios
 * CH-02            Charan              18-11-2024              interview Scenarios
 * CH-03            Charan              18-11-2024              task by Surya prajwal
 */


public class FilterCasesOnClientSideController {


    /**
    * CH-03 Send List of Contacts and its related Cases with account Id to Client Side and render data there
    * @param newList
    * @return contacts and cases list with wrapper class
    */
    @AuraEnabled(cacheable = true)
    public static objectWrapper getCaseRecords(String accId){
        
        objectWrapper obj = new objectWrapper();
        
        try {
            Map<Id,Contact> conMap = new Map<Id,Contact>([SELECT Id,Name,AccountId FROM Contact WHERE AccountId = :accId]);
            obj.contacts.addAll(conMap.values());

            obj.cases.addAll([SELECT Id, CaseNumber, Status, CreatedDate, LastModifiedDate, ContactId FROM Case WHERE ContactId IN :conMap.keySet() AND Id != NULL]);

            return obj;

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    /**
     * CH-03 wrapper class to hold list of contacts and cases
     * @param
     * @return 
     */
    public class objectWrapper{
        @AuraEnabled public List<Contact> contacts = new List<Contact>();
        @AuraEnabled public List<Case> cases = new List<Case>();
    }
}