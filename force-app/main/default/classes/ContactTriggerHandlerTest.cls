@isTest
private class ContactTriggerHandlerTest {
    
    @isTest
    private static void updatePhoneWithCountryCodeTest(){

        List<Contact> conList = new List<Contact>();
        conList.add(new Contact(LastName = 'INDIA',Country__c = 'India', MobilePhone = '1234567890'));

        insert conList;

        ContactTriggerHandler.updatePhoneWithCountryCode(conList);

        List<Contact> insertedList = [SELECT Id,Name,Country__c,MobilePhone FROM Contact];

        update insertedList;

        Assert.areEqual('+91 1234567890',insertedList[0].MobilePhone,'Mobile numbers dont match');
    }

    @isTest
    private static void updatePhoneWithCountryCodeTestNoCountry(){
        List<Contact> conList = new List<Contact>();
        conList.add(new Contact(LastName = 'INDIA',Country__c = '', MobilePhone = '1234567890'));

        try {
            insert conList;
        
        } catch (Exception e) {
            Assert.areEqual('FIELD_CUSTOM_VALIDATION_EXCEPTION', e);        
        }   
    }

    @isTest
    private static void updatePhoneWithCountryCodeTestNoPhone(){
        List<Contact> conList = new List<Contact>();
        conList.add(new Contact(LastName = 'INDIA',Country__c = 'India', MobilePhone = ''));

        try {
            insert conList;

        } catch (Exception e) {
            Assert.areEqual('Insert failed. First exception on row 0; first error: FIELD_CUSTOM_VALIDATION_EXCEPTION, Please enter mobile phone.: [MobilePhone]', e.getMessage());
        }
        
    }

    @isTest
    private static void updatePhoneWithCountryCodeTestWrongPhone(){
        List<Contact> conList = new List<Contact>();
        conList.add(new Contact(LastName = 'INDIA',Country__c = 'India', MobilePhone = '12345678901234567890'));

        try {
            insert conList;
        } catch (Exception e) {
            Assert.areEqual('Insert failed. First exception on row 0; first error: FIELD_CUSTOM_VALIDATION_EXCEPTION, Phone number should be 10 digits excluding country code: [MobilePhone]', e.getMessage());
        }
    }
}