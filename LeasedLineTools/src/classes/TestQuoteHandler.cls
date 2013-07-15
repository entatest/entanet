@isTest
private class TestQuoteHandler
{
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
    	String xml = '<ns:SearchResponseDetail xmlns:ns=\\"http:\\/\\/www.Opal.Org\\/EthernetPrice\\/schema\\"><ns:PostCode>TF3 3AT<\\/ns:PostCode><ns:RequestType>STD<\\/ns:RequestType><ns:FibreExchangeName>HOLLINSWOOD<\\/ns:FibreExchangeName><ns:FibreExchangeCode>WNHLN<\\/ns:FibreExchangeCode><ns:EthernetExchangeName>OAKENGATES<\\/ns:EthernetExchangeName><ns:EthernetExchangeCode>WNOAK<\\/ns:EthernetExchangeCode><ns:CollectorExchangeName>WOLVERHAMPTON<\\/ns:CollectorExchangeName><ns:CollectorExchangeCode>CMWV<\\/ns:CollectorExchangeCode><ns:Zone>2<\\/ns:Zone><ns:Distance>2540.55<\\/ns:Distance><ns:RAG>G<\\/ns:RAG><ns:PriceName>Wholesale &#163;1M-&#163;3M<\\/ns:PriceName><ns:ErrorCode>0<\\/ns:ErrorCode><ns:ErrorMsg\\/><ns:DataReference>June 2013<\\/ns:DataReference><ns:AccountList><ns:Circuit><ns:Service>10Mb \\/ 100Mb<\\/ns:Service><ns:AnnualPrice>7232<\\/ns:AnnualPrice><ns:SetUp1yr>975<\\/ns:SetUp1yr><ns:SetUp3yr>0<\\/ns:SetUp3yr><ns:SortLevel>1<\\/ns:SortLevel><\\/ns:Circuit><\\/ns:AccountList><\\/ns:SearchResponseDetail>';
    	String response = '{"talktalk":[{"siteRef":"' + siteRef + '","xml":"' + xml + '","error":""}]}';
    	QuoteHandler.parseQuote(response);
    	List<Product_Loaded_Status__c> statuses = Database.query('SELECT Status__c FROM Product_Loaded_Status__c WHERE Leased_Line_Quote_Request__c = :siteRef');
	    System.assertEquals('success', statuses[0].Status__c);
    }
    
    @isTest static void talktalkResponseParserTest()
    {
    	Leased_Line_Quote_Request__c llqr = new Leased_Line_Quote_Request__c();
    	insert llqr;
    	String siteRef = llqr.Id;
    	String xml = '<ns:SearchResponseDetail xmlns:ns="http://www.Opal.Org/EthernetPrice/schema"><ns:PostCode>TF3 3AT</ns:PostCode><ns:RequestType>STD</ns:RequestType><ns:FibreExchangeName>HOLLINSWOOD</ns:FibreExchangeName><ns:FibreExchangeCode>WNHLN</ns:FibreExchangeCode><ns:EthernetExchangeName>OAKENGATES</ns:EthernetExchangeName><ns:EthernetExchangeCode>WNOAK</ns:EthernetExchangeCode><ns:CollectorExchangeName>WOLVERHAMPTON</ns:CollectorExchangeName><ns:CollectorExchangeCode>CMWV</ns:CollectorExchangeCode><ns:Zone>2</ns:Zone><ns:Distance>2540.55</ns:Distance><ns:RAG>G</ns:RAG><ns:PriceName>Wholesale &#163;1M-&#163;3M</ns:PriceName><ns:ErrorCode>0</ns:ErrorCode><ns:ErrorMsg/><ns:DataReference>June 2013</ns:DataReference><ns:AccountList><ns:Circuit><ns:Service>10Mb / 100Mb</ns:Service><ns:AnnualPrice>7232</ns:AnnualPrice><ns:SetUp1yr>975</ns:SetUp1yr><ns:SetUp3yr>0</ns:SetUp3yr><ns:SortLevel>1</ns:SortLevel></ns:Circuit></ns:AccountList></ns:SearchResponseDetail>';
    	String error = '';
    	QuoteHandler.TalktalkResponseParser parser = new QuoteHandler.TalktalkResponseParser(
    		siteRef, null, null, null, xml, error
    	);
    	parser.parsePayload();
    	List<Talk_Talk_Product__c> products = Database.query('SELECT Id FROM Talk_Talk_Product__c WHERE Site_Ref__c = :siteRef');
    	System.assert(products.size() == 1);
    }
    
    @isTest static void virginResponseParserTest()
    {
    	Leased_Line_Quote_Request__c llqr = new Leased_Line_Quote_Request__c();
    	insert llqr;
    	String siteRef = llqr.Id;
    	String bearer = '100 Mb';
    	String bandwidth = '10 Mb';
    	String term = '3';
    	String xml = '<QuotePricing BPTQuoteRefNo="3640190"><SitePricing><Site /><Site AccessFlavour="On Net" /></SitePricing><TotalPricing><InstallRevenue>0</InstallRevenue><RentalRevenue>4751.125</RentalRevenue><AncillaryCharges><Install>0</Install><Rental>0</Rental></AncillaryCharges><QosCost><Install>0</Install><Rental>0</Rental></QosCost><ReportingCost><Install>0</Install><Rental>0</Rental></ReportingCost><TariffSummary>14253.375</TariffSummary></TotalPricing></QuotePricing>';
    	String error = '';
    	QuoteHandler.VirginResponseParser parser = new QuoteHandler.VirginResponseParser(
    		siteRef, bearer, bandwidth, term, xml, error
    	);
    	parser.parsePayload();
    	List<Virgin_Media_Product__c> products = Database.query('SELECT Id FROM Virgin_Media_Product__c WHERE Site_Ref__c = :siteRef');
    	System.assert(products.size() == 1);
    }
    
    @isTest static void talktalkUpdateTest()
    {
    	Leased_Line_Quote_Request__c llqr = new Leased_Line_Quote_Request__c();
    	insert llqr;
    	String siteRef = llqr.Id;
    	String distance = '1000';
    	String xml = '<ns:SearchResponseDetail xmlns:ns="http://www.Opal.Org/EthernetPrice/schema"><ns:PostCode>TF3 3AT</ns:PostCode><ns:RequestType>STD</ns:RequestType><ns:FibreExchangeName>HOLLINSWOOD</ns:FibreExchangeName><ns:FibreExchangeCode>WNHLN</ns:FibreExchangeCode><ns:EthernetExchangeName>OAKENGATES</ns:EthernetExchangeName><ns:EthernetExchangeCode>WNOAK</ns:EthernetExchangeCode><ns:CollectorExchangeName>WOLVERHAMPTON</ns:CollectorExchangeName><ns:CollectorExchangeCode>CMWV</ns:CollectorExchangeCode><ns:Zone>2</ns:Zone><ns:Distance>' + distance + '</ns:Distance><ns:RAG>G</ns:RAG><ns:PriceName>Wholesale &#163;1M-&#163;3M</ns:PriceName><ns:ErrorCode>0</ns:ErrorCode><ns:ErrorMsg/><ns:DataReference>June 2013</ns:DataReference><ns:AccountList><ns:Circuit><ns:Service>10Mb / 100Mb</ns:Service><ns:AnnualPrice>7232</ns:AnnualPrice><ns:SetUp1yr>975</ns:SetUp1yr><ns:SetUp3yr>0</ns:SetUp3yr><ns:SortLevel>1</ns:SortLevel></ns:Circuit></ns:AccountList></ns:SearchResponseDetail>';
    	String error = '';
    	QuoteHandler.TalktalkResponseParser parser = new QuoteHandler.TalktalkResponseParser(
    		siteRef, null, null, null, xml, error
    	);
    	parser.parsePayload();
    	List<Talk_Talk_Product__c> products = Database.query('SELECT Distance__c FROM Talk_Talk_Product__c WHERE Site_Ref__c = :siteRef');
    	Decimal oldDistance = products[0].Distance__c;
    	String newDistance = '2000';
    	xml = '<ns:SearchResponseDetail xmlns:ns="http://www.Opal.Org/EthernetPrice/schema"><ns:PostCode>TF3 3AT</ns:PostCode><ns:RequestType>STD</ns:RequestType><ns:FibreExchangeName>HOLLINSWOOD</ns:FibreExchangeName><ns:FibreExchangeCode>WNHLN</ns:FibreExchangeCode><ns:EthernetExchangeName>OAKENGATES</ns:EthernetExchangeName><ns:EthernetExchangeCode>WNOAK</ns:EthernetExchangeCode><ns:CollectorExchangeName>WOLVERHAMPTON</ns:CollectorExchangeName><ns:CollectorExchangeCode>CMWV</ns:CollectorExchangeCode><ns:Zone>2</ns:Zone><ns:Distance>' + newDistance + '</ns:Distance><ns:RAG>G</ns:RAG><ns:PriceName>Wholesale &#163;1M-&#163;3M</ns:PriceName><ns:ErrorCode>0</ns:ErrorCode><ns:ErrorMsg/><ns:DataReference>June 2013</ns:DataReference><ns:AccountList><ns:Circuit><ns:Service>10Mb / 100Mb</ns:Service><ns:AnnualPrice>7232</ns:AnnualPrice><ns:SetUp1yr>975</ns:SetUp1yr><ns:SetUp3yr>0</ns:SetUp3yr><ns:SortLevel>1</ns:SortLevel></ns:Circuit></ns:AccountList></ns:SearchResponseDetail>';
    	parser = new QuoteHandler.TalktalkResponseParser(
    		siteRef, null, null, null, xml, error
    	);
    	parser.parsePayload();
    	products = Database.query('SELECT Distance__c FROM Talk_Talk_Product__c WHERE Site_Ref__c = :siteRef');
    	System.assertNotEquals(oldDistance, products[0].Distance__c);
    }
}