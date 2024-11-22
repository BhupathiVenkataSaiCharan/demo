@isTest
public class AccountTriggerHandlerTest {

    @isTest
    static void createAssociatedContactTest(){

        List<Account> accList = new List<Account>();
        accList.add(new Account(Name = 'Test1'));
        accList.add(new Account(Name = 'Test2'));

        insert accList;

        List<Account> accountslist = [SELECT Id, Name FROM Account];
        
        // AccountTriggerHandler.createAssociatedContact(accountslist);

        List<Contact> conList = [SELECT Id, AccountId FROM Contact WHERE AccountId IN :accountslist];

        Assert.areEqual(true,conList.size()>0, 'No Contacts found');
    } 

    @isTest
    static void createConIfIndustryBankingTest(){

        List<Account> accList = new List<Account>();
        accList.add(new Account(Name = 'Test1', Industry = 'Banking', Phone = '1234567890'));
        accList.add(new Account(Name = 'Test2', Industry = 'Agriculture'));

        insert accList;

        List<Account> accountsList = [SELECT Id, Name, Industry,Phone FROM Account WHERE Industry = 'Banking'];

        AccountTriggerHandler.createConIfIndustryBanking(accountsList);

        // update accountsList;

        List<Contact> conList = [SELECT Id, LastName, Phone, AccountId,Account.Name,Account.Phone FROM Contact WHERE AccountId IN :accountsList];

        for(Contact con : conList){
            Assert.areEqual(con.LastName, con.Account.Name, 'names dont match');
            Assert.areEqual(con.Phone, con.Account.Phone, 'phones dont match');
        }
    }

    @isTest
    static void numberOfLocationsTest(){

        List<Account> accList = new List<Account>();

        accList.add(new Account(Name = 'Test Account yes', NumberofLocations__c = 5));
        accList.add(new Account(Name = 'Test Account no'));

        insert accList;

        // AccountTriggerHandler.numberOfLocations(accList);

        update accList;

        List<Account> accountsList = [SELECT Id, NumberofLocations__c, (SELECT Id FROM Contacts) FROM Account WHERE Id IN :accList AND NumberofLocations__c != null];

        for(Account acc : accountsList){
            Assert.areEqual(acc.NumberofLocations__c, acc.Contacts.size(), 'Size mismatch');
        }
    }

    @isTest
    static void industryBasedRatingTest(){
        
        List<Account> accList = new List<Account>();

        accList.add(new Account(Name = 'industry test', Industry = 'Media'));
        accList.add(new Account(Name = 'test bank', Industry = 'Banking'));

        insert accList;

        // AccountTriggerHandler.industryBasedRating(accList);

        update accList;

        List<Account> accounts = [SELECT Id,Name,Industry,Rating FROM Account WHERE Industry = 'Media'];

        for(Account acc : accounts){
            if(acc.Industry == 'Media'){
                Assert.areEqual('Hot',acc.Rating,'Expected Rating is wrong');
            }
        }
    }

    @isTest
    static void copyBillingToShippingTest(){
        List<Account> accList = new List<Account>();

        accList.add(new Account(Name = 'test', ShippingStreet = 'Street', ShippingCity = 'City', ShippingCountry = 'Country', ShippingState = 'State', ShippingPostalCode = '234567'));

        insert accList;

        // AccountTriggerHandler.copyBillingToShipping(accList);

        update accList;

        List<Account> updatedList = [SELECT Id, Same_As_Billing_Address__c, ShippingStreet, ShippingCity, ShippingCountry, ShippingPostalCode, ShippingState, BillingStreet, BillingCity, BillingCountry, BillingPostalCode, BillingState FROM Account];

        for(Account acc : updatedList){
            if(acc.Same_As_Billing_Address__c){
                Assert.areEqual(acc.BillingStreet,acc.ShippingStreet, 'Does not match');
                Assert.areEqual(acc.BillingCity,acc.ShippingCity, 'Does not match');
                Assert.areEqual(acc.BillingCountry,acc.ShippingCountry, 'Does not match');
                Assert.areEqual(acc.BillingPostalCode,acc.ShippingPostalCode, 'Does not match');
                Assert.areEqual(acc.BillingState,acc.ShippingState, 'Does not match');
            }
        }
    }


    @isTest
    static void updatePhoneTest(){
        List<Account> accList = new List<Account>();
        accList.add(new Account(Name = 'test', Phone = '12345'));

        insert accList;

        List<Contact> conList = new List<Contact>();
        conList.add(new Contact(LastName = 'con', AccountId = accList[0].Id, Phone = '00000'));

        insert conList;

        List<Account> updatedList = new List<Account>();
        for(Account acc : accList){
            updatedList.add(new Account(Id = acc.Id, Phone = '67890'));
        }

        update updatedList;
        
        for(Contact con : [SELECT Id,Phone,Account.Phone FROM Contact]){
            Assert.areEqual(con.Account.Phone, con.Phone,'Phone does not match');
        }

    }


    @isTest
    static void updateRelatedContactsPhoneTest(){
        
        Account acc1 = new Account(Name = 'Acc 1', Phone = '1234567890');
        Account acc2 = new Account(Name = 'Acc 2', Phone = '0987654321');

        insert new List<Account>{acc1,acc2};

        Contact con1 = new Contact(LastName = 'Con 1',AccountId = acc1.Id, Phone = '1234512345');
        Contact con2 = new Contact(LastName = 'Con 2',AccountId = acc1.Id, Phone = '5432112345');
        Contact con3 = new Contact(LastName = 'Con 3',AccountId = acc2.Id, Phone = '0987612345');

        insert new List<Contact>{con1,con2,con3};

        acc1.Phone = '5555555555';
        acc2.Phone = '6666666666';
        Map<Id,Account> newMap = new Map<Id,Account>();
        newMap.put(acc1.Id, acc1);
        newMap.put(acc2.Id, acc2);

        Test.startTest();
        AccountTriggerHandler.updateRelatedContactsPhone(newMap);
        Test.stopTest();

        for(Contact con : [SELECT Id,Name,Phone,AccountId FROM Contact]){
            if(con.AccountId == acc1.Id){
                Assert.areEqual('5555555555',con.Phone,'Phone does not match');
            }else if(con.AccountId == acc2.Id){
                Assert.areEqual('6666666666',con.Phone,'Phone does not match');
            }
        }
    }
}