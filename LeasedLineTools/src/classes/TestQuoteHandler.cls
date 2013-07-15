@isTest
private class TestQuoteHandler
{
    @isTest static void unknownProviderTest()
    {
    	String response = '{"invalid":[{"siteRef":"xxxx","xml":"<xxx></xxx>","error":""}]}';
    	String status = QuoteHandler.parseQuote(response);
    	System.assertEquals('Unknown provider', status);
    }
    
    @isTest static void invalidSiteRefTest()
    {
    	String response = '{"talktalk":[{"siteRef":"xxxx","xml":"<xxx></xxx>","error":""}]}';
    	String status = QuoteHandler.parseQuote(response);
    	System.assertEquals('Invalid Site Reference', status);
    }
}