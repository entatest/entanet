public class xmlwriter {
    public xmlwriter() {
          XmlStreamWriter w = new XmlStreamWriter();
          w.writeStartDocument(null, '1.0');
          w.writeStartElement('', 'LeasedLineQuoteRequest', '');
          w.writeStartElement('', 'RequestersId', '');        
          w.writeCharacters('5474333678');
          w.writeEndElement(); //end requestorsid
          w.writeStartElement('', 'LeasedLineQuoteSites', ''); 
          w.writeStartElement('', 'LeasedLineQuoteSite', '');
		  w.writeStartElement('', 'SiteReference', '');
          w.writeCharacters('Sitexytgret');
		  w.writeEndElement(); //end SiteReferemce
		  w.writeStartElement('', 'AEndPostCode', '');
          w.writeCharacters('TF3 3AT');
		  w.writeEndElement(); //end AEndPostCode
		  w.writeStartElement('', 'AEndToid', '');
          w.writeCharacters('osgb864596854968');
		  w.writeEndElement(); //end AEndToid
		  w.writeStartElement('', 'BEndPostCode', '');
          w.writeCharacters('TF3 2AF');
		  w.writeEndElement(); //end BEndPostCode
		  w.writeStartElement('', 'BEndToid', '');
          w.writeCharacters('osgb864596854968');
		  w.writeEndElement(); //end BEndToid
		  w.writeStartElement('', 'LeasedLineQuoteSuppliers', '');
		  w.writeStartElement('', 'LeasedLineQuoteSupplier', '');
          w.writeStartElement('', 'Name', '');
          w.writeCharacters('TalkTalk');
		  w.writeEndElement(); //end name 
          /**
          w.writeStartElement('', 'LeasedLineQuoteSupplierOptions', '');
          w.writeStartElement('', 'LeasedLineQuoteSupplierOption', '');
          w.writeStartElement('', 'Name', '');
          w.writeCharacters('Ethernet Speed');
		  w.writeEndElement(); //end name 
          w.writeStartElement('', 'Value', '');
          w.writeCharacters('10/100');
		  w.writeEndElement(); //end value         
          w.writeEndElement(); //end leasedlinequotesupplieroption
          w.writeStartElement('', 'LeasedLineQuoteSupplierOption', '');
          w.writeStartElement('', 'Name', '');
          w.writeCharacters('Ethernet Speed');
		  w.writeEndElement(); //end name 
          w.writeStartElement('', 'Value', '');
          w.writeCharacters('20/100');
		  w.writeEndElement(); //end value         
          w.writeEndElement(); //end leasedlinequotesupplieroption        
          w.writeEndElement(); //end leasedlinequotesupplieroptions
		  **/
          w.writeEndElement(); //end leasedlinequotesupplier
        
		  w.writeStartElement('', 'LeasedLineQuoteSupplier', '');
          w.writeStartElement('', 'Name', '');
          w.writeCharacters('Virgin');
		  w.writeEndElement(); //end name 
          w.writeStartElement('', 'LeasedLineQuoteSupplierOptions', '');
          w.writeStartElement('', 'LeasedLineQuoteSupplierOption', '');
          w.writeStartElement('', 'Name', '');
          w.writeCharacters('Ethernet Speed');
          w.writeEndElement(); //end Name
          w.writeStartElement('', 'Value', '');
          w.writeCharacters('2/10');
          w.writeEndElement(); //end Value        
          w.writeEndElement(); //end LeasedLineSupplierOption
          w.writeEndElement(); //end LeasedLineSupplierOptions
          w.writeEndElement(); //end leasedlinequotesupplier        
        
          w.writeEndElement(); //end leasedlinequotesuppliers
          w.writeStartElement('', 'LeasedLineContractTerms', '');
          w.writeStartElement('', 'LeasedLineContractTerm', '');
          w.writeCharacters('1 Year');
		  w.writeEndElement(); //end leasedlinecontractterm  
          w.writeStartElement('', 'LeasedLineContractTerm', '');
          w.writeCharacters('3 Years');
		  w.writeEndElement(); //end leasedlinecontractterm   
          w.writeEndElement(); //end leasedlinecontractterms
          w.writeEndElement(); //end leasedlinequotesite
          w.writeEndElement(); //end leasedlinequotesites        
          w.writeEndElement(); //end leasedlinequoterequest
          w.writeEndDocument();
          String xmlOutput = w.getXmlString();
          w.close();
        
    HttpRequest req = new HttpRequest();
    req.setEndpoint('http://sfgw.enta.net/rest/quotes');
    req.setMethod('POST');
    req.setBody(xmlOutput); 
    //send the request
    Http http = new Http();
    HttpResponse res = http.send(req);
    Integer statuscode = res.getStatusCode();
    String xml = res.getBody();  
        
    system.debug(statuscode);
    system.debug(xmlOutput);
    system.debug(xml);

    }
}