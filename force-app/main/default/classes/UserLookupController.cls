public class UserLookupController {
    @AuraEnabled
    public static string sendEmail(String recId){
        try {
            User selectedUser = [SELECT Id,Email FROM User WHERE Id = :recId LIMIT 1];

            if(selectedUser.Email != null){
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                email.setToAddresses(new String[] { selectedUser.Email });
                email.setSubject('Notification Email');
                email.setPlainTextBody('Hello, this is a notification email.');

                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });

                return 'Email sent successfully to ' + selectedUser.Email;

            }else{
                return 'Seleced User doesnt have an email address';
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}