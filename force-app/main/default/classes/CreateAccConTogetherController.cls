public class CreateAccConTogetherController {
    @AuraEnabled
    public static void createAccCon(String accName, String conName, String conEmail, Blob file){
        try {
            Account acc = new Account(Name = accName);
            insert acc;

            Contact con = new Contact(
                LastName = conName,
                Email = conEmail,
                AccountId = acc.Id
            );
            insert con;

            if(file != null){
                ContentVersion cv = new ContentVersion(
                    Title = 'Uploaded File',
                    PathOnClient = fields.get('fileName'),
                    VersionData = file,
                    FirstPublishLocationId = con.Id
                );
            }

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}