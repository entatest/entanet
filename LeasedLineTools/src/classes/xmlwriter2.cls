public class xmlwriter2{
    public xmlwriter2() {
          XmlStreamWriter w = new XmlStreamWriter();
          w.writeStartDocument(null, '1.0');
          w.writeProcessingInstruction('target', 'data');
          w.writeStartElement('', 'LeasedLineQuoteRequest', '');
          w.writeStartElement('', 'RequestorsId', '');        
          w.writeCharacters('1234567');
          w.writeEndElement(); //end leasedlinequoterequest
		  w.writeEndElement(); //end requestorsid        
          w.writeEndDocument();
          String xmlOutput = w.getXmlString();
          w.close();
          system.debug(xmlOutput);
    }
}