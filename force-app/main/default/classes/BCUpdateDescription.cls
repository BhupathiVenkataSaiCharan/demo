global class BCUpdateDescription implements Database.Batchable<sObject>, Queueable {
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator('SELECT Id,Name,Description FROM Account');
    }
    global void execute(Database.BatchableContext BC,List<Account> accList){

        List<Account> accountsToUpdate = new List<Account>();
        for(Account acc : accList){
            acc.Description = 'Update by Batch on ' + Date.today();
            accountsToUpdate.add(acc);
        }
        update accountsToUpdate;
    }
    global void finish(Database.BatchableContext BC){
        
    }

    // global void execute(SchedulableContext SC){
    //     BCUpdateDescription obj = new BCUpdateDescription();
    //     Database.executeBatch(obj);
    // }


    global void execute(QueueableContext QC){

        String jobId = Database.executeBatch(this, 7);
        System.debug('jobId ::: ' +jobId);
    }
}