public class BroadBandAvailabilityChecker{

    public String topTech {get; set;}
    public String reasonCode{get;set;}
    public String BTPostCode{get;set;}
    public String message{get;set;}
    
    public void runChecker(String phoneNumber, String macCode){
     	AdslLineChecker  lineChecker = new AdslLineChecker();
   
        String xmlString = lineChecker.getXml(phoneNumber, macCode);
        XmlParserLineChecker lineCheckerResults = new XmlParserLineChecker();
        lineCheckerResults.parseXml(xmlString);
    }      

}