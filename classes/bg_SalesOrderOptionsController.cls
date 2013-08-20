public with sharing class bg_SalesOrderOptionsController {
	public Opportunity MyOpportunity {public get; private set;}
	public Organization MyOrganization {public get; private set;}
	public Account MyAccount {public get; private set;}
	public Quote MyQuote {public get; private set;}
	
	
	/*//installation charges section
	
	//Visit or Ship bullet
	public String VisitOrShip {public get; public set;}
	public list<SelectOption> getVisitOrShipOptions(){
		List<SelectOption> options = new List<SelectOption>();
 	 	for(String s : bg_SalesOrderHelper.getVisitOrShipOptions()){
	 	 	options.add(new SelectOption(s,s));
 	 	}
 	 	return options;
	}
	public String getVisitOrShipText(){
		return bg_SalesOrderHelper.getVisitOrShipText(VisitOrShip);
	}
	//ADSL LLU FTTC bullet
	public String AdslLluFttc {public get; public set;}
	public list<SelectOption> getAdslLluFttcOptions(){
		List<SelectOption> options = new List<SelectOption>();
 	 	for(String s : bg_SalesOrderHelper.getAdslLluTccpOptions()){
	 	 	options.add(new SelectOption(s,s));
 	 	}
 	 	return options;
	}
	public String getAdslLluFttcText(){
		return bg_SalesOrderHelper.getAdslLluTccpText(AdslLluFttc);
	}
	
	//Optional Firewall bullet
	public boolean EntaNetSonicWall {public get; public set;}
	public String getEntaNetSonicWallText() {
		return bg_SalesOrderHelper.getEntaNetSonicWallText();
	}*/
	public boolean NoFirewall1 {public get; public set;}
	public boolean NoFirewall2 {public get; public set;}	
	public void selectNoFirewall1(){
		if(NoFirewall1)
			NoFirewall2 = false;
	}
	public void selectNoFirewall2(){
		if(NoFirewall2)
			NoFirewall1 = false;
	}
	
	public String ExtraComments {public get; public set;}
	
	//is Talk Talk EFM product included
	public boolean TalkTalkEFM {public get; public set;}
	/*public String getTalkTalkEFMText() {
		return bg_SalesOrderHelper.getTalkTalkEFMText();
	}*/
	
	public boolean TalkTalkEducation {public get; public set;}
	/*public String getTalkTalkEducationText(){
		return bg_SalesOrderHelper.getTalkTalkEducationText();
	}*/
		
	public boolean BTEFM {public get; public set;}
	/*public String getBTEFMText(){
		return bg_SalesOrderHelper.getBTEFMText();
	}*/
	
	public boolean PointToPointCircuits {public get; public set;}
	public boolean PointToPointUpgrade1 {public get; public set;}
	public boolean PointToPointUpgrade2 {public get; public set;}
	public boolean ShowUpgrageMandatoryMessage {public get; private set;}
	public void selectPointToPointUpgrade1(){
		if(PointToPointUpgrade1){
			PointToPointUpgrade2 = false;
		}
	}
	public void selectPointToPointUpgrade2(){
		if(PointToPointUpgrade2){
			PointToPointUpgrade1 = false;
		}
	}
	
	/*public String getPointToPointCircuitsText(){
		return bg_SalesOrderHelper.getPointToPointCircuitsText();
	}
	public String ExistingCircuitsUpgrade {public get; public set;}
	public list<SelectOption> getExistingCircuitsOptions(){
		List<SelectOption> options = new List<SelectOption>();
 	 	for(String s : bg_SalesOrderHelper.getPointToPointUpgradeOptions()){
	 	 	options.add(new SelectOption(s,s));
 	 	}
 	 	return options;
	}
	public String getExistingCircuitsText(){
		return bg_SalesOrderHelper.getPointToPointUpgradeText(ExistingCircuitsUpgrade);
	}*/
	
	public String getTodaysDate(){
		return system.today().format();
	}
	
	public boolean getIsEndUser(){
		return MyAccount.Type.equals('End User');
	}
	
	private list<OpportunityLineItem> all_products;
	public list<OpportunityLineItem> InstallationCharges {public get; private set;}
	public list<OpportunityLineItem> RecurringCharges {public get; private set;}
	public list<OpportunityLineItem> OneOffCharges {public get; private set;}
	public list<OppLineItemWrapper> OpportunityProducts {public get; private set;}
	
	public boolean Problem {public get; private set;}
	public boolean Prepared{public get; private set;} //this is used to controll access to Generate button (as the prepare button must be pressed first)
	
	public bg_SalesOrderOptionsController(ApexPages.StandardController controller){
		this.NoFirewall1 = false;
		this.NoFirewall2 = false;
		this.PointToPointUpgrade1 = false;
		this.PointToPointUpgrade2 = false;
		this.Prepared = false;
		
		try{
			//Retrieve relevant records
			MyOpportunity = [select Id, Name, AccountId, Order_Type__c, Amount, Owner.Name from Opportunity where Id = :controller.getId()];
			MyAccount = [Select a.Phone, a.Accounts_Sales_Admin__c, a.Reseller__c, a.SAGE_Code__c, a.Type, a.Name, a.BillingStreet, a.BillingState, a.BillingPostalCode, a.BillingCountry, a.BillingCity From Account a where a.Id = :MyOpportunity.AccountId];
			MyQuote = [select PO_Number__c, Minimum_Contract_Term__c, Cancellation_Notice_Period__c, Payment_Term__c, Phone, BillingName, QuoteNumber, BillingStreet, BillingState, BillingPostalCode, BillingCountry, BillingCity from Quote where IsSyncing = true and OpportunityId = :MyOpportunity.Id];
			MyOrganization = [Select o.Street, o.State, o.PostalCode, o.Phone, o.Name, o.Fax, o.Country, o.City From Organization o];
			Problem = false;
		}
		catch(Exception e){
			Problem = true;
		}	
		/*
		all_products = [Select o.UnitPrice, o.TotalPrice, o.ServiceDate, o.Sales_Price_Calculation__c, o.Quantity, o.PricebookEntryId, o.Price_Locked__c, o.OpportunityId, o.ListPrice, o.IsDeleted, o.Id, o.Fixed_Price_Product__c, o.Description, o.Cost_Price__c From OpportunityLineItem o Where o.OpportunityId = :MyOpportunity.Id];
			system.debug('All Products ['+all_products+']');
			
			
			//get the product families
			map<Id,String> oli_family = createOppLineItemToProductFamilyMap(all_products);
			system.debug('product family map ['+oli_family+']');
			InstallationCharges = new list<OpportunityLineItem>();
			RecurringCharges = new list<OpportunityLineItem>();
			OneOffCharges = new list<OpportunityLineItem>();
			for(OpportunityLineItem oli : all_products)
				if(String.isNotBlank(oli_family.get(oli.Id)) && oli_family.get(oli.Id).equals('Installation Charges'))
					InstallationCharges.add(oli);
				else
					if(String.isNotBlank(oli_family.get(oli.Id)) && oli_family.get(oli.Id).equals('Recurring Charges'))
						RecurringCharges.add(oli);
					else
						OneOffCharges.add(oli);
			system.debug('InstallationCharges ['+InstallationCharges+']');
			system.debug('RecurringCharges ['+RecurringCharges+']');
			system.debug('OneOffCharges ['+OneOffCharges+']');
			
			OpportunityProducts = new list<OppLineItemWrapper>();
			for(integer i = 0; i < InstallationCharges.size(); i++){
				OpportunityProducts.add(new OppLineItemWrapper(InstallationCharges.get(i), i==0, (i==0?'***INSTALLATION CHARGES***':null)));
				system.debug(i + ' - ' + InstallationCharges.get(i));
			}
			for(integer i = 0; i < RecurringCharges.size(); i++){
				OpportunityProducts.add(new OppLineItemWrapper(RecurringCharges.get(i), i==0, (i==0?'***RECURRING CHARGES***':null)));
				system.debug(i + ' - ' + RecurringCharges.get(i));
			}
			for(integer i = 0; i < OneOffCharges.size(); i++){
				OpportunityProducts.add(new OppLineItemWrapper(OneOffCharges.get(i), i==0, (i==0?'***ONE-OFF CHARGES***':null)));
				system.debug(i + ' - ' + OneOffCharges.get(i));
			}
			
			if(NoFirewall1 || NoFirewall2 || String.isNotBlank(ExtraComments)){
				OpportunityProducts.add(new OppLineItemWrapper(new OpportunityLineItem(), false, null));
				if(NoFirewall1)
					OpportunityProducts.add(new OppLineItemWrapper(new OpportunityLineItem(Description='NO Firewall solution has been quoted'), false, null));
				if(NoFirewall2)
					OpportunityProducts.add(new OppLineItemWrapper(new OpportunityLineItem(Description='Entanet International Ltd Managed Sonicwall Firewall Monthly'), false, null));
				if(String.isNotBlank(ExtraComments)){
					for(String s : ExtraComments.split('\n'))
						if(String.isNotBlank(s))
							OpportunityProducts.add(new OppLineItemWrapper(new OpportunityLineItem(Description=s), false, null));
				}
			}
			
			
			
			OpportunityProducts.add(new OppLineItemWrapper(new OpportunityLineItem(Description='Premier Support Helpdesk - 1st/2nd Level Support'), true, '*** ENTANET INTERNATIONAL LTD SERVICES INCLUDE ***'));
			OpportunityProducts.add(new OppLineItemWrapper(new OpportunityLineItem(Description='8 IP Addresses'), false, null));
			OpportunityProducts.add(new OppLineItemWrapper(new OpportunityLineItem(Description='27x7 Technical Support. Includeds out of hours mobile communications.'), false, null));
			OpportunityProducts.add(new OppLineItemWrapper(new OpportunityLineItem(Description='SLA of 100% Service Availability accross Entanet International Limited\'s UK network'), false, null));
			*/
	}
	
	private map<Id,String> createOppLineItemToProductFamilyMap(list<OpportunityLineItem> items){
		//link PricebookEntry to OppLineItem
		map<Id,Id> pe_oli = new map<Id,Id>();
		for(OpportunityLineItem oli : items)
			pe_oli.put(oli.PricebookEntryId, oli.Id);	
			
		//get all relevant PricebookEntry records and organise Product by PricebookEntry
		list<PricebookEntry> pes = [select Id, Product2Id from PricebookEntry where Id in :pe_oli.keySet()];
		map<Id,Id> pr_pe = new map<Id,Id>();
		for(PricebookEntry pe : pes)
			pr_pe.put(pe.Product2Id, pe.Id);
			
		//get all relevant Products and using above map OppLineItem to ProductFamily
		map<Id, String> oli_family = new map<Id,String>();
		for(Product2 p : [select Id, Family from Product2 where Id in :pr_pe.keySet()])
			oli_family.put(pe_oli.get(pr_pe.get(p.Id)), p.Family);
		return oli_family;
	}
	
	public PageReference prepareOptions(){
	if((String.isBlank(MyOpportunity.Order_Type__c) || !MyOpportunity.Order_Type__c.equals('Class C - Exisitng Customer/Replacement, Upgrade Etc')) || (MyOpportunity.Order_Type__c.equals('Class C - Exisitng Customer/Replacement, Upgrade Etc') && (PointToPointUpgrade1 || PointToPointUpgrade2))){
			ShowUpgrageMandatoryMessage = false;
			system.debug('Opportunity Id ['+MyOpportunity+']');
			all_products = [Select o.UnitPrice, o.TotalPrice, o.ServiceDate, o.Sales_Price_Calculation__c, o.Quantity, o.PricebookEntryId, o.Price_Locked__c, o.OpportunityId, o.ListPrice, o.IsDeleted, o.Id, o.Fixed_Price_Product__c, o.Description, o.Cost_Price__c From OpportunityLineItem o Where o.OpportunityId = :MyOpportunity.Id];
			system.debug('All Products ['+all_products+']');
			
			
			//get the product families
			map<Id,String> oli_family = createOppLineItemToProductFamilyMap(all_products);
			system.debug('product family map ['+oli_family+']');
			InstallationCharges = new list<OpportunityLineItem>();
			RecurringCharges = new list<OpportunityLineItem>();
			OneOffCharges = new list<OpportunityLineItem>();
			for(OpportunityLineItem oli : all_products)
				if(String.isNotBlank(oli_family.get(oli.Id)) && oli_family.get(oli.Id).equals('Installation Charges'))
					InstallationCharges.add(oli);
				else
					if(String.isNotBlank(oli_family.get(oli.Id)) && oli_family.get(oli.Id).equals('Recurring Charges'))
						RecurringCharges.add(oli);
					else
						OneOffCharges.add(oli);
			system.debug('InstallationCharges ['+InstallationCharges+']');
			system.debug('RecurringCharges ['+RecurringCharges+']');
			system.debug('OneOffCharges ['+OneOffCharges+']');
			
			OpportunityProducts = new list<OppLineItemWrapper>();
			for(integer i = 0; i < InstallationCharges.size(); i++){
				OpportunityProducts.add(new OppLineItemWrapper(InstallationCharges.get(i), i==0, (i==0?'***INSTALLATION CHARGES***':null)));
				system.debug(i + ' - ' + InstallationCharges.get(i));
			}
			for(integer i = 0; i < RecurringCharges.size(); i++){
				OpportunityProducts.add(new OppLineItemWrapper(RecurringCharges.get(i), i==0, (i==0?'***RECURRING CHARGES***':null)));
				system.debug(i + ' - ' + RecurringCharges.get(i));
			}
			for(integer i = 0; i < OneOffCharges.size(); i++){
				OpportunityProducts.add(new OppLineItemWrapper(OneOffCharges.get(i), i==0, (i==0?'***ONE-OFF CHARGES***':null)));
				system.debug(i + ' - ' + OneOffCharges.get(i));
			}
			system.debug('firewall 1 ['+NoFirewall1+']');
			system.debug('firewall 2 ['+NoFirewall2+']');
			system.debug('extra comments ['+ExtraComments+']');
			
			if(NoFirewall1 || NoFirewall2 || String.isNotBlank(ExtraComments)){
				OpportunityProducts.add(new OppLineItemWrapper(new OpportunityLineItem(), false, null));
				if(NoFirewall1)
					OpportunityProducts.add(new OppLineItemWrapper(new OpportunityLineItem(Description='NO Firewall solution has been quoted'), false, null));
				if(NoFirewall2)
					OpportunityProducts.add(new OppLineItemWrapper(new OpportunityLineItem(Description='Entanet International Ltd Managed Sonicwall Firewall Monthly'), false, null));
				if(String.isNotBlank(ExtraComments)){
					for(String s : ExtraComments.split('\n'))
						if(String.isNotBlank(s))
							OpportunityProducts.add(new OppLineItemWrapper(new OpportunityLineItem(Description=s), false, null));
				}
			}
			
			
			
			OpportunityProducts.add(new OppLineItemWrapper(new OpportunityLineItem(Description='Premier Support Helpdesk - 1st/2nd Level Support'), true, '*** ENTANET INTERNATIONAL LTD SERVICES INCLUDE ***'));
			OpportunityProducts.add(new OppLineItemWrapper(new OpportunityLineItem(Description='8 IP Addresses'), false, null));
			OpportunityProducts.add(new OppLineItemWrapper(new OpportunityLineItem(Description='27x7 Technical Support. Includeds out of hours mobile communications.'), false, null));
			OpportunityProducts.add(new OppLineItemWrapper(new OpportunityLineItem(Description='SLA of 100% Service Availability accross Entanet International Limited\'s UK network'), false, null));
			system.debug('OpportunityProducts ['+OpportunityProducts+']');
			
			
			Prepared = true;
			}
		else{
			ShowUpgrageMandatoryMessage = true;
			system.debug('Missing upgrade option, showing error ['+ShowUpgrageMandatoryMessage+']');
			
		}
		return null;
	}
	
	public PageReference generatePDF(){
				
			PageReference pdf = Page.bg_SalesOrder;
			if(savePDFtoQuote(pdf))
				return pdf;
			else
				return null;
		
	}
	
	public Boolean ErrorGettingContent {public get; private set;}
	public Boolean ErrorSavingPDF {public get; private set;}
	
	private Boolean savePDFtoQuote(PageReference pdf){
		ErrorGettingContent = false;
		ErrorSavingPDF = false;
		
		Blob body;
		try{
			body = pdf.getContentAsPdf();
		}
		catch(VisualForceException e){
			ErrorGettingContent = true;	
			return false;
		}
		if(!ErrorGettingContent){
			try{
				Attachment att = new Attachment();
				att.body = body;
				att.IsPrivate = false;
				Date t = Date.today();
				att.Name = (String.IsNotBlank(MyOpportunity.Name)?MyOpportunity.Name:'Opportunity') + '_' + (String.IsNotBlank(MyQuote.QuoteNumber)?MyQuote.QuoteNumber:'QuoteNo') + '_' + t.year() + ((t.month()<10)?('0'+t.month()):String.valueOf(t.month())) + ((t.day()<10)?('0'+t.day()):String.valueOf(t.day())) + '.pdf';
				att.ParentId = MyQuote.Id;
				insert att;
			}
			catch(Exception e){
				system.debug('Problem saving ['+e+']');
				ErrorSavingPDF = true;
				return false;
			}
		}
		return true;
	}
	
	public PageReference cancel(){
		return new PageReference('/' + MyOpportunity.Id);
	}
	
	public class OppLineItemWrapper{
		public OpportunityLineItem opi {public get; private set;}
		public boolean showHeader {public get; private set;}
		public String header {public get; private set;}
		public OppLineItemWrapper(OpportunityLineItem item, boolean show, String head){
			opi = item;
			showHeader = show;
			header = head;
		}
	}
}