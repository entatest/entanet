@isTest(SeeAllData=true)
private class bg_OpportunityLineItemQuoteTriggerTest {

    static testMethod void myUnitTest() {
 
 		// Get the standard pricebook
        PriceBook2 pb2Standard = [select Id from Pricebook2 where isStandard=true];

		// Create an account and set the Type
        Account testAccount = new Account(Name='Test Account', Type='Reseller');
        insert testAccount;
        System.assertEquals('Test Account', testAccount.Name);
                
        // Create an opportunity and associate it with the test account
        Opportunity o = new Opportunity(AccountId=testAccount.Id, Name='Test Opportunity', 
                                                StageName='Qualification', CloseDate=Date.today());
        insert o;
        Opportunity opp = [SELECT Name FROM Opportunity WHERE Id = :o.Id];
        System.assertEquals('Test Opportunity', opp.Name);
                
        // Create a fixed price product
        Product2 p2Fixed = new Product2(Name='Test Product',isActive=true, Fixed_Price_Product__c=true, Cost_Price__c =500);
        insert p2Fixed;
        Product2 p2exFixed = [SELECT Name FROM Product2 WHERE Id = :p2Fixed.Id];
        System.assertEquals('Test Product', p2exFixed.Name);

        // Create a non-fixed price product
        Product2 p2NotFixed = new Product2(Name='Test Product',isActive=true, Fixed_Price_Product__c=false);
        insert p2NotFixed;
        Product2 p2exNotFixed = [SELECT Name FROM Product2 WHERE Id = :p2NotFixed.Id];
        System.assertEquals('Test Product', p2exNotFixed.Name);
                
        // Create pricebook entries so we can set the price of the test products
        PricebookEntry pbeFixed = new PricebookEntry(Pricebook2Id=pb2Standard.Id, Product2Id=p2Fixed.Id, UnitPrice=99, isActive=true);
        insert pbeFixed;
        PricebookEntry pbeexFixed = [SELECT Pricebook2Id, UnitPrice FROM PricebookEntry WHERE Id = :pbeFixed.Id];
        System.assertEquals(pb2Standard.Id, pbeexFixed.Pricebook2Id);

        PricebookEntry pbeNotFixed = new PricebookEntry(Pricebook2Id=pb2Standard.Id, Product2Id=p2NotFixed.Id, UnitPrice=99, isActive=true);
        insert pbeNotFixed;
        PricebookEntry pbeexNotFixed = [SELECT Pricebook2Id, UnitPrice FROM PricebookEntry WHERE Id = :pbeNotFixed.Id];
        System.assertEquals(pb2Standard.Id, pbeexNotFixed.Pricebook2Id);
                
        // Create an OpportunityLineItem representing the fixed price product and add it to the opportunity
        OpportunityLineItem oliFixed = new OpportunityLineItem(PriceBookEntryId=pbeFixed.Id, OpportunityId=o.Id, Quantity=1);
        insert oliFixed;
        OpportunityLineItem oliexFixed = [SELECT PriceBookEntryId FROM OpportunityLineItem WHERE Id = :oliFixed.Id];
        System.assertEquals(pbeFixed.Id, oliexFixed.PriceBookEntryId); 

        // Create a quote for the opportunity with the fixed price product added.
        // Covers the case for setting quote expiration date where all opportunity products are fixed price
        Quote quoteFixed = new Quote(Name='Fixed Price Quote',
        								Cancellation_Notice_Period__c = '45',
        								 Minimum_Contract_Term__c = '36',
        								 Payment_Term__c = 'Quaterly', OpportunityId=o.Id);
        insert quoteFixed;
        System.assertEquals('Fixed Price Quote', quoteFixed.Name); 
        
        OpportunityLineItem oliNotFixed = new OpportunityLineItem(PriceBookEntryId=pbeNotFixed.Id, OpportunityId=o.Id, Quantity=1, TotalPrice=99);
        insert oliNotFixed;
        OpportunityLineItem oliexNotFixed = [SELECT PriceBookEntryId FROM OpportunityLineItem WHERE Id = :oliNotFixed.Id];
        System.assertEquals(pbeNotFixed.Id, oliexNotFixed.PriceBookEntryId); 
        
        oliexNotFixed.Cost_Price__c = 250;
        update oliexNotFixed;
        System.assertEquals(250, oliexNotFixed.Cost_Price__c); 

        // Create quote to cover case where all at least one opp product is not fixed price
        Quote quoteNotFixed = new Quote(Name='Non-Fixed Price Quote', Cancellation_Notice_Period__c = '45',
        								 Minimum_Contract_Term__c = '36',
        								 Payment_Term__c = 'Quaterly',OpportunityId=o.Id);
        insert quoteNotFixed;
        System.assertEquals('Non-Fixed Price Quote', quoteNotFixed.Name); 
    }
}