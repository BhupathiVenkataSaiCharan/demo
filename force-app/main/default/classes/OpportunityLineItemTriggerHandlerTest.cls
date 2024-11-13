@isTest
public class OpportunityLineItemTriggerHandlerTest {

    @isTest
    static void testProductInformationInsert() {
        Id standardPricebookId = Test.getStandardPricebookId();

        Opportunity opp = new Opportunity(Name = 'Test Opportunity', CloseDate = Date.today(), StageName = 'Prospecting');
        insert opp;
        
        Product2 productA = new Product2(Name = 'Product A', isActive = true);
        Product2 productB = new Product2(Name = 'Product B', isActive = true);
        insert new List<Product2>{ productA, productB };
        
        PricebookEntry pbeA = new PricebookEntry(Product2Id = productA.Id, Pricebook2Id = standardPricebookId, UnitPrice = 100, IsActive = true);
        PricebookEntry pbeB = new PricebookEntry(Product2Id = productB.Id, Pricebook2Id = standardPricebookId, UnitPrice = 200, IsActive = true);
        insert new List<PricebookEntry>{ pbeA, pbeB };
        
        OpportunityLineItem oli1 = new OpportunityLineItem(OpportunityId = opp.Id, Quantity = 1, PricebookEntryId = pbeA.Id, UnitPrice = 100);
        OpportunityLineItem oli2 = new OpportunityLineItem(OpportunityId = opp.Id, Quantity = 1, PricebookEntryId = pbeB.Id, UnitPrice = 200);
        insert new List<OpportunityLineItem>{ oli1, oli2 };
        
        Test.startTest();
        OpportunityLineItemTriggerHandler.ProductInformation(new List<OpportunityLineItem>{ oli1, oli2 });
        Test.stopTest();
        
        Opportunity updatedOpp = [SELECT Id, Products_List__c FROM Opportunity WHERE Id = :opp.Id];
        System.assertEquals('Product A,Product B', updatedOpp.Products_List__c, 'Initial insertion should match expected product names.');
    }

    @isTest
    static void testProductInformationUpdate() {
        Id standardPricebookId = Test.getStandardPricebookId();

        Opportunity opp = new Opportunity(Name = 'Test Opportunity', CloseDate = Date.today(), StageName = 'Prospecting');
        insert opp;
        
        Product2 productA = new Product2(Name = 'Product A', isActive = true);
        Product2 productC = new Product2(Name = 'Product C', isActive = true);
        insert new List<Product2>{ productA, productC };
        
        PricebookEntry pbeA = new PricebookEntry(Product2Id = productA.Id, Pricebook2Id = standardPricebookId, UnitPrice = 100, IsActive = true);
        PricebookEntry pbeC = new PricebookEntry(Product2Id = productC.Id, Pricebook2Id = standardPricebookId, UnitPrice = 300, IsActive = true);
        insert new List<PricebookEntry>{ pbeA, pbeC };
        
        // Insert OpportunityLineItem and then update it
        OpportunityLineItem oli = new OpportunityLineItem(OpportunityId = opp.Id, Quantity = 1, PricebookEntryId = pbeA.Id, UnitPrice = 100);
        insert oli;

        // Update to a different price or quantity to trigger the update scenario
        oli.Quantity = 2;
        
        Test.startTest();
        update oli;
        Test.stopTest();
        
        Opportunity updatedOpp = [SELECT Id, Products_List__c FROM Opportunity WHERE Id = :opp.Id];
        System.assertEquals('Product A', updatedOpp.Products_List__c, 'Update scenario should maintain correct product names after quantity update.');
    }

    @isTest
    static void testProductInformationDelete() {
        Id standardPricebookId = Test.getStandardPricebookId();

        Opportunity opp = new Opportunity(Name = 'Test Opportunity', CloseDate = Date.today(), StageName = 'Prospecting');
        insert opp;
        
        Product2 productA = new Product2(Name = 'Product A', isActive = true);
        Product2 productB = new Product2(Name = 'Product B', isActive = true);
        insert new List<Product2>{ productA, productB };
        
        PricebookEntry pbeA = new PricebookEntry(Product2Id = productA.Id, Pricebook2Id = standardPricebookId, UnitPrice = 100, IsActive = true);
        PricebookEntry pbeB = new PricebookEntry(Product2Id = productB.Id, Pricebook2Id = standardPricebookId, UnitPrice = 200, IsActive = true);
        insert new List<PricebookEntry>{ pbeA, pbeB };
        
        OpportunityLineItem oli1 = new OpportunityLineItem(OpportunityId = opp.Id, Quantity = 1, PricebookEntryId = pbeA.Id, UnitPrice = 100);
        OpportunityLineItem oli2 = new OpportunityLineItem(OpportunityId = opp.Id, Quantity = 1, PricebookEntryId = pbeB.Id, UnitPrice = 200);
        insert new List<OpportunityLineItem>{ oli1, oli2 };
        
        delete oli1;
        
        Test.startTest();
        OpportunityLineItemTriggerHandler.ProductInformation(new List<OpportunityLineItem>{ oli2 });
        Test.stopTest();
        
        Opportunity updatedOpp = [SELECT Id, Products_List__c FROM Opportunity WHERE Id = :opp.Id];
        System.assertEquals('Product B', updatedOpp.Products_List__c, 'Delete scenario should only list remaining products.');
    }
}