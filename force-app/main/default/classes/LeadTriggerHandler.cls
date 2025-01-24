/**
 * CH-01            Charan              15-11-2024              practice Scenarios
 * CH-02            Charan              15-11-2024              Interview Scenarios      
 * CH-03            Charan              02-01-2025              Reyna project scenario    
 */
public class LeadTriggerHandler {

    /**
     * @ CH-01 trigger scenario to check if lead source is web then rating cold else hot
     * @param newList
     * @return  
     */
    public static void sourceBasedRating(List<Lead> newList){
        for(Lead ld : newList){
            if(ld.LeadSource != ''){
                if(ld.LeadSource == 'Web'){
                    ld.Rating = 'Cold';
                }else{
                    ld.Rating = 'Hot';
                }
            }
        }
    }
    /**
     * CH-02 If Name,Email and Phone matches to existing recordthen create the new lead with duplicate lead checkbox checked
     * @param newList
     * @return 
     */
    public static void duplicateLeadCheck(List<Lead> newList){
        
        Set<String> nameSet = new Set<String>();
        Set<String> emailSet = new Set<String>();
        Set<String> phoneSet = new Set<String>();

        for(Lead existingLeads : [SELECT Id,LastName,Email,Phone FROM Lead]){
            nameSet.add(existingLeads.LastName);
            emailSet.add(existingLeads.Email);
            phoneSet.add(existingLeads.Phone);
        }

        for(Lead ld : newList){
            if(nameSet.contains(ld.LastName) && emailSet.contains(ld.Email) && phoneSet.contains(ld.Phone)){
                ld.DuplicateLead__c = true;
            }
        }
    }


    public static void recursionCheck(List<Lead> newList){

        List<Lead> leadList = new List<Lead>();

        for(Lead ld : newList){

            Datetime oldTime = (Datetime)Trigger.oldMap.get(ld.Id).get('LastModifiedDate');

            if(ld.LastModifiedDate != oldTime){
                Integer updateCount = 0;

                if(ld.No_of_Times_Updated__c != null && ld.No_of_Times_Updated__c != ''){
                    updateCount = Integer.valueOf(ld.No_of_Times_Updated__c) +1;
                }
                leadList.add(new Lead(
                    Id = ld.Id,
                    No_of_Times_Updated__c = String.valueOf(updateCount)
                ));
            }
            if(!leadList.isEmpty()){
                update leadList;
            }
        }

        // for(Lead ld : newList){

        //     System.debug('Lead ===>' +ld);
        //     System.debug('Last Modified Date ===>' +ld.LastModifiedDate);
        //     System.debug('Last Modified Date ===>' + Datetime.parse(ld.LastModifiedDate));
        //     Datetime oldDate = (Datetime)Trigger.oldMap.get(ld.Id).get('LastModifiedDate');
            

        //     System.debug('oldDate ===> ' +oldDate);
        //     System.debug('oldDate ===> ' + Datetime.parse(oldDate));
        //     Map<Id, String> leadMap = new Map<Id, String>();
        //     if(oldDate != ld.LastModifiedDate){
        //         System.debug('New Last modified date ===>' +ld.LastModifiedDate);
        //         Integer updatedCount =+ ld.No_of_Times_Updated__c != '' ? Integer.valueOf(ld.No_of_Times_Updated__c) : 0;
        //         leadMap.put(ld.Id,String.valueOf(updatedCount));
        //     }
        //     System.debug('lead Map ===>' +leadMap);

        //     List<Lead> updatedList = new List<Lead>();
        //     for(Id leadUpdate : leadMap.keySet()){
                
        //         updatedList.add(new Lead(
        //             Id = leadUpdate,
        //             No_of_Times_Updated__c = leadMap.get(leadUpdate)
        //         ));

        //     }
        //     System.debug('updatedList===>' +updatedList);
        //     if(!updatedList.isEmpty()){
        //         update updatedList;
        //     }
        // }
    }
    

    // public static void recursiveCheck1(List<Lead> newList){
    //     for(Lead ld : newList){
    //         ld.Description = 'This is a recursive update at ' + Date.today();
    //     }
    // }


    /**
     * CH-01 update description if text(encrypted) is changed
     * @param newList
     * @return void
     */
    public static void checkDecryptChange(List<Lead> newList){
        List<Task> taskList = new List<Task>();
        for(Lead ld : newList){
            Lead oldMap = (Lead)Trigger.oldMap.get(ld.Id);

            if(ld.Decrypt_in_Flow__c != oldMap.Decrypt_in_Flow__c){
                Task tsk = new Task(
                    Subject = ld.Decrypt_in_Flow__c,
                    WhoId = ld.Id
                );
                taskList.add(tsk);
            }
        }
        insert taskList;
    }


    /**
     * CH-03    Assign lead to user based on country
     * @param  newList
     * @return  void
     */
    public static void assignLeadToUser(List<Lead> newList){

        Set<String> countrySet = new Set<String>();
        for(Lead ld : newList){
            if(ld.Country__c != null){
                countrySet.add(ld.Country__c);
            }
        }

        Map<String, List<User>> userMap = new Map<String, List<User>>();
        for(User u : [SELECT Id,Country__c FROM User WHERE Country__c IN :countrySet]){
            if(!userMap.containsKey(u.Country__c)){
                userMap.put(u.Country__c, new List<User>());
            }else{
                userMap.get(u.Country__c).add(u);
            }
        }
    }
}