global class QuoteHandler
{
    webservice String response;
    static private JSONParser parser;
    
    static webservice String parseQuote(String response)
    {
        String status = 'Data loaded successfully';
        try {
            parser = JSON.createParser(response);
            while (parser.nextToken() != null) {
                if (parser.getCurrentToken() == JSONToken.START_ARRAY) {
                    while (parser.nextToken() != null) {
                        // Advance to the start object marker
                        if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                            // Read object
                            VirginProduct product = (VirginProduct)parser.readValueAs(VirginProduct.class);
                            // For debugging purposes, serialize again to verify what was parsed.
                            String s = JSON.serialize(product);
                            System.debug('Serialized product: ' + s);
        
                            // Skip the child start array and start object markers
                            parser.skipChildren();
                        }
                    }
                }
            }
            loadProductObjects();
        } catch (System.NullPointerException e) {
            status = e.getMessage();
        }
        return status;
    }
    
    static private void loadProductObjects()
    {
        
    }
    
    // Inner class used for serialization by readValuesAs()
    public class VirginProduct
    {
        public String opportunityId;
        public String siteRef;
        public String xml;
        public String error;
        
        public VirginProduct(String opportunityId, String siteRef, String xml, String error)
        {
            this.opportunityId = opportunityId;
            this.siteRef = siteRef;
            this.xml = xml;
            this.error = error;
        }
    
        private Map<String,String> filterFieldsMap()
        {
            Map<String,String> required = new Map<String,String>();
            required.put('', 'Bearer__c');
            required.put('', 'Bandwidth__c');
            required.put('term', 'Product_Term__c');
            required.put('term', 'Connection_Price__c');
            return required;
        }
    }
}