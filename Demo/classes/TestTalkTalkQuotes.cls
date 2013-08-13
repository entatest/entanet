@isTest
private class TestTalkTalkQuotes{
    @isTest static void myTest() {
        Opportunity opp = new Opportunity();
        opp.name = 'test';
        opp.stagename = 'Prospecting';
        Date oppDate = System.Today();
        opp.closedate = oppDate;
        insert opp;
        system.debug(opp.id);
        
        ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        TalkTalkQuotes ttq = new TalkTalkQuotes(sc);
        
        List<TalkTalkQuotes.LLProducts> products = ttq.getProducts();
        
        ttq.quotes();
        ttq.addquote();
        ttq.getselectedproducts();
    }
}