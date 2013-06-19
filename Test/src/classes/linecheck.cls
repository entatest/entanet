public class linecheck{
    public String postcode { get; set; }
    private final Opportunity oppt;
    
    public linecheck(ApexPages.StandardController controller){
    	this.oppt = (Opportunity)controller.getRecord();
    }
}