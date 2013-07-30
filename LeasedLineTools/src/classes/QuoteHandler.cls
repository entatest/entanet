global class QuoteHandler
{
    static public final String INVALID_XML = 'Invalid XML';
    static public final String INCOMPLETE_DATA = 'Incomplete Data';
    static public final String INVALID_PROVIDER = 'Unknown provider';
    static public final String INVALID_SITE_REF = 'Invalid Site Reference';
    
    static private JSONParser jsonParser;
    
    static webservice String parseQuote(String response)
    {
    	ProductParserFactory factory = new ProductParserFactory();
    	ProductParserCollection parserCollection;
        String status = 'Data not loaded';
        String ready = 'pending';
        String provider = 'unknown';
        String siteRef = '';
        try {
            jsonParser = JSON.createParser(response);
            while (jsonParser.nextToken() != null) {
                // Find out about the provider
                if (jsonParser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    provider = jsonParser.getText();
                    system.debug(provider);
                }
                if (jsonParser.getCurrentToken() == JSONToken.START_ARRAY) {
                    while (jsonParser.nextToken() != null) {
                        // Advance to the start object marker
                        if (jsonParser.getCurrentToken() == JSONToken.START_OBJECT) {
                            // Read object
                    		parserCollection = factory.getParserCollection(provider);
                            parserCollection.add();
                            /* For debugging purposes, serialize again to verify what was parsed.
                            String s = JSON.serialize(product);
                            system.debug('Serialized product: ' + s);*/
        
                            // Skip the child start array and start object markers
                            jsonParser.skipChildren();
                        }
                    }
                }
            }
            if (parserCollection != null) {
            	parserCollection.loadProductObjects();
            	siteRef = parserCollection.getSiteRef();
            }
        	status = 'Data loaded successfully';
            ready = 'success';
        	setReadyStatus(siteRef, provider, ready, '');
        } catch (Exception e) {
            if (parserCollection != null) {
            	siteRef = parserCollection.getSiteRef();
            }
            status = e.getMessage();
    		if (e instanceof XmlException) {
    			status = INVALID_XML;
    		}
            ready = 'failure';
        	setReadyStatus(siteRef, provider, ready, status);
        }
        return status;
    }
    
    static private void setReadyStatus(String siteRef, String provider, String ready, String message)
    {
    	try {
	    	Product_Loaded_Status__c status = new Product_Loaded_Status__c(
				Leased_Line_Quote_Request__c = siteRef,
				Provider__c = provider,
				Status__c = ready,
				Error_Message__c = message
			);
			insert status;
    	} catch (Exception e) {
    		// Log exception
    	}
    }
    
    public class Product2Handler
    {
    	private list<Product2> products;
    	
    	public Product2Handler(String provider)
    	{
    		products = [SELECT Bearer__c, Bandwidth__c, Term__c, Family FROM Product2 WHERE lineProvider__c = :provider AND IsDeleted = false];
    	}
    	
    	public String getProduct2Id(String bearer, String bandwidth, String term, String family)
    	{
    		String[] termParts = term.splitByCharacterType();
    		bearer = bearer.deleteWhitespace();
    		bandwidth = bandwidth.deleteWhitespace();
    		family = family.deleteWhitespace();
    		for (Product2 prod: products) {
    			Boolean condition = bearer.equalsIgnoreCase(prod.Bearer__c.deleteWhitespace());
    			condition = condition && bandwidth.equalsIgnoreCase(prod.Bandwidth__c.deleteWhitespace());
    			condition = condition && family.equalsIgnoreCase(prod.Family.deleteWhitespace());
    			if (condition && prod.Term__c == termParts[0]) {
    				return prod.Id;
    			}
    		}
    		return '';
    	} 
    }
    
    public class TalktalkResponseParser extends QuoteResponseParser
    {
		private String collectorExchangeName;
		private String distance;
		private String ethernetExchangeName;
		private String fibreExchangeName;
		private String zone;
		private list<TalktalkQuoteParser> quotes;
		
		override public void parsePayload()
    	{
    		if (isValid()) {
	    		quotes = new list<TalktalkQuoteParser>();
	    		XMLDom dom = new XMLDom(xml);
	    		system.debug(dom);
	    		XMLDom.Element searchResponseDetail = dom.getElementByTagName('ns:SearchResponseDetail');
	    		if (searchResponseDetail != null) {
	    			collectorExchangeName = searchResponseDetail.getValue('ns:CollectorExchangeName');
	    			distance = searchResponseDetail.getValue('ns:Distance');
	    			ethernetExchangeName = searchResponseDetail.getValue('ns:EthernetExchangeName');
	    			fibreExchangeName = searchResponseDetail.getValue('ns:FibreExchangeName');
	    			zone = searchResponseDetail.getValue('ns:Zone');
	    		}
	    		list<XMLDom.Element> circuits = dom.getElementsByTagName('ns:Circuit');
	    		if (circuits != null) {
		    		for (XMLDom.Element circuit: circuits) {
		    			TalktalkQuoteParser quoteParser = new TalktalkQuoteParser(circuit);
		    			quoteParser.parsePayload();
		    			quotes.add(quoteParser);
		    		}
	    		}
    			deleteErrorObject();
	    		createObjects();
    		}
        }
        
        override protected void checkError()
        {
    		deleteObjects();
        	createErrorObject();
        }
    	
    	private void createObjects()
    	{
    		Product2Handler handler = new Product2Handler('Talktalk');
    		list<Talk_talk_Product__c> products = new list<Talk_talk_Product__c>();
    		list<Schema.PicklistEntry> familyEntries = getPicklist('Talk_talk_Product__c', 'Product_Family__c');
    		list<Schema.PicklistEntry> termEntries = getPicklist('Talk_talk_Product__c', 'Product_Term__c');
    		for (TalktalkQuoteParser quoteParser: quotes) {
    			for (Schema.PicklistEntry familyEntry: familyEntries) {
    				String family = familyEntry.getValue();
	    			String[] parts =  quoteParser.getService().split('/');
	    			for (Schema.PicklistEntry termEntry: termEntries) {
		    			String term = termEntry.getValue();
		    			String productId = handler.getProduct2Id(parts[1].trim(), parts[0].trim(), term, family);
		    			if (productId.length() > 0) {
			    			Talk_talk_Product__c product = new Talk_talk_Product__c(
			    				Site_Ref__c = siteRef,
			    				Unique__c = emptyUnique + ' ' + quoteParser.getService() + ' - ' + family + ' - ' + term,
			    				Collector_Exchange_Name__c = collectorExchangeName,
			    				Product_Term__c = term,
			    				Distance__c = Decimal.valueOf(distance),
			    				Ethernet_Exchange_Name__c = ethernetExchangeName,
			    				Fibre_Exchange_Name__c = fibreExchangeName,
			    				Product__c = quoteParser.getService(),
			    				Product_Family__c = family,
			    				Price__c = Decimal.valueOf(quoteParser.getPrice(family, term)),
			    				Zone__c = zone,
			    				Product_Id__c = productId
			    			);
			    			products.add(product);
		    			}
	    			}
    			}
    		}
	    	upsert products Unique__c;
    	}
    	
    	private void deleteObjects()
    	{
    		String query = 'SELECT Id FROM Talk_talk_Product__c WHERE Site_Ref__c = :siteRef ALL ROWS';
    		runDeleteQuery(query);
    	}
    	
    	private void createErrorObject()
    	{
    		Talk_talk_Product__c product = new Talk_talk_Product__c(
				Site_Ref__c = siteRef,
				Unique__c = emptyUnique,
				Error_Message__c = error
			);
			upsert product Unique__c;
    	}
    	
    	private void deleteErrorObject()
    	{
    		String query = 'SELECT Id FROM Talk_talk_Product__c WHERE Unique__c = :emptyUnique';
    		runDeleteQuery(query);
    	}
        
        private void runDeleteQuery(String query)
        {
    		Talk_talk_Product__c[] deleteProducts = Database.query(query);
        	try {
    			delete deleteProducts;
    		} catch (DmlException e) {
    			// Log exception
    		}
        }
    }
        
    public class TalktalkQuoteParser
    {
    	private String service;
    	private String annualPrice;
    	private String SetUp1yr;
    	private String SetUp3yr;
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
    			SetUp1yr = element.getValue('ns:SetUp1yr');
    			SetUp3yr = element.getValue('ns:SetUp3yr');
    		}
    	}
    	
    	public String getService()
    	{
    		return service;
    	}
    	
    	public String getPrice(String family, String term)
    	{
    		if (family.containsIgnoreCase('installation')) {
    			String[] termParts = term.splitByCharacterType();
    			if (termParts[0] == '1') {
    				return SetUp1yr;
    			}
    			if (termParts[0] == '3') {
    				return SetUp3yr;
    			}
    		}
    		if (family.containsIgnoreCase('recurring')) {
    			return annualPrice;
    		}
    		return '0';
    	}
    }
    
    public class VirginResponseParser extends QuoteResponseParser
    {
    	private String BPTQuote;
    	private String flavour;
    	private String connectionPrice;
    	private String rentalPrice;
    	private String totalPrice;
    	private list<Virgin_Media_Product__c> products;
    	
    	override public void parsePayload()
    	{
    		if (isValid()) {
	    		XMLDom dom = new XMLDom(xml);
	            XMLDom.Element quotePricing = dom.getElementByTagName('QuotePricing');
	            if (quotePricing != null) {
	            	BPTQuote = quotePricing.getAttribute('BPTQuoteRefNo');
	            }
	            list<XMLDom.Element> sites = dom.getElementsByTagName('Site');
	            if (sites != null && sites.size() > 1) {
	            	flavour = sites[1].getAttribute('AccessFlavour');
	            }
	            XMLDom.Element totalPricing = dom.getElementByTagName('TotalPricing');
	            if (totalPricing != null) {
	                connectionPrice = totalPricing.getValue('InstallRevenue');
	                rentalPrice = totalPricing.getValue('RentalRevenue');
	                totalPrice = totalPricing.getValue('TariffSummary');
	            }
	            createObjects();
    		}
    	}
    	
    	override public void setCollection(list<SObject> collection)
    	{
    		products = collection;
    	}
        
        override protected Boolean checkResponse()
        {
        	Boolean condition = String.isBlank(bearer) || String.isBlank(bandwidth) || String.isBlank(term);
        	if (condition) {
        		throw new IncompleteDataException(INCOMPLETE_DATA);
        	}
        	condition = String.isBlank(xml);
        	if (condition && String.isBlank(error)) {
        		throw new IncompleteDataException(INCOMPLETE_DATA);
        	}
        	return !condition;
        }
        
        override protected void checkError()
        {
    		createErrorObjects();
        }
    	
    	private void createObjects()
    	{
    		Product2Handler handler = new Product2Handler('Virgin');
    		list<Schema.PicklistEntry> familyEntries = getPicklist('Virgin_Media_Product__c', 'Product_Family__c');
    		for (Schema.PicklistEntry familyEntry: familyEntries) {
				String family = familyEntry.getValue();
    			String productId = handler.getProduct2Id(bearer, bandwidth, term, family);
    			if (productId.length() > 0) {
		    		Virgin_Media_Product__c product = new Virgin_Media_Product__c(
		    			Site_Ref__c = siteRef,
						Unique__c = emptyUnique + ' ' + bandwidth + '/' + bearer + ' - ' + family + ' - ' + term,
		    			BPT_Quote__c = BPTQuote,
						Bandwidth__c = bandwidth,
						Bearer__c = bearer,
						Price__c = Decimal.valueOf(getPrice(family)),
						Flavour__c = flavour,
						Product_term__c = term,
						Product_Id__c = productId,
					    Product_Family__c = family,
						Total_Pricing_Summary__c = Decimal.valueOf(totalPrice),
						Error_Message__c = ''
					);
					products.add(product);
    			}
    		}
    	}
    	
    	private String getPrice(String family)
    	{
    		if (family.containsIgnoreCase('installation')) {
    			return connectionPrice;
    		}
    		if (family.containsIgnoreCase('recurring')) {
    			return rentalPrice;
    		}
    		return '0';
    	}
    	
    	private void createErrorObjects()
    	{
    		list<Schema.PicklistEntry> familyEntries = getPicklist('Virgin_Media_Product__c', 'Product_Family__c');
    		for (Schema.PicklistEntry familyEntry: familyEntries) {
				String family = familyEntry.getValue();
	    		Virgin_Media_Product__c product = new Virgin_Media_Product__c(
					Site_Ref__c = siteRef,
					Unique__c = emptyUnique + ' ' + bandwidth + '/' + bearer + ' - ' + family + ' - ' + term,
					Bandwidth__c = bandwidth,
					Bearer__c = bearer,
					Product_term__c = term,
					Error_Message__c = error
				);
				products.add(product);
    		}
    	}
    }
    
    public class VoidResponseParser extends QuoteResponseParser
    {
    	override public void parsePayload() {
    		throw new UnknownProviderException(INVALID_PROVIDER);
    	}
    }
    
    // Inner class used for serialization by readValuesAs()
    abstract public class QuoteResponseParser
    {
        public String siteRef;
        public String bearer;
        public String bandwidth;
        public String term;
        public String xml;
        public String error;
        public String emptyUnique;
        
        abstract public void parsePayload();
        
        virtual public void setCollection(list<SObject> collection) {}
        
        protected Boolean isValid()
        {
        	checkSiteRef();
        	Boolean valid = checkResponse();
        	if (!valid) {
        		checkError();
        	}
        	return valid;
        }
    
	    protected void checkSiteRef()
	    {
	    	try {
    			Leased_Line_Quote_Request__c llqr = Database.query('SELECT Id FROM Leased_Line_Quote_Request__c WHERE Id = :siteRef');
    			emptyUnique = siteRef + ' -';
    			return;
    		} catch (QueryException e) {
				throw new InvalidSiteReferenceException(INVALID_SITE_REF);
    		}
    		
	    }
        
        virtual protected Boolean checkResponse()
        {
        	Boolean condition = String.isBlank(xml);
        	if (condition && String.isBlank(error)) {
        		throw new IncompleteDataException(INCOMPLETE_DATA);
        	}
        	return !condition;
        }
        
        virtual protected void checkError() {}
        
	    protected list<Schema.PicklistEntry> getPicklist(String ObjectApi_name, String fieldName)
	    {
	    	Schema.SObjectType objType = Schema.getGlobalDescribe().get(ObjectApi_name);
	    	Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
	    	map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
	    	return fieldMap.get(fieldName).getDescribe().getPickListValues();
	    }
    }
    
    abstract public class ProductParserCollection
    {
    	protected List<QuoteResponseParser> parsers;
    	
    	public ProductParserCollection()
    	{
    		parsers = new List<QuoteResponseParser>();
    	}
    	
    	abstract public void add();
    	
    	public String getSiteRef()
    	{
    		return parsers[0].siteRef;
    	}
    
	    virtual public void loadProductObjects()
	    {
	        for (QuoteResponseParser parser: parsers) {
	        	parser.parsePayload();
	        }
	    }
    }
    
    public class TalktalkParserCollection extends ProductParserCollection
    {    	
    	override public void add()
    	{
    		parsers.add((TalktalkResponseParser)jsonParser.readValueAs(TalktalkResponseParser.class));
    	}
    }
    
    public class VirginParserCollection extends ProductParserCollection
    {
    	private list<Virgin_Media_Product__c> products;
    	
    	public VirginParserCollection()
    	{
    		super();
    		products = new list<Virgin_Media_Product__c>();
    	}
    	
    	override public void add()
    	{
    		VirginResponseParser parser = (VirginResponseParser)jsonParser.readValueAs(VirginResponseParser.class);
    		parser.setCollection(products);
    		parsers.add(parser);
    	}
    	
    	override public void loadProductObjects()
    	{
    		super.loadProductObjects();
    		upsert products Unique__c;
    	}
    }
    
    public class VoidParserCollection extends ProductParserCollection
    { 	
    	override public void add()
    	{
    		parsers.add((VoidResponseParser)jsonParser.readValueAs(VoidResponseParser.class));
    	}
    }
    
    public class ProductParserFactory
    {
		public ProductParserCollection getParserCollection(String parserType)
		{
			if (parserType == 'talktalk') {
				return new TalktalkParserCollection();
			}
    		if (parserType == 'virgin') {
    			return new VirginParserCollection();
    		}
    		return new VoidParserCollection();
		}
    }

	public class UnknownProviderException extends Exception {}
	
	public class InvalidSiteReferenceException extends Exception {}
	
	public class IncompleteDataException extends Exception {}
}