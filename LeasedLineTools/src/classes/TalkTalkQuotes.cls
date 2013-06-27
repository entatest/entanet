public class TalkTalkQuotes {
    
    List<LLProducts> products;
    public List<LLProducts> selectedproducts;
    public Opportunity oppt;
    public String postcode { get; set; }
    public Boolean exactaddress { get; set; }

    public TalkTalkQuotes(ApexPages.StandardController controller) {
        this.oppt = (Opportunity)controller.getRecord();
    }
    
    public pageReference Quotes(){
        return Page.linecheckerresults;
    }
    
    public PageReference addQuote(){
        List<LLProducts> sp = new List<LLProducts>();
        
        Quote quo = new Quote(name = 'TalkTalk Quote2', 
                              opportunityid = oppt.id, 
                              pricebook2id = '01sJ00000000GMUIA2');
        insert quo;
        
        for(LLProducts cCon:getproducts())
        {
            if(cCon.selected==true){
            	sp.add(cCon);
            }
        }
        
        for(LLProducts con: sp) {
        
        QuoteLineItem qli = new QuoteLineItem(QuoteId = quo.id, 
                                              PriceBookEntryId = con.id, 
                                              UnitPrice = 50.11, 
                                              Quantity = 4);
        insert qli;
            
        }
        PageReference pageRef = new PageReference('/'+quo.id);
        pageRef.setRedirect(false);
        return pageRef;
    }
    
    public List<LLProducts> getProducts() {
        if (products == null) {
            products = new List<LLProducts>();
            for(PricebookEntry prod : [
            SELECT Id, Name FROM PricebookEntry WHERE Pricebook2Id = '01sJ00000000GMUIA2']) {
                products.add(new LLProducts(prod));   
            }
        }
        return products;
    }
    
    public List<LLProducts> getSelectedProducts() {
        selectedproducts = new List<LLProducts>();
        for(LLProducts cCon:getproducts())
        {
            if(cCon.selected==true)
            {
                selectedproducts.add(cCon);
            }
        }
     	return selectedproducts;   
    }
    
    public class LLProducts {
        
        private PricebookEntry product;
        public LLProducts(PricebookEntry prod){
            this.product = prod;
        }
        
        public String id {
            get { return product.id; }   
        }
            
        public String name {
            get { return product.name; }  
        }
        
        public Boolean selected { get; set; }
    }
    
    
}