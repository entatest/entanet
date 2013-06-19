public class XmlParserLineChecker{
	
    public String reasonCode{get;set;}
    public String BTPostCode{get;set;}
    public String message{get;set;}
    
    public void parseXml(String xmlString){
     	    XmlStreamReader xsr = new XmlStreamReader(xmlString);
        while(xsr.hasNext()) {
         	if ('ReasonCode' == xsr.getLocalName()) {  
         		reasonCode = xsr.getText();
            }
        }
        system.debug(reasonCode);
    }
}