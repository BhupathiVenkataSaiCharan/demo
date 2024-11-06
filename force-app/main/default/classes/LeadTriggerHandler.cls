public class LeadTriggerHandler {

    //if lead source web the rating cold else hot
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
}