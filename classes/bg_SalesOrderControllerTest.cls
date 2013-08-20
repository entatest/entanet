public class bg_SalesOrderControllerTest {

	 @isTest(SeeAllData=True)
    static void myUnitTest() {
        Account account = new Account(Name='Test Account',
        							  Type='Reseller',
        							  Sage_Code__c = '123');
        insert account;
        
        Opportunity opportunity = new Opportunity(AccountId=account.Id,
        										  Name='My Opportunity',
        										  StageName='Closed Won',
        										  Sub_Status__c='Awaiting Salesorder / CRF to be sent',
        										  CloseDate=Date.newInstance(2013,7,2));
        insert opportunity;
        
    	
        system.debug('opportunity ['+opportunity+']');
        list<Product2> products = new list<Product2>();
        products.add(new Product2(Name='Product 1',IsActive=true,Family='Installation Charges'));
        products.add(new Product2(Name='Product 2',IsActive=true,Family='Installation Charges'));
        products.add(new Product2(Name='Product 3',IsActive=true,Family='Installation Charges'));
        products.add(new Product2(Name='Product 4',IsActive=true,Family='Installation Charges'));
        products.add(new Product2(Name='Product 5',IsActive=true,Family='Recurring Charges'));
        products.add(new Product2(Name='Product 6',IsActive=true,Family='Recurring Charges'));
        products.add(new Product2(Name='Product 7',IsActive=true,Family='Recurring Charges'));
        products.add(new Product2(Name='Product 8',IsActive=true,Family='One-Off Charges'));
        products.add(new Product2(Name='Product 9',IsActive=true,Family='One-Off Charges'));
    
    	insert products;
    
    	Id pbId = [select Id from Pricebook2 where IsStandard=true limit 1].Id;
    	
    	list<PricebookEntry> pbs = new list<PricebookEntry>();
    	for(Product2 p : products){
    		PricebookEntry pe = new PricebookEntry();
    		pe.Pricebook2Id = pbId;
    		pe.Product2Id = p.Id;
    		pe.IsActive = true;
    		pe.UnitPrice = 100;
    		pbs.add(pe);
    	}
    	insert pbs;
    	
    	 Quote quote = new Quote();
    	quote.OpportunityId = opportunity.Id;
    	quote.Pricebook2Id = pbId;
    	quote.Name = 'Quote';
    	quote.Cancellation_Notice_Period__c = '45';
       quote.Minimum_Contract_Term__c = '36';
        quote.Payment_Term__c = 'Quaterly';
    	insert quote;
    	
    	opportunity.SyncedQuoteId = quote.Id;
    	update opportunity;
    	
    	list<OpportunityLineItem> olis = new list<OpportunityLineItem>();
    	for(PricebookEntry pe : pbs){
    		OpportunityLineItem oli = new OpportunityLineItem();
    		oli.Description = 'Description';
    		oli.PricebookEntryId = pe.Id;
    		oli.Quantity = 1;
    		oli.UnitPrice = 100;
    		oli.OpportunityId = opportunity.Id;
    		olis.add(oli);
    	}
    	system.debug('OppLineItems ['+olis+']');
    	insert olis;
    	
  		system.debug('OppLineItemsInserted ['+[select Id, Description, OpportunityId, UnitPrice from OpportunityLineItem where Description = 'Description']+']');
    	
    	
    	system.debug('OppLineItemsInserted ['+[select Id, Description, OpportunityId, UnitPrice from OpportunityLineItem where Description = 'Description']+']');
    	
    	
    	bg_SalesOrderOptionsController controller = new bg_SalesOrderOptionsController(new ApexPages.Standardcontroller(opportunity));
    	controller.selectNoFirewall1();
    	controller.selectNoFirewall2();
    	controller.PointToPointCircuits = true;
    	controller.selectPointToPointUpgrade1();
    	controller.selectPointToPointUpgrade2();
    	controller.ExtraComments = 'My extra comment';
    	controller.prepareOptions();
    	controller.generatePDF();
    	
    	system.assertEquals(4, controller.InstallationCharges.size());
    	system.assertEquals(3, controller.RecurringCharges.size());
    	system.assertEquals(2, controller.OneOffCharges.size());
    }
    
    @isTest(SeeAllData=True)
    static void myUnitTest2() {
        Account account = new Account(Name='Test Account',
        							  Type='Reseller',
        							  Sage_Code__c = '123');
        insert account;
        
        Opportunity opportunity = new Opportunity(AccountId=account.Id,
        										  Name='My Opportunity',
        										  StageName='Closed Won',
        										  Order_Type__c = 'Class C - Exisitng Customer/Replacement, Upgrade Etc',
        										  Sub_Status__c='Awaiting Salesorder / CRF to be sent',
        										  CloseDate=Date.newInstance(2013,7,2));
        insert opportunity;
        
    	
        system.debug('opportunity ['+opportunity+']');
        list<Product2> products = new list<Product2>();
        products.add(new Product2(Name='Product 1',IsActive=true,Family='Installation Charges'));
        products.add(new Product2(Name='Product 2',IsActive=true,Family='Installation Charges'));
        products.add(new Product2(Name='Product 3',IsActive=true,Family='Installation Charges'));
        products.add(new Product2(Name='Product 4',IsActive=true,Family='Installation Charges'));
        products.add(new Product2(Name='Product 5',IsActive=true,Family='Recurring Charges'));
        products.add(new Product2(Name='Product 6',IsActive=true,Family='Recurring Charges'));
        products.add(new Product2(Name='Product 7',IsActive=true,Family='Recurring Charges'));
        products.add(new Product2(Name='Product 8',IsActive=true,Family='One-Off Charges'));
        products.add(new Product2(Name='Product 9',IsActive=true,Family='One-Off Charges'));
    
    	insert products;
    
    	Id pbId = [select Id from Pricebook2 where IsStandard=true limit 1].Id;
    	
    	list<PricebookEntry> pbs = new list<PricebookEntry>();
    	for(Product2 p : products){
    		PricebookEntry pe = new PricebookEntry();
    		pe.Pricebook2Id = pbId;
    		pe.Product2Id = p.Id;
    		pe.IsActive = true;
    		pe.UnitPrice = 100;
    		pbs.add(pe);
    	}
    	insert pbs;
    	
    	 Quote quote = new Quote();
    	quote.OpportunityId = opportunity.Id;
    	quote.Pricebook2Id = pbId;
    	quote.Name = 'Quote';
    	quote.Cancellation_Notice_Period__c = '45';
       quote.Minimum_Contract_Term__c = '36';
        quote.Payment_Term__c = 'Quaterly';
    	insert quote;
    	
    	opportunity.SyncedQuoteId = quote.Id;
    	update opportunity;
    	
    	list<OpportunityLineItem> olis = new list<OpportunityLineItem>();
    	for(PricebookEntry pe : pbs){
    		OpportunityLineItem oli = new OpportunityLineItem();
    		oli.Description = 'Description';
    		oli.PricebookEntryId = pe.Id;
    		oli.Quantity = 1;
    		oli.UnitPrice = 100;
    		oli.OpportunityId = opportunity.Id;
    		olis.add(oli);
    	}
    	system.debug('OppLineItems ['+olis+']');
    	insert olis;
    	
  		system.debug('OppLineItemsInserted ['+[select Id, Description, OpportunityId, UnitPrice from OpportunityLineItem where Description = 'Description']+']');
    	
    	
    	system.debug('OppLineItemsInserted ['+[select Id, Description, OpportunityId, UnitPrice from OpportunityLineItem where Description = 'Description']+']');
    	
    	
    	bg_SalesOrderOptionsController controller = new bg_SalesOrderOptionsController(new ApexPages.Standardcontroller(opportunity));
    	controller.prepareOptions();
    	controller.generatePDF();
    	
    	system.assert(controller.ShowUpgrageMandatoryMessage);
    }
}