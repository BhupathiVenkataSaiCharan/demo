public class SearchOccuranceController {
    
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccountRecords(){
        try {
            List<Account> accList = [SELECT Id,Name FROM Account];
            return accList;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}