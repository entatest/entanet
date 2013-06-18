@isTest
public class TestXmlParserLineChecker{
	
   public static void parseXml(){
     	XmlParserLineChecker xmlParser = new XmlParserLineChecker();
        String xmlString = getTestXml();
        xmlParser.parseXml(xmlString);
    }
    
    @isTest static void testReasonCode(){
     	   
    }
    
   private static String getTestXml(){
     	String testXml =  '<?xml version="1.0" encoding="UTF-8" ?>' +
                                '<ADSL_CHECKER>'+
                                '<ERRORID>0</ERRORID>'+
                                '<INPUT>01689890270</INPUT>'+
                                '<INPUTTYPE>TELNO</INPUTTYPE>'+
                                '<FIXEDRATE>'+
                                '<RAG>A</RAG>'+
                                '<REASONCODE>A</REASONCODE>'+
                                '<READYDATE></READYDATE>'+
                                '<EXCHSTATE>E</EXCHSTATE>'+
                                '<CAPACITY></CAPACITY>'+
                                '</FIXEDRATE>'+
                                '<RATEADAPTIVE>'+
                                '<RAG>G</RAG>'+
                                '<REASONCODE>A</REASONCODE>'+
                                '<READYDATE></READYDATE>'+
                                '<EXCHSTATE>E</EXCHSTATE>'+
                                '<CAPACITY></CAPACITY>'+
                                '</RATEADAPTIVE>'+
                                '<BET>'+
                                '<RAG></RAG>'+
                                '<REASONCODE></REASONCODE>'+
                                '<SPEED></SPEED>'+
                                '<READYDATE></READYDATE>'+
                                '<EXCHSTATE></EXCHSTATE>'+
                                '<CAPACITY></CAPACITY>'+
                                '<BETCHARGINGSTATUS></BETCHARGINGSTATUS>'+
                                '</BET>'+
                                '<MAX>'+
                                '<RAG>G</RAG>'+
                                '<REASONCODE>A</REASONCODE>'+
                                '<SPEED>2500</SPEED>'+
                                '<MINRANGE>1500</MINRANGE>'+
                                '<MAXRANGE>5000</MAXRANGE>'+
                                '<MINTHRESHOLD>1500</MINTHRESHOLD>'+
                                '<READYDATE></READYDATE>'+
                                '<EXCHSTATE>E</EXCHSTATE>'+
                                '<CAPACITY></CAPACITY>'+
                                '</MAX>'+
                                '<WBC>'+
                                 '<RAG>G</RAG>'+
                                '<REASONCODE>A</REASONCODE>'+
                                '<SPEED>3500</SPEED>'+
                                
                                  '<MINRANGE>2000</MINRANGE>'+
                                  '<MAXRANGE>6000</MAXRANGE>'+
                                '<MINTHRESHOLD>1000</MINTHRESHOLD>'+
                                
                                  '<READYDATE></READYDATE>'+
                                  '<EXCHSTATE>E</EXCHSTATE>'+
                                '<CAPACITY></CAPACITY>'+
                                
                                   '<ANNEXMRAG></ANNEXMRAG>'+
                                   '<ANNEXMDOWNSPEED></ANNEXMDOWNSPEED>'+
                                   '<ANNEXMUPSPEED></ANNEXMUPSPEED>'+
                                
                                         '<ANNEXMMINSPEED></ANNEXMMINSPEED>'+
                                         '<ANNEXMMAXSPEED></ANNEXMMAXSPEED>'+
                                
                                 '</WBC>'+
                                '<WBCFTTC>'+
                                      '<RAG>G</RAG>'+
                                '<REASONCODE>A</REASONCODE>'+
                                '<DOWNSPEED>68100</DOWNSPEED>'+
                                      '<UPSPEED>20000</UPSPEED>'+
                                      '<MINRANGE></MINRANGE>'+
                                      '<MAXRANGE></MAXRANGE>'+
                                      '<READYDATE></READYDATE>'+
                                      '<EXCHSTATE>E</EXCHSTATE>'+
                                '<CAPACITY></CAPACITY>'+
                                '</WBCFTTC>'+
                                '<WBCFTTP>'+
                                '<RAG></RAG>'+
                                '<REASONCODE></REASONCODE>'+
                                '<DOWNSPEED></DOWNSPEED>'+
                                         '<UPSPEED></UPSPEED>'+
                                         '<MINRANGE></MINRANGE>'+
                                         '<MAXRANGE></MAXRANGE>'+
                                         '<READYDATE></READYDATE>'+
                                '<EXCHSTATE>N</EXCHSTATE>'+
                                '<CAPACITY></CAPACITY>'+
                                '<MDUSTATUS></MDUSTATUS>'+
                                '<MDUREADYFORSERVICEDATE></MDUREADYFORSERVICEDATE>'+
                                '<MDUPROGRESSUPDATE></MDUPROGRESSUPDATE>'+
                                '<MDUNOTES></MDUNOTES>'+
                                '<FVAAVAILABLE></FVAAVAILABLE>'+
                                '<L2SID></L2SID>'+
                                '<ONTLIST></ONTLIST>'+
                                
                                      '<PREMISETYPE></PREMISETYPE>'+
                                      '<SERVICENOTES></SERVICENOTES>'+
                                '<TMAMARKER></TMAMARKER>'+
                                '</WBCFTTP>'+
                                '<COPPERMULTICAST>'+
                                                '<READYDATE></READYDATE>'+
                                                '<EXCHSTATE>N</EXCHSTATE>'+
                                '</COPPERMULTICAST>'+
                                '<FIBREMULTICAST>'+
                                                '<READYDATE></READYDATE>'+
                                                '<EXCHSTATE>E</EXCHSTATE>'+
                                '</FIBREMULTICAST>'+
                                '<EXCHANGECODE>LSORP</EXCHANGECODE>'+
                                '<EXCHANGENAME>ORPINGTON</EXCHANGENAME>'+
                                '<VPCONTENTION>N</VPCONTENTION>'+
                                '<SPNAME>ENTANET INTERNATIONAL LTD</SPNAME>'+
                                '<CAD></CAD>'+
                                '<CPNAME>BT WHOLESALE</CPNAME>'+
                                '<CPCONTACTNO>08000857023</CPCONTACTNO>'+
                                '<POSTCODE>BR6 9LB</POSTCODE>'+
                                '<INDICATIVELINEQUALITY></INDICATIVELINEQUALITY>'+
                                '<ILQCALCULATIONDATE></ILQCALCULATIONDATE>'+
                                '<MTBEDOWNSTREAM></MTBEDOWNSTREAM>'+
                                '<MTBEUPSTREAM></MTBEUPSTREAM>'+
                                '<MTBR></MTBR>'+
                                '<INTERLEAVING></INTERLEAVING>'+
                                '<H24RETRAINS></H24RETRAINS>'+
                                '<SUGGESTEDMSG>For all ADSL and WBC Fibre to the Cabinet (FTTC) services, the stable line rate will be determined during the first 10 days of service usage. Throughput/download speeds will be less than line rates and can be affected by a number of factors within and external to BTs network, Communication Providers networks and within customer premises.'+
                                'The Stop Sale date for Datastream is from 30-Jun-2012; the Formal Retirement date for Datastream is from 30-Nov-2013. The Stop Sale date for IPstream is from 30-Nov-2012; the Formal Retirement date for IPstream is from 30-Nov-2013.'+
                                'If the End User wishes to migrate from their current Broadband supplier they will need to contact them in the first instance to obtain a MAC (Migrations Authorisation) Code, and then contact their new Broadband supplier to arrange for the service to be migrated.</SUGGESTEDMSG>'+
                                '<SUPPLEMENTARYMSG>Note: If you decide to place an order for a WBC fibre product, an appointment may be required for an engineer to visit the end users premises to supply the service.'+
                                'Please note that postcode and address check results are indicative only. Most accurate results can be obtained from a telephone number check.'+
                                'Thank you for your interest.</SUPPLEMENTARYMSG>'+
                                '</ADSL_CHECKER>';
        return testXml;
    }
}