/**
 * CH-01                Charan              16-12-2024              Experience Cloud Practice
 */

public class createOppFromExperienceController {

    /**
     * CH-01    Diplay the List of Products on Experience Site
     * @param   none
     * @return  list of products
     */
    @AuraEnabled(cacheable=true)
    public static List<PricebookEntry> getProductsList(){

        List<PricebookEntry> products = [SELECT Product2.Id,Product2.Name,UnitPrice,Pricebook2.Name 
                                            FROM PricebookEntry 
                                                WHERE Pricebook2.IsActive = true 
                                                    AND IsActive = true 
                                                    AND Pricebook2.Name = 'Standard'];
                                                
        return products;
    }


    /**
     * CH-01    to check contact email and account, 
     *              if there then use those details to create opportunity 
     *              else create new contact, account and opportunity and add products
     * @param productList, contactEmail, contactName, accountName
     * @return 
     */
    @AuraEnabled
    public static void createOrder(String conEmail, String lName, String fName, String productListJSON){

        List<Object> rawList = (List<Object>)JSON.deserializeUntyped(productListJSON);

        List<Map<String,Object>> productList = new List<Map<String,Object>>();

        for(Object obj : rawList){
            productList.add((Map<String,Object>) obj);
        }
        System.debug('productList' +productList);

        if(conEmail == '' && lName == '' && fName == ''){
            return;
        }
        String conName = fName + ' ' + lName;

        List<Contact> existingContact = [SELECT Id,Name,Email,AccountId FROM Contact WHERE Email =:conEmail AND Name =:conName LIMIT 1];

        Account account;
        Contact contact;
        Opportunity opportunity;

        if(existingContact.isEmpty()){
            account = new Account(
                Name = conName
            );
            insert account;

            contact = new Contact(
                FirstName = fName,
                LastName = lName,
                Email = conEmail,
                AccountId = account.Id
            );
            insert contact;  
        }
        else{
            contact = existingContact[0];
            account = [SELECT Id FROM Account WHERE Id = :contact.AccountId];
        }
        opportunity = new Opportunity(
                Name = conName,
                CloseDate = Date.today(),
                StageName = 'Prospecting',
                AccountId = account.Id
            );
            insert opportunity;

        // List<OpportunityLineItem> lineItems = new List<OpportunityLineItem>();
        // for(Map<String,Object> product : productList){
        //     System.debug('product' +product);
        //     lineItems.add(new OpportunityLineItem(
        //         OpportunityId = opportunity.Id,
        //         PricebookEntryId = (Id) product.get('Product2Id'),
        //         Quantity = (Decimal) product.get('Quantity'),
        //         UnitPrice = (Decimal) product.get('Price')
        //     ));
        // }
        // System.debug('lineItems' +lineItems);
        // insert lineItems;
    }
}