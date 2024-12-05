public class CreateAccConTogetherController {
    @AuraEnabled
    public static void createAccCon(String accName, String conName, String conEmail){
        try {
            Account acc = new Account(Name = accName);
            insert acc;

            Contact con = new Contact(
                LastName = conName,
                Email = conEmail,
                AccountId = acc.Id
            );
            insert con;

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}