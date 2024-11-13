public class ContactTriggerHandler {
    
    public static void updatePhoneWithCountryCode(List<Contact> newList){
        

        
        for (Contact con : newList) {
            if(con.Country__c == null || con.Country__c == ''){
                System.debug('con.Country__c == null || con.Country__c == ');
                break;
            }
            String[] phoneParts = con.MobilePhone.split(' ');
            String phoneNumberWithoutCode = String.valueOf(phoneParts.size() > 1 ? phoneParts[1] : phoneParts[0]);
            if(phoneNumberWithoutCode.length() != 10){
                con.addError('Phone number lenght should be 10');
            }
            List<Country_Codes__mdt> mdtList = [SELECT MasterLabel,Code__c FROM Country_Codes__mdt WHERE MasterLabel = :con.Country__c];
            if(mdtList.isEmpty()){
                con.MobilePhone = phoneNumberWithoutCode;
                break;
            }
            String countryPhoneNumber = mdtList[0].Code__c + ' ' + phoneNumberWithoutCode;
            con.MobilePhone = countryPhoneNumber;
        }   
    }
}