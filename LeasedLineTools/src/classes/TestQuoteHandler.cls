@isTest
private class TestQuoteHandler
{
    @isTest static void unknownProviderTest()
    {
    	String response = '{"invalid":[{"siteRef":"xxxx","xml":"<xxx></xxx>","error":""}]}';
    	String status = QuoteHandler.parseQuote(response);
    	System.assertEquals('Unknown provider', status);
    }
    
    @isTest static void nullSiteRefTest()
    {
    	String response = '{"talktalk":[{"xml":"<xxx></xxx>","error":""}]}';
    	String status = QuoteHandler.parseQuote(response);
    	System.assertEquals('Invalid Site Reference', status);
    }
    
    @isTest static void invalidSiteRefTest()
    {
    	String response = '{"talktalk":[{"siteRef":"xxxx","xml":"<xxx></xxx>","error":""}]}';
    	String status = QuoteHandler.parseQuote(response);
    	System.assertEquals('Invalid Site Reference', status);
    }
	@isTest static void invalidXmlTest()
    {
    	Leased_Line_Quote_Request__c llqr = new Leased_Line_Quote_Request__c();
    	insert llqr;
    	String siteRef = llqr.Id;
    	String xml = 'invalid';
    	String response = '{"talktalk":[{"siteRef":"' + siteRef + '","xml":"' + xml + '","error":""}]}';
    	String status = QuoteHandler.parseQuote(response);
    	System.assertEquals('Invalid XML', status);
    }
    
    
    @isTest static void testTalktalkResponseParser()
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
    	System.debug(products.size());
    	System.assert(products.size() == 1);
    }
    
    /*@isTest static void testSaveStatus()
    {
    	Leased_Line_Quote_Request__c llqr = new Leased_Line_Quote_Request__c();
    	insert llqr;
    	String siteRef = llqr.Id;
    	//String xml = '<ns:SearchResponseDetail xmlns:ns=\\"http:\\/\\/www.Opal.Org\\/EthernetPrice\\/schema\\">\\r\\n\\t<ns:PostCode>TF3 3AT<\\/ns:PostCode>\\r\\n\\t<ns:RequestType>STD<\\/ns:RequestType>\\r\\n\\t<ns:FibreExchangeName>HOLLINSWOOD<\\/ns:FibreExchangeName>\\r\\n\\t<ns:FibreExchangeCode>WNHLN<\\/ns:FibreExchangeCode>\\r\\n\\t<ns:EthernetExchangeName>OAKENGATES<\\/ns:EthernetExchangeName>\\r\\n\\t<ns:EthernetExchangeCode>WNOAK<\\/ns:EthernetExchangeCode>\\r\\n\\t<ns:CollectorExchangeName>WOLVERHAMPTON<\\/ns:CollectorExchangeName>\\r\\n\\t<ns:CollectorExchangeCode>CMWV<\\/ns:CollectorExchangeCode>\\r\\n\\t<ns:Zone>2<\\/ns:Zone>\\r\\n\\t<ns:Distance>2540.55<\\/ns:Distance>\\r\\n\\t<ns:RAG>G<\\/ns:RAG>\\r\\n\\t<ns:PriceName>Wholesale &#163;1M-&#163;3M<\\/ns:PriceName>\\r\\n\\t<ns:ErrorCode>0<\\/ns:ErrorCode>\\r\\n\\t<ns:ErrorMsg\\/>\\r\\n\\t<ns:DataReference>June 2013<\\/ns:DataReference>\\r\\n\\t<ns:AccountList>\\r\\n\\t\\t<ns:Circuit>\\r\\n\\t\\t\\t<ns:Service>10Mb \\/ 100Mb<\\/ns:Service>\\r\\n\\t\\t\\t<ns:AnnualPrice>7232<\\/ns:AnnualPrice>\\r\\n\\t\\t\\t<ns:SetUp1yr>975<\\/ns:SetUp1yr>\\r\\n\\t\\t\\t<ns:SetUp3yr>0<\\/ns:SetUp3yr>\\r\\n\\t\\t\\t<ns:SortLevel>1<\\/ns:SortLevel>\\r\\n\\t\\t<\\/ns:Circuit>\\r\\n\\t<\\/ns:AccountList>\\r\\n<\\/ns:SearchResponseDetail>';
    	String response = '{"talktalk":[{"siteRef":"' + siteRef + '","xml":"","error":""}]}';
    	String status = QuoteHandler.parseQuote(response);
    	System.assertEquals('Data loaded successfully', status);
    	List<Talk_Talk_Product__c> products = Database.query('SELECT Id FROM Talk_Talk_Product__c WHERE Site_Ref__c = :siteRef');
    	System.assert(products.size() == 1);
    }*/
}