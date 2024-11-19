/**
 * CH-01            Charan              15-11-2024              practice Scenarios
 * CH-02            Charan              15-11-2024              Interview Scenarios          
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
}