public class LeasedLineResults{


    public List<LLProducts> talktalkproducts; 
    public List<LLProducts> selectedproducts;    
    Leased_Line_Quote_Request__c llqr;
    //Opportunity oppt;
    
    public LeasedLineResults(ApexPages.StandardController controller) {
        String oppid = ApexPages.currentPage().getParameters().get('opportunityid');
        String siteref = ApexPages.currentPage().getParameters().get('siteref');
        //this.oppt = [SELECT id, name FROM Opportunity WHERE Id =: oppid];
        this.llqr = [SELECT id, name, Postcode__c, Street__c, Town__c, County__c, TOID__c FROM Leased_Line_Quote_Request__c WHERE Id =: siteref];
    }
    
    public Leased_Line_Quote_Request__c getllqr(){
        return llqr;
    }  
    
    public List<LLProducts> gettalktalkproducts() {
        if(talktalkproducts == null){
            talktalkproducts = new List<LLProducts>();
        String oppid = ApexPages.currentPage().getParameters().get('opportunityid');
        String siteref = ApexPages.currentPage().getParameters().get('siteref');
        //List<Talk_Talk_Product__c> talktalkproducts = [SELECT Product__c, Connection_Price_1_Year__c, Connection_Price_3_Year__c,
        //                           Rental_Price__c, Fibre_Exchange_Name__c, Ethernet_Exchange_Name__c,
        //                           Collector_Exchange_Name__c, Zone__c, Distance__c
        //                   FROM Talk_Talk_Product__c
        //                    WHERE Site_Ref__c =: siteref
        //                   ];
        for(Talk_Talk_Product__c ttp : [SELECT Product__c, Connection_Price__c, Product_Term__c, Product_Id__c,
                                   Rental_Price__c, Fibre_Exchange_Name__c, Ethernet_Exchange_Name__c,
                                   Collector_Exchange_Name__c, Zone__c, Distance__c, Error_Message__c
                           FROM Talk_Talk_Product__c
                            WHERE Site_Ref__c =: siteref
                           ]){
                   talktalkproducts.add(new LLProducts(ttp));
        }
        }
        return talktalkproducts;   
    }    
    
    public PageReference addQuote(){
        List<LLProducts> selectedproducts2 = new List<LLProducts>();
        String oppid = ApexPages.currentPage().getParameters().get('opportunityid');  
        
        /**
        Quote quo = new Quote(name = 'TalkTalk Quote', 
                              opportunityid = oppid, 
                              pricebook2id = '01sb0000000Im2zAAC');
        insert quo; 
        
        for(LLProducts cCon:gettalktalkproducts())
        {
            if(cCon.selected==true){
                String pid = '';
                if (cCon.productname == '10MB / 100MB'){
                    pid = '01ug0000003O3J2AAK';
                }
                if (cCon.productname == '20MB / 100MB'){
                    pid = '01ug0000003O3ItAAK';
                }  
                if (cCon.productname == '30MB / 100MB'){
                    pid = '01ug0000003O3IxAAK';
                }       
                if (cCon.productname == '40MB / 100MB'){
                    pid = '01ug0000003O3IsAAK';
                } 
                if (cCon.productname == '50MB / 100MB'){
                    pid = '01ug0000003O3InAAK';
                }  
                if (cCon.productname == '100MB / 100MB'){
                    pid = '01ug0000003O3IiAAK';
                }                  
         QuoteLineItem qli = new QuoteLineItem(QuoteId = quo.id, 
                                              PriceBookEntryId = pid, 
                                              UnitPrice = 10, 
                                              Quantity = 1);
        insert qli;                
            }
        }    

        PageReference pageRef = new PageReference('/'+quo.id);
        pageRef.setRedirect(false);
        return pageRef; 
        **/
        List<PricebookEntry> pbes = [SELECT Product2Id FROM PricebookEntry];
        for(LLProducts cCon:gettalktalkproducts())
        {
            if (cCon.selected==true && cCon.term == '1 year') {
                String pid = getPricebookEntryId(pbes, cCon.productid);
                if (pid.length() > 0) {
					OpportunityLineItem oli = new OpportunityLineItem(
						OpportunityId = oppid, 
						PriceBookEntryId = pid, 
						UnitPrice = cCon.connectionprice, 
						Quantity = 1
					);
					insert oli;
                }
            }
        }          
        
        PageReference pageRef = new PageReference('/'+oppid);
        pageRef.setRedirect(false);
        return pageRef;
    }
    
    private String getPricebookEntryId(List<PricebookEntry> pbes, String productId)
    {
    	for (PricebookEntry pbe: pbes) {
    		if (pbe.Product2Id == productId) {
    			return pbe.Id;
    		}
    	}
    	return '';
    }
    
    public PageReference newPricingRequest(){
        String oppid = ApexPages.currentPage().getParameters().get('opportunityid');
        String siteref = ApexPages.currentPage().getParameters().get('siteref');
        PageReference pageRef = new PageReference('/apex/leasedlinecheck?id='+oppid);
        return pageRef;
    }
    
    public PageReference deleteRequest(){
        String oppid = ApexPages.currentPage().getParameters().get('opportunityid');
        String siteref = ApexPages.currentPage().getParameters().get('siteref');
        Leased_Line_Quote_Request__c existingrequest = [SELECT Id FROM Leased_Line_Quote_Request__c WHERE Id =: siteref];
        delete existingrequest;
        PageReference pageRef = new PageReference('/apex/leasedlinecheck?id='+oppid);
        return pageRef;
    } 
    
    public PageReference chooseProducts(){
        String oppid = ApexPages.currentPage().getParameters().get('opportunityid');
        String siteref = ApexPages.currentPage().getParameters().get('siteref');  
        selectedproducts = new List<LLProducts>();
        for(LLProducts cCon:gettalktalkproducts())
        {
            if(cCon.selected==true){
            selectedproducts.add(cCon);
            }
        }
        
        PageReference pageRef = new PageReference('/apex/llchooseproducts?id='+oppid+'&siteref='+siteref);
        return pageRef;
    }     
    
    public List<LLProducts> getSelectedProducts(){
        return selectedproducts;
    }
    
    public PageReference backpriceresults(){
        String oppid = ApexPages.currentPage().getParameters().get('opportunityid');
        String siteref = ApexPages.currentPage().getParameters().get('siteref');        
        PageReference page = new PageReference('/apex/llPriceResults?siteref='+siteref+'&opportunityid='+oppid);
        return page;        
    }
    
    public class LLProducts {
        
        public Talk_Talk_Product__c product { get; set; }
        public LLProducts(Talk_Talk_Product__c prod){
            product = prod;
            selected = false;
        }
        
        public String productname {
            get { return product.product__c; }
        }
        
        public String term {
        	get { return product.Product_Term__c; }
        }
        
        public Decimal connectionprice {
            get { return product.Connection_Price__c; }
        }
        
        public Decimal rentalprice {
            get { return product.Rental_Price__c; }  
        }
        
        public String productid {
        	get { return product.Product_Id__c; }
        }
        
        public Boolean selected
                { get; set; }
    }
}