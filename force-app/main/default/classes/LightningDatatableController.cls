public class LightningDatatableController {
    
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContacts(){
        try {
            List<Contact> conList = [SELECT Id, Name,Phone, Account.Name FROM Contact];
            return conList;
        } catch (DmlException de) {
            throw new DmlException(de.getMessage());
        }
    }
}