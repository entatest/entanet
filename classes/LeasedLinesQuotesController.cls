public with sharing class LeasedLinesQuotesController {
	public Opportunity oppt;
	public String postcode {get; set;}
	public Boolean exactaddress {get; set;}
	
	public LeasedLinesQuotesController(ApexPages.StandardController controller)
	{
        this.oppt = (Opportunity)controller.getRecord();
    }
    
    public PageReference Quotes()
	{
		LeasedLinesQuotes.ServicePort1 service = new LeasedLinesQuotes.ServicePort1();
		service.GetAllQuotes(postcode);
		return Page.testQuoteDisplay;
	}
}