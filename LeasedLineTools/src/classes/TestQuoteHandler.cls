@isTest
private class TestQuoteHandler
{
    @isTest static void unknownProviderTest()
    {
    	String response = '{"invalid":[{"siteRef":"xxxx","xml":"<xxx></xxx>","error":""}]}';
    	String status = QuoteHandler.parseQuote(response);
    }
    
    @isTest static void invalidSiteRefTest()
    {
    	String siteRef = 'xxxxx';
    	String provider = '';
    	String ready = '';
    	QuoteHandler.setReadyStatus(siteRef, provider, ready);
    	
    }
}