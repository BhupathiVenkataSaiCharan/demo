public class AccountRelatedContacts {
    
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContacts(String accId){
        List<Contact> conList = [SELECT Id, Name, AccountId,Account.Name FROM Contact WHERE AccountId = :accId];
        System.debug('Contact List ====> ' +conList);
        return conList;
    }
}