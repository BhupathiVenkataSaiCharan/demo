public class ContactTriggerHandler {
    
    public static void updatePhoneWithCountryCode(List<Contact> newList){
        
        for (Contact con : newList) {
            if(con.Country__c == null || con.Country__c == ''){
                con.Country__c.addError('Please select country name.');
                break;
            }
            if(con.MobilePhone == null || con.MobilePhone == ''){
                con.MobilePhone.addError('Please enter mobile phone.');
                break;
            }

            String[] phoneParts = con.MobilePhone.split(' ');
            String phoneNumberWithoutCode = String.valueOf(phoneParts.size() > 1 ? phoneParts[1] : phoneParts[0]);
            if(phoneNumberWithoutCode.length() != 10){
                con.MobilePhone.addError('Phone number should be 10 digits excluding country code');
                break;
            }
            List<Country_Codes__mdt> mdtList = [SELECT MasterLabel,Code__c FROM Country_Codes__mdt WHERE MasterLabel = :con.Country__c];
            if(mdtList.isEmpty()){
                // con.MobilePhone = phoneNumberWithoutCode;
                // break;
            }
            String countryPhoneNumber = mdtList[0].Code__c + ' ' + phoneNumberWithoutCode;
            con.MobilePhone = countryPhoneNumber;
        }   
    }
}