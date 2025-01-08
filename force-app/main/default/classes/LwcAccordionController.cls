/**
 * CH-01        charan      07-01-2025      Component library tasks
 */
public class LwcAccordionController {
 
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccounts(){
        try {
            List<Account> accounts = [SELECT Id,Name FROM Account];
            return accounts;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<Contact> getContacts(String accId){
        try {
            System.debug(accId);
            List<Contact> conList = [SELECT Id,Name FROM Contact WHERE AccountId = :accId];
            System.debug(conList);
            return conList;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}