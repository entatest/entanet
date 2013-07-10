global class QuoteHandler
{
    webservice String response;
    static private JSONParser parser;
    static private List<QuoteProduct> products;
    
    static webservice String parseQuote(String response)
    {
        String status = 'Data loaded successfully on carloguli sandbox';
        products = new List<QuoteProduct>();
        String provider;
        ProductParserFactory factory = new ProductParserFactory();
        try {
            parser = JSON.createParser(response);
            while (parser.nextToken() != null) {
                // Find out about the provider
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    provider = parser.getText();
                    System.debug(provider);
                }
                if (parser.getCurrentToken() == JSONToken.START_ARRAY) {
                    while (parser.nextToken() != null) {
                        // Advance to the start object marker
                        if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                            // Read object
                            QuoteProduct product = factory.getProductParser(provider);
                            products.add(product);
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
        for (QuoteProduct qProd: products) {
            qProd.parsePayload();
            Map<String,String> fields = qProd.getFieldMap();
            System.debug(fields);
        }
    }
    
    public class TalktalkProduct extends QuoteProduct
    {
        public TalktalkProduct(String siteRef, String payload, String error)
        {
        	super(siteRef, payload, error);
        }
        
        override public void parsePayload()
    	{
        }
    }
    
    public class VirginProduct extends QuoteProduct
    {
    	public VirginProduct(String siteRef, String payload, String error)
        {
        	super(siteRef, payload, error);
        }
    	
    	override public void parsePayload()
    	{
            fieldMap = new Map<String,String>();
    		XMLDom dom = new XMLDom(payload);
            XMLDom.Element quotePricing = dom.getElementByTagName('QuotePricing');
            if (quotePricing != null) {
            	fieldMap.put('BPT_Quote__c', quotePricing.getAttribute('BPTQuoteRefNo'));
            }
            List<XMLDom.Element> sites = dom.getElementsByTagName('Site');
            if (sites != null && sites.size() > 1) {
            	fieldMap.put('Flavour__c', sites[1].getAttribute('AccessFlavour'));
            }
            XMLDom.Element totalPricing = dom.getElementByTagName('TotalPricing');
            if (totalPricing != null) {
                fieldMap.put('Connection_Price__c', totalPricing.getValue('InstallRevenue'));
                fieldMap.put('Rental_Price__c', totalPricing.getValue('RentalRevenue'));
                fieldMap.put('Total_Pricing_Summary__c', totalPricing.getValue('TariffSummary'));
            }
            Set<String> keys = fieldMap.keySet();
            for (String key: keys) {
                
            }
    	}
    } 
    
    // Inner class used for serialization by readValuesAs()
    abstract public class QuoteProduct
    {
        public String siteRef;
        public String payload;
        public String error;
        protected Map<String,String> fieldMap;
        
        public QuoteProduct(String siteRef, String payload, String error)
        {
            this.siteRef = siteRef;
            this.payload = payload;
            this.error = error;
        }
        
        public Map<String,String> getFieldMap()
        {
            return fieldMap;
        }
        
        abstract public void parsePayload();
    }
    
    public class ProductParserFactory
    {
    	public QuoteProduct getProductParser(String parserType)
    	{
    		if (parserType == 'virgin') {
    			return (VirginProduct)parser.readValueAs(VirginProduct.class);
    		}
    		return (TalktalkProduct)parser.readValueAs(TalktalkProduct.class);
    	}
    }
}