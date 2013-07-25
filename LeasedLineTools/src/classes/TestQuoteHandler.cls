@isTest
private class TestQuoteHandler
{
    private static String virginXml = '<QuotePricing BPTQuoteRefNo="3640190"><SitePricing><Site /><Site AccessFlavour="On Net" /></SitePricing><TotalPricing><InstallRevenue>0</InstallRevenue><RentalRevenue>4751.125</RentalRevenue><AncillaryCharges><Install>0</Install><Rental>0</Rental></AncillaryCharges><QosCost><Install>0</Install><Rental>0</Rental></QosCost><ReportingCost><Install>0</Install><Rental>0</Rental></ReportingCost><TariffSummary>14253.375</TariffSummary></TotalPricing></QuotePricing>';
    private static String talktalkXml = '<ns:SearchResponseDetail xmlns:ns="http://www.Opal.Org/EthernetPrice/schema"><ns:PostCode>TF3 3AT</ns:PostCode><ns:RequestType>STD</ns:RequestType><ns:FibreExchangeName>HOLLINSWOOD</ns:FibreExchangeName><ns:FibreExchangeCode>WNHLN</ns:FibreExchangeCode><ns:EthernetExchangeName>OAKENGATES</ns:EthernetExchangeName><ns:EthernetExchangeCode>WNOAK</ns:EthernetExchangeCode><ns:CollectorExchangeName>WOLVERHAMPTON</ns:CollectorExchangeName><ns:CollectorExchangeCode>CMWV</ns:CollectorExchangeCode><ns:Zone>2</ns:Zone><ns:Distance>2540.55</ns:Distance><ns:RAG>G</ns:RAG><ns:PriceName>Wholesale &#163;1M-&#163;3M</ns:PriceName><ns:ErrorCode>0</ns:ErrorCode><ns:ErrorMsg/><ns:DataReference>June 2013</ns:DataReference><ns:AccountList><ns:Circuit><ns:Service>10Mb / 100Mb</ns:Service><ns:AnnualPrice>7232</ns:AnnualPrice><ns:SetUp1yr>975</ns:SetUp1yr><ns:SetUp3yr>0</ns:SetUp3yr><ns:SortLevel>1</ns:SortLevel></ns:Circuit><ns:Circuit><ns:Service>20Mb / 100Mb</ns:Service><ns:AnnualPrice>7602</ns:AnnualPrice><ns:SetUp1yr>975</ns:SetUp1yr><ns:SetUp3yr>0</ns:SetUp3yr><ns:SortLevel>2</ns:SortLevel></ns:Circuit></ns:AccountList></ns:SearchResponseDetail>';
    
    @isTest static void unknownProviderTest()
    {
    	String response = '{"invalid":[{"siteRef":"xxxx","xml":"<xxx></xxx>","error":""}]}';
    	String status = QuoteHandler.parseQuote(response);
    	System.assertEquals(QuoteHandler.INVALID_PROVIDER, status);
    }
    
    @isTest static void nullSiteRefTest()
    {
    	String response = '{"talktalk":[{"xml":"<xxx></xxx>","error":""}]}';
    	String status = QuoteHandler.parseQuote(response);
    	System.assertEquals(QuoteHandler.INVALID_SITE_REF, status);
    }
    
    @isTest static void invalidSiteRefTest()
    {
    	String response = '{"talktalk":[{"siteRef":"xxxx","xml":"<xxx></xxx>","error":""}]}';
    	String status = QuoteHandler.parseQuote(response);
    	System.assertEquals(QuoteHandler.INVALID_SITE_REF, status);
    }
    
	@isTest static void invalidXmlTest()
    {
    	Leased_Line_Quote_Request__c llqr = new Leased_Line_Quote_Request__c();
    	insert llqr;
    	String siteRef = llqr.Id;
    	String xml = 'invalid';
    	String response = '{"talktalk":[{"siteRef":"' + siteRef + '","xml":"' + xml + '","error":""}]}';
    	String status = QuoteHandler.parseQuote(response);
    	System.assertEquals(QuoteHandler.INVALID_XML, status);
    }
    
    @isTest static void talktalkEmptyXmlAndErrorTest()
    {
    	Leased_Line_Quote_Request__c llqr = new Leased_Line_Quote_Request__c();
    	insert llqr;
    	String siteRef = llqr.Id;
    	String response = '{"talktalk":[{"siteRef":"' + siteRef + '","xml":"","error":""}]}';
    	String status = QuoteHandler.parseQuote(response);
    	System.assertEquals(QuoteHandler.INCOMPLETE_DATA, status);
    }
    
