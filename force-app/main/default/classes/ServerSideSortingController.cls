public class ServerSideSortingController {
    
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccounts(String orderBy, String orderDirection, Integer pageSize, Integer pageNumber){
        
        String query = 'SELECT Id, Name, Industry FROM Account';

        if(orderBy != null && orderDirection != null){
            query += ' ORDER BY ' + orderBy + ' ' + orderDirection;
        }

        if(pageNumber > 0){
            query += ' LIMIT ' + pageSize + ' OFFSET ' + (pageNumber - 1) * pagesize ;
        }

        System.debug('Query===>' +query);

        return Database.query(query);
    }

    @AuraEnabled(cacheable=true)
    public static Integer getTotal(){
        return [SELECT COUNT() FROM Account];
    }
}