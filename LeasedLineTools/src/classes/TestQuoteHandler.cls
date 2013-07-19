@isTest
private class TestQuoteHandler{
	@isTest static void myTest() {
        String json = '{"responses":[{"opportunityId":"xxxxxxxxxxxxx","siteRef":"xxxxxxxx","xml":"<xxx></xxx>","error":""},{"opportunityId":"xxxxxxxxxxxxx","siteRef":"xxxxxxxx","xml":"<xxx></xxx>","error":""},{"opportunityId":"xxxxxxxxxxxxx","siteRef":"xxxxxxxx","xml":"<xxx></xxx>","error":""}]}';
        String response = QuoteHandler.parseQuote(json);
        System.debug(response);
    }
}