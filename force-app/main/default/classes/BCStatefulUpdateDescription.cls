global class BCStatefulUpdateDescription implements Database.Batchable<SObject>, Database.Stateful {

    global Integer totalPassedRecords = 0;
    global Integer totalFailedRecords = 0;

    global List<String> failedRecordIds = new List<String>(); 

    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([SELECT Id,Description FROM Account]);
    }

    global void execute(Database.BatchableContext BC, List<Account> accList){

        List<Account> accountsToUpdate = new List<Account>();

        for(Account acc : accList){
            try {
                acc.Description = 'Update from batch apex on' + Date.today();
                accountsToUpdate.add(acc);
                totalPassedRecords++;    
            } catch (Exception e) {
                totalFailedRecords++;
                failedRecordIds.add('Id:' + acc.Id + ',Error:' + e.getMessage());
            }
        }
        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
        }
    }

    global void finish(Database.BatchableContext BC){
        System.debug('Finish');
        System.debug('Success records count' +totalPassedRecords);
        System.debug('Failed Records Count' +totalFailedRecords);
        if(!failedRecordIds.isEmpty()){
            System.debug('Failed Records' +String.join(failedRecordIds,''));
        }
    }
}