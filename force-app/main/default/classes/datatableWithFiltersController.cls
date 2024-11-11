public class datatableWithFiltersController {
    
    @AuraEnabled(cacheable=true)
    public static objectWrapper getCaseList(String accId, String status, String createddate, String contact){

        objectWrapper obj = new objectWrapper();

        try {
            List<Contact> conList = [SELECT Id, Name, AccountId FROM Contact WHERE AccountId = :accId];
            obj.contacts.addAll(conList);

            String caseQuery = 'SELECT CaseNumber, Status, CreatedDate,LastModifiedDate,ContactId FROM Case WHERE ContactId IN :conList';


            if(status != null && status != ''){
                caseQuery += ' AND Status = :status';
            }

            if(createddate == 'today'){
                caseQuery += ' AND CreatedDate = TODAY';
            }else if(createddate == 'last30days'){
                caseQuery += ' AND CreatedDate = LAST_N_DAYS:30';
            }

            if(contact !=null && contact != ''){
                caseQuery += ' AND ContactId = :contact';
            }

            System.debug('Case Query ===> ' +caseQuery);
            List<Case> caseList = Database.query(caseQuery);
            obj.cases.addAll(caseList);

            return obj;


        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    public class objectWrapper{
        @AuraEnabled public List<Contact> contacts = new List<Contact>();
        @AuraEnabled public List<Case> cases = new List<Case>();
    }
}