    @isTest static void virginEmptyXmlAndErrorTest()
    {
    	Leased_Line_Quote_Request__c llqr = new Leased_Line_Quote_Request__c();
    	insert llqr;
    	String siteRef = llqr.Id;
    	String response = '{"virgin":[{"siteRef":"' + siteRef + '","bearer":"100 Mb","bandwidth":"100 Mb","term":"3","xml":"","error":""}]}';
    	String status = QuoteHandler.parseQuote(response);
    	System.assertEquals(QuoteHandler.INCOMPLETE_DATA, status);
    }
    
    @isTest static void virginEmptySupportDataAndErrorTest()
    {
    	Leased_Line_Quote_Request__c llqr = new Leased_Line_Quote_Request__c();
    	insert llqr;
    	String siteRef = llqr.Id;
    	String xml = virginXml.escapeEcmaScript();
    	String response = '{"virgin":[{"siteRef":"' + siteRef + '","xml":"' + xml + '","error":""}]}';
    	String status = QuoteHandler.parseQuote(response);
    	System.assertEquals(QuoteHandler.INCOMPLETE_DATA, status);
    }
    
    @isTest static void talktalkSaveFailureStatusTest()
    {
    	Leased_Line_Quote_Request__c llqr = new Leased_Line_Quote_Request__c();
    	insert llqr;
    	String siteRef = llqr.Id;
    	String response = '{"talktalk":[{"siteRef":"' + siteRef + '","xml":"","error":""}]}';
    	QuoteHandler.parseQuote(response);
    	List<Product_Loaded_Status__c> statuses = Database.query('SELECT Status__c FROM Product_Loaded_Status__c WHERE Leased_Line_Quote_Request__c = :siteRef');
	    System.assertEquals('failure', statuses[0].Status__c);
    }
    
    @isTest static void talktalkSaveSuccessStatusTest()
    {
    	Leased_Line_Quote_Request__c llqr = new Leased_Line_Quote_Request__c();
    	insert llqr;
    	String siteRef = llqr.Id;
    	String xml = talktalkXml.escapeEcmaScript();
    	String response = '{"talktalk":[{"siteRef":"' + siteRef + '","xml":"' + xml + '","error":""}]}';
    	QuoteHandler.parseQuote(response);
    	List<Product_Loaded_Status__c> statuses = Database.query('SELECT Status__c FROM Product_Loaded_Status__c WHERE Leased_Line_Quote_Request__c = :siteRef');
	    System.assertEquals('success', statuses[0].Status__c);
    }
    
    @isTest static void talktalkResponseParserTest()
    {
    	TestUtil.createTalktalkProducts();
    	Leased_Line_Quote_Request__c llqr = new Leased_Line_Quote_Request__c();
    	insert llqr;
    	String siteRef = llqr.Id;
    	String xml = talktalkXml.escapeEcmaScript();
    	String response = '{"talktalk":[{"siteRef":"' + siteRef + '","xml":"' + xml + '","error":""}]}';
    	QuoteHandler.parseQuote(response);
    	List<Talk_Talk_Product__c> products = [SELECT Product_Id__c FROM Talk_Talk_Product__c WHERE Site_Ref__c = :siteRef];
    	System.assert(products.size() == 8);
    }
    
   @isTest static void virginResponseParserTest()
    {
    	Leased_Line_Quote_Request__c llqr = new Leased_Line_Quote_Request__c();
    	insert llqr;
    	String siteRef = llqr.Id;
    	String xml = virginXml.escapeEcmaScript();
    	String response = '{"virgin":[{"siteRef":"' + siteRef + '","bearer":"100 Mb","bandwidth":"10 Mb","term":"3","xml":"' + xml + '","error":""}]}';
    	QuoteHandler.parseQuote(response);
    	List<Virgin_Media_Product__c> products = Database.query('SELECT Id FROM Virgin_Media_Product__c WHERE Site_Ref__c = :siteRef');
    	System.assert(products.size() == 1);
    }
    
