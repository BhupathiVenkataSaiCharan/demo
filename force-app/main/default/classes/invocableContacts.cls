public class invocableContacts {

    @InvocableMethod(label = 'Get Contacts' description = 'Get Contacts related to account from flow and apex' category='Account')
    public static List<Contact> getContacts(List<Id> accId){
        
        List<Contact> conList = [SELECT Id,Name,AccountId FROM Contact WHERE AccountId IN :accId LIMIT 100];

        System.debug('conList' +conList);
        return conList;
    }
}