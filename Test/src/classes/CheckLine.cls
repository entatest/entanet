public class CheckLine{

    public String telephone{get; set;}
    public String displayNumber{get; set;}
    private final BroadBandAvailabilityChecker checker{get;set;}
    
    public CheckLine(){
 		telephone = 'abcd';
       checker = new BroadBandAvailabilityChecker();
    }
    
    public String getChecker() {
        return null;
    }
    public PageReference runCheck() {
        displayNumber = telephone;
        return null;
    }
}