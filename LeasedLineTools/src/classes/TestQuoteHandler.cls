@isTest
private class TestQuoteHandler
{
    @isTest static void unknownProviderTest()
    {
    	String response = '{"invalid":[{"siteRef":"xxxx","xml":"<xxx></xxx>","error":""}]}';
    	String status = QuoteHandler.parseQuote(response);
    	System.assertEquals(status, 'Unknown provider');
    }
    
    @isTest static void invalidSiteRefTest()
    {
    	String response = '{"talktalk":[{"siteRef":"xxxx","xml":"<xxx></xxx>","error":""}]}';
    	String status = QuoteHandler.parseQuote(response);
    	System.assertEquals(status, 'Unknown provider');
    	/*Boolean result = QuoteHandler.setReadyStatus('xxxxx', '', '');
    	System.assert(!result);*/
    }
    
    /*@isTest static void validSiteRefTest()
    {
    	Leased_Line_Quote_Request__c llqr = new Leased_Line_Quote_Request__c(
    		Contract_Term__c = '3 years',
    		Point_2_Point__c = false,
    		Postcode__c = 'TF3 3AT',
    		Site_Reference__c = 'reference'
    	);
    	insert llqr;
    	String id = llqr.Id;
    	Boolean result = QuoteHandler.setReadyStatus(id, '', '');    	
    	System.assert(result);
    }*/
}