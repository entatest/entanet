public class lineChecker{
    
    private final Opportunity oppt;
    
    public String postcode { get; set; }
    
    public lineChecker(ApexPages.StandardController controller) {
        this.oppt = (Opportunity)controller.getRecord();
    }
    
    public PageReference requestQuotes() {
        return Page.lineCheckerResults;
    }
    
    
    

}