    @isTest static void talktalkUpdateTest()
    {
    	TestUtil.createTalktalkProducts();
    	Leased_Line_Quote_Request__c llqr = new Leased_Line_Quote_Request__c();
    	insert llqr;
    	String siteRef = llqr.Id;
    	String xml = talktalkXml.replace('<ns:Distance>2540.55</ns:Distance>', '<ns:Distance>1000</ns:Distance>');
    	xml = xml.escapeEcmaScript();
    	String response = '{"talktalk":[{"siteRef":"' + siteRef + '","xml":"' + xml + '","error":""}]}';
    	QuoteHandler.parseQuote(response);
    	List<Talk_Talk_Product__c> products = [SELECT Distance__c FROM Talk_Talk_Product__c WHERE Site_Ref__c = :siteRef];
    	Decimal oldDistance = products[0].Distance__c;
    	xml = talktalkXml.replace('<ns:Distance>2540.55</ns:Distance>', '<ns:Distance>2000</ns:Distance>');
    	xml = xml.escapeEcmaScript();
    	response = '{"talktalk":[{"siteRef":"' + siteRef + '","xml":"' + xml + '","error":""}]}';
    	QuoteHandler.parseQuote(response);
    	products = [SELECT Distance__c FROM Talk_Talk_Product__c WHERE Site_Ref__c = :siteRef];
    	System.assertNotEquals(oldDistance, products[0].Distance__c);
    }
    
    @isTest static void talktalkErrorTest()
    {
    	Leased_Line_Quote_Request__c llqr = new Leased_Line_Quote_Request__c();
    	insert llqr;
    	String siteRef = llqr.Id;
    	String error = 'Any old error';
    	String response = '{"talktalk":[{"siteRef":"' + siteRef + '","xml":"","error":"' + error + '"}]}';
    	QuoteHandler.parseQuote(response);
    	List<Talk_Talk_Product__c> products = Database.query('SELECT Error_Message__c FROM Talk_Talk_Product__c WHERE Site_Ref__c = :siteRef');
    	System.assert(products.size() == 1);
    	System.assertEquals(error, products[0].Error_Message__c);
    }
    
    @isTest static void talktalkErrorWithExistingProductsTest()
    {
    	TestUtil.createTalktalkProducts();
    	Leased_Line_Quote_Request__c llqr = new Leased_Line_Quote_Request__c();
    	insert llqr;
    	String siteRef = llqr.Id;
    	String xml = talktalkXml.escapeEcmaScript();
    	String response = '{"talktalk":[{"siteRef":"' + siteRef + '","xml":"' + xml + '","error":""}]}';
    	QuoteHandler.parseQuote(response);
    	List<Talk_Talk_Product__c> products = Database.query('SELECT Id FROM Talk_Talk_Product__c WHERE Site_Ref__c = :siteRef');
    	System.assert(products.size() == 8);
    	String error = 'Any old error';
    	response = '{"talktalk":[{"siteRef":"' + siteRef + '","xml":"","error":"' + error + '"}]}';
    	QuoteHandler.parseQuote(response);
    	products = Database.query('SELECT Error_Message__c FROM Talk_Talk_Product__c WHERE Site_Ref__c = :siteRef');
    	System.assert(products.size() == 1);
    	System.assertEquals(error, products[0].Error_Message__c);
    }
    
    @isTest static void talktalkResponseParserAfterErrorTest()
    {
    	TestUtil.createTalktalkProducts();
    	Leased_Line_Quote_Request__c llqr = new Leased_Line_Quote_Request__c();
    	insert llqr;
    	String siteRef = llqr.Id;
    	String error = 'Any old error';
    	String response = '{"talktalk":[{"siteRef":"' + siteRef + '","xml":"","error":"' + error + '"}]}';
    	QuoteHandler.parseQuote(response);
    	List<Talk_Talk_Product__c> products = Database.query('SELECT Error_Message__c FROM Talk_Talk_Product__c WHERE Site_Ref__c = :siteRef');
    	System.assert(products.size() == 1);
    	System.assertEquals(error, products[0].Error_Message__c);
    	String xml = talktalkXml.escapeEcmaScript();
    	response = '{"talktalk":[{"siteRef":"' + siteRef + '","xml":"' + xml + '","error":""}]}';
    	QuoteHandler.parseQuote(response);
    	products = Database.query('SELECT Id FROM Talk_Talk_Product__c WHERE Site_Ref__c = :siteRef');
    	System.debug(products.size());
    	System.assert(products.size() == 8);
    }
    
