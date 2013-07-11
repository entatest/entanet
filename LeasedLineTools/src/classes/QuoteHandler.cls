global class QuoteHandler
{
    webservice String response;
    static private JSONParser parser;
    static private List<QuoteResponseParser> products;
    static private Boolean ready = false;
    
    static webservice String parseQuote(String response)
    {
        String status = 'Data loaded successfully on carloguli sandbox';
        products = new List<QuoteResponseParser>();
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
                            QuoteResponseParser product = factory.getProductParser(provider);
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
        for (QuoteResponseParser qProd: products) {
        	qProd.parsePayload();
        }
    }
    
    static public Boolean isReady()
    {
    	return ready;
    }
    
    public class TalktalkResponseParser extends QuoteResponseParser
    {
		public String collectorExchangeName;
		public String distance;
		public String ethernetExchangeName;
		public String fibreExchangeName;
		public String zone;
		public List<TalktalkQuoteParser> quotes;
		
		public TalktalkResponseParser(String siteRef, String xml, String error)
        {
        	super(siteRef, xml, error);
        }
        
        override public void parsePayload()
    	{
    		quotes = new List<TalktalkQuoteParser>();
    		XMLDom dom = new XMLDom(xml);
    		XMLDom.Element searchResponseDetail = dom.getElementByTagName('ns:SearchResponseDetail');
    		if (searchResponseDetail != null) {
    			collectorExchangeName = searchResponseDetail.getValue('ns:CollectorExchangeName');
    			distance = searchResponseDetail.getValue('ns:Distance');
    			ethernetExchangeName = searchResponseDetail.getValue('ns:EthernetExchangeName');
    			fibreExchangeName = searchResponseDetail.getValue('ns:FibreExchangeName');
    			zone = searchResponseDetail.getValue('ns:Zone');
    		}
    		List<XMLDom.Element> circuits = dom.getElementsByTagName('ns:Circuit');
    		if (circuits != null) {
	    		for (XMLDom.Element circuit: circuits) {
	    			TalktalkQuoteParser quoteParser = new TalktalkQuoteParser(circuit);
	    			quoteParser.parsePayload();
	    			quotes.add(quoteParser);
	    		}
    		}
    		createObjects();
        }
    	
    	private void createObjects()
    	{
    		for (TalktalkQuoteParser quoteParser: quotes) {
    			Talk_talk_Product__c product = new Talk_talk_Product__c(
    				Leased_Line_Quote_Request__c = siteRef,
    				Unique__c = siteRef + ' - ' + quoteParser.service,
    				Collector_Exchange_Name__c = collectorExchangeName,
    				Connection_Price_1_Year__c = Decimal.valueOf(quoteParser.setUp1yr),
    				Connection_Price_3_Year__c = Decimal.valueOf(quoteParser.setUp3yr),
    				Distance__c = Decimal.valueOf(distance),
    				Ethernet_Exchange_Name__c = ethernetExchangeName,
    				Fibre_Exchange_Name__c = fibreExchangeName,
    				Product__c = quoteParser.service,
    				Rental_Price__c = Decimal.valueOf(quoteParser.annualPrice),
    				Zone__c = zone
    			);
    			System.debug(product);
    			upsert product Unique__c;
    		}
    	}
    }
        
    public class TalktalkQuoteParser
    {
    	public String service;
    	public String annualPrice;
    	public String setUp1yr;
    	public String setUp3yr;
    	
    	private XMLDom.Element element;
    	
    	public TalktalkQuoteParser(XMLDom.Element element)
    	{
    		this.element = element;
    	}
    	
    	public void parsePayload()
    	{
    		if (element != null) {
    			service  = element.getValue('ns:Service');
    			annualPrice  = element.getValue('ns:AnnualPrice');
    			setUp1yr  = element.getValue('ns:SetUp1yr');
    			setUp3yr  = element.getValue('ns:SetUp3yr');
    		}
    	}
    }
    
    public class VirginResponseParser extends QuoteResponseParser
    {
    	private String BPTQuote;
    	private String flavour;
    	private String connectionPrice;
    	private String rentalPrice;
    	private String totalPrice;    	
    	
    	public VirginResponseParser(String siteRef, String xml, String error)
        {
        	super(siteRef, xml, error);
        }
    	
    	override public void parsePayload()
    	{
    		XMLDom dom = new XMLDom(xml);
            XMLDom.Element quotePricing = dom.getElementByTagName('QuotePricing');
            if (quotePricing != null) {
            	BPTQuote = quotePricing.getAttribute('BPTQuoteRefNo');
            }
            List<XMLDom.Element> sites = dom.getElementsByTagName('Site');
            if (sites != null && sites.size() > 1) {
            	flavour = sites[1].getAttribute('AccessFlavour');
            }
            XMLDom.Element totalPricing = dom.getElementByTagName('TotalPricing');
            if (totalPricing != null) {
                connectionPrice = totalPricing.getValue('InstallRevenue');
                rentalPrice = totalPricing.getValue('TariffSummary');
                totalPrice = totalPricing.getValue('TariffSummary');
            }
            createObject();
    	}
    	
    	private void createObject()
    	{
    		Leased_Line_Quote_Request__c llQuote = Database.query('SELECT OwnerId, Opportunity_ID__c FROM Leased_Line_Quote_Request__c WHERE ID = :siteRef');
    		String opportunityId = llQuote.Opportunity_ID__c;
    		String ownerId = llQuote.OwnerId;
    		Virgin_Media_Product__c product = new Virgin_Media_Product__c(
    			OwnerId = ownerId,
				BPT_Quote__c = BPTQuote,
				Bandwidth__c = '',
				Bearer__c = '',
				Connection_Price__c = Decimal.valueOf(connectionPrice),
				Flavour__c = flavour,
				Opportunity_ID__c = opportunityId,
				Product_term__c = '',
				Rental_Price__c = Decimal.valueOf(rentalPrice),
				Site_Ref__c = siteRef,
				Total_Pricing_Summary__c = Decimal.valueOf(totalPrice)
			);
			System.debug(product);
			Database.upsert(product);
    	}
    } 
    
    // Inner class used for serialization by readValuesAs()
    abstract public class QuoteResponseParser
    {
        public String siteRef;
        public String xml;
        public String error;
        
        public QuoteResponseParser(String siteRef, String xml, String error)
        {
            this.siteRef = siteRef;
            this.xml = xml;
            this.error = error;
        }
        
        abstract public void parsePayload();
    }
    
    public class ProductParserFactory
    {
    	public QuoteResponseParser getProductParser(String parserType)
    	{
    		if (parserType == 'virgin') {
    			return (VirginResponseParser)parser.readValueAs(VirginResponseParser.class);
    		}
    		return (TalktalkResponseParser)parser.readValueAs(TalktalkResponseParser.class);
    	}
    }
}