public class SearchContactsController {
    
    @AuraEnabled
    public static List<Contact> getContacts(String searchKey){
        try {
            String key = '%' + searchKey + '%';
            List<Contact> conList = [SELECT Id,Name FROM Contact WHERE Name LIKE :key];
            System.debug('conList' +conList);
            return conList;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}