    @isTest static void virginMediaErrorTest()
    {
    	Leased_Line_Quote_Request__c llqr = new Leased_Line_Quote_Request__c();
    	insert llqr;
    	String siteRef = llqr.Id;
    	// Create 2 products the second of which has an error
    	String xml = virginXml.escapeEcmaScript();
    	String response = '{"virgin":[{"siteRef":"' + siteRef + '","bearer":"100 Mb","bandwidth":"10 Mb","term":"3","xml":"' + xml + '","error":""}]}';
    	QuoteHandler.parseQuote(response);
    	String error = 'Any old error';
    	response = '{"virgin":[{"siteRef":"' + siteRef + '","bearer":"100 Mb","bandwidth":"10 Mb","term":"5","xml":"","error":"' + error + '"}]}';
    	QuoteHandler.parseQuote(response);
    	List<Virgin_Media_Product__c> products = [SELECT Id, Error_Message__c FROM Virgin_Media_Product__c WHERE Site_Ref__c = :siteRef];
    	// Cannot filter a SOQL by text area values
    	List<Virgin_Media_Product__c> errorProducts = new List<Virgin_Media_Product__c>();
    	for (Virgin_Media_Product__c product : products) {
    		if (product.Error_Message__c == error) {
    			errorProducts.add(product);
    		}
    	}
    	System.assert(products.size() == 2);
    	System.assert(errorProducts.size() == 1);
    }
    
    @isTest static void virginErrorWithExistingProductsTest()
    {
    	Leased_Line_Quote_Request__c llqr = new Leased_Line_Quote_Request__c();
    	insert llqr;
    	String siteRef = llqr.Id;
    	// Create 2 valid products
    	String xml = virginXml.escapeEcmaScript();
    	String response = '{"virgin":[{"siteRef":"' + siteRef + '","bearer":"100 Mb","bandwidth":"10 Mb","term":"3","xml":"' + xml + '","error":""}]}';
    	QuoteHandler.parseQuote(response);
    	response = '{"virgin":[{"siteRef":"' + siteRef + '","bearer":"100 Mb","bandwidth":"10 Mb","term":"5","xml":"' + xml + '","error":""}]}';
    	QuoteHandler.parseQuote(response);
    	// Parse error response for same product as the second existing valid
    	String error = 'Any old error';
    	response = '{"virgin":[{"siteRef":"' + siteRef + '","bearer":"100 Mb","bandwidth":"10 Mb","term":"5","xml":"","error":"' + error + '"}]}';
    	QuoteHandler.parseQuote(response);
    	// We stiil have 2 products 1 of which overridden with error
    	List<Virgin_Media_Product__c> products = [SELECT Id, Error_Message__c FROM Virgin_Media_Product__c WHERE Site_Ref__c = :siteRef];
    	List<Virgin_Media_Product__c> errorProducts = new List<Virgin_Media_Product__c>();
    	for (Virgin_Media_Product__c product : products) {
    		if (product.Error_Message__c == error) {
    			errorProducts.add(product);
    		}
    	}
    	System.assert(products.size() == 2);
    	System.assert(errorProducts.size() == 1);
    }
    
    @isTest static void virginResponseParserAfterErrorTest()
    {
    	Leased_Line_Quote_Request__c llqr = new Leased_Line_Quote_Request__c();
    	insert llqr;
    	String siteRef = llqr.Id;
    	// Create 2 products the second of which has an error
    	String xml = virginXml.escapeEcmaScript();
    	String response = '{"virgin":[{"siteRef":"' + siteRef + '","bearer":"100 Mb","bandwidth":"10 Mb","term":"3","xml":"' + xml + '","error":""}]}';
    	QuoteHandler.parseQuote(response);
    	String error = 'Any old error';
    	response = '{"virgin":[{"siteRef":"' + siteRef + '","bearer":"100 Mb","bandwidth":"10 Mb","term":"5","xml":"","error":"' + error + '"}]}';
    	QuoteHandler.parseQuote(response);
    	List<Virgin_Media_Product__c> products = [SELECT Id, Error_Message__c FROM Virgin_Media_Product__c WHERE Site_Ref__c = :siteRef];
    	List<Virgin_Media_Product__c> errorProducts = new List<Virgin_Media_Product__c>();
    	for (Virgin_Media_Product__c product : products) {
    		if (product.Error_Message__c == error) {
    			errorProducts.add(product);
    		}
    	}
    	System.assert(products.size() == 2);
    	System.assert(errorProducts.size() == 1);
    	// Now overwrite error product with valid one
    	response = '{"virgin":[{"siteRef":"' + siteRef + '","bearer":"100 Mb","bandwidth":"10 Mb","term":"5","xml":"' + xml + '","error":""}]}';
    	QuoteHandler.parseQuote(response);
    	// Both products are now valid products
    	products = [SELECT Id, Error_Message__c FROM Virgin_Media_Product__c WHERE Site_Ref__c = :siteRef];
    	errorProducts = new List<Virgin_Media_Product__c>();
    	for (Virgin_Media_Product__c product : products) {
    		if (product.Error_Message__c == error) {
    			errorProducts.add(product);
    		}
    	}
    	System.assert(products.size() == 2);
    	System.assert(errorProducts.size() == 0);
    }
}