/**
 * ContactTrigger handler classs
 * 
 * CH-01                Charan              21-11-2024              Practice Scenarios
 * CH-02                Charan              21-11-2024              Interview Scenarios 
 */
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


    /**
     * CH-01    Update account with number of related contact count
     * @param   newList
     * @return  //
     */
    public static void updateContactCount(List<Contact> newList){

        Set<Id> accIds = new Set<Id>();
        for(Contact con : newList){
            if(con.AccountId != null){
                accIds.add(con.AccountId);
            }
        }

        Map<Id, Integer> accMap = new Map<Id, Integer>();
        for(AggregateResult agr : [SELECT COUNT(Id)cnt,AccountId FROM Contact WHERE AccountId IN :accIds GROUP BY AccountId]){
            accMap.put((Id)agr.get('AccountId'),(Integer)agr.get('cnt'));
        }

        List<Account> accList = new List<Account>();
        for(Id accId : accMap.keySet()){
            accList.add(new Account(Id = accId,Number_of_Contacts_count_without_rollup__c = accMap.get(accId)));
        }

        if(!accList.isEmpty()){
            update accList;
        }
    }
}