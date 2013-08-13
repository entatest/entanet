public class LineCheckerResults{
    
    public Boolean ten { get; set; }
    public Boolean twenty { get; set; }
    public Boolean thirty { get; set; }
    public Boolean forty { get; set; }
    public Boolean fifty { get; set; }
    public Boolean hundred { get; set; }
    
    private final Opportunity oppt;

    protected String postcode { get; set; }
    
    public LineCheckerResults(ApexPages.StandardController controller){
    	this.oppt = (Opportunity)controller.getRecord();
    }
    
    public void getTalkTalkQuote(){

    }
    
    public PageReference retrieveQuotes() {
        String oppId = oppt.id;
        Quote quo = new Quote(name = 'test6', opportunityid = oppId, pricebook2id = '01sb0000000Im2zAAC');
        insert quo;
        quo.status = 'In Review';
        update quo;
        QuoteLineItem qli = new QuoteLineItem(QuoteId = quo.id, PriceBookEntryId = '01uJ0000002vDPhIAM', UnitPrice = 50.11, Quantity = 4);
        insert qli;
        return null;
    }
    
    
}