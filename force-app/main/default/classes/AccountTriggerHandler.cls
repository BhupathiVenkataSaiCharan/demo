public class AccountTriggerHandler {
    
    //create related contact when account is created
    public static void createAssociatedContact(List<Account> newList){
        List<Contact> conList = new List<Contact>();
        for(Account acc : newList){
            Contact con = new Contact(
                LastName = acc.Name + 'associated',
                AccountId = acc.Id
            );
            conList.add(con);
        }
        if(!conList.isEmpty()){
            insert conList;
        }
    }

    //when account industry is banking then create contact with last name as account name and contact phone as account phone
    public static void createConIfIndustryBanking(List<Account> newList){
        List<Contact> conList = new List<Contact>();
        for(Account acc : newList){
            if(acc.Industry == 'Banking'){
                Contact con = new Contact(
                    LastName = acc.Name,
                    AccountId = acc.Id,
                    Phone = acc.Phone
                );
                conList.add(con);
            }
        }
        if(!conList.isEmpty()){
            insert conList;
        }
    }

    //create contacts equal to count in NumberofLocations__c
    public static void numberOfLocations(List<Account> newList){

        List<Contact> conList = new List<Contact>();
        for(Account acc : newList){
            if(acc.NumberofLocations__c > 0){
                Integer count = (Integer)acc.NumberofLocations__c;
                for(Integer i=0; i < count; i++){
                    Contact con = new Contact(
                        LastName = 'Contact' + i,
                        AccountId = acc.Id
                    );
                    conList.add(con);
                }
            }
        }
        if(!conList.isEmpty()){
            insert conList;
        }
    }

    //update contacts equal to count in NumberofLocations__c
    public static void updateNumberOfLocations(List<Account> newList){

        Integer count;
        List<Contact> extraCons = new List<Contact>();
        List<Contact> deleteList = new List<Contact>();

        for(Account acc : newList){
            Account oldMap = (Account)Trigger.oldMap.get(acc.Id);
            Integer oldNumber = (Integer)oldMap.NumberofLocations__c != null ? (Integer)oldMap.NumberofLocations__c : 0;
            Integer newNumber = (Integer)acc.NumberofLocations__c != null ? (Integer)acc.NumberofLocations__c : 0;

            if(oldNumber != newNumber && oldNumber < newNumber){
                count = newNumber - oldNumber;
                for(Integer i=0; i<count; i++){
                    extraCons.add(new Contact(
                        LastName = 'Contact update' + i,
                        AccountId = acc.Id
                    ));
                }
            }
            else if(oldNumber != newNumber && oldNumber > newNumber){
                count = oldNumber - newNumber;
                deleteList.addAll([SELECT Id FROM Contact WHERE AccountId = :acc.Id ORDER BY CreatedDate DESC LIMIT :count]);
            }
        }
        if(!extraCons.isEmpty()){
            insert extraCons;
        }
        if(!deleteList.isEmpty()){
            delete deleteList;
        }
    }


    //if industry media update rating as hot
    public static void industryBasedRating(List<Account> newList){
        for(Account acc : newList){
            if(acc.Industry == 'Media'){
                acc.Rating = 'Hot';
            }
        }
    }


    //copy billing address to shipping address if checkbox Same_As_Billing_Address__c is checked
    public static void copyBillingToShipping(List<Account> newList){
        for(Account acc : newList){
            if(acc.Same_As_Billing_Address__c){
                acc.ShippingStreet = acc.BillingStreet;
                acc.ShippingCity = acc.ShippingCity;
                acc.ShippingPostalCode = acc.ShippingPostalCode;
                acc.ShippingState = acc.BillingState;
                acc.ShippingCountry = acc.BillingCountry;
            }
        }
    }


    //if account phone updated the update related contacts phone
    public static void updatePhone(List<Account> newList){

        Map<Id, String> accMap = new Map<Id, String>();
        for(Account acc : newList){
            Account oldMap = (Account)Trigger.oldMap.get(acc.Id);
            if(acc.Phone != oldMap.Phone){
                accMap.put(acc.Id,acc.Phone);
            }
        }
        List<Contact> conList = new List<Contact>();
        for(Contact con : [SELECT Id, AccountId, Phone FROM Contact WHERE AccountId IN :accMap.keySet()]){
            con.Phone = accMap.get(con.AccountId);
            conList.add(con);
        }
        if(!conList.isEmpty()){
            update conList;
        }
    }

}