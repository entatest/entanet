public class linecheck{
    public String postcode { get; set; }
    public Opportunity opportunity;
    
    public linecheck(ApexPages.StandardController controller){
    	this.opportunity = (Opportunity)controller.getRecord();
    }
    
    public pageReference Quotes(){
        return Page.linecheckerresults;
    }
}