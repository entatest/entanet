public class filter {
    
    String term = 'All';
    
    public String getterm() {
        return term;
    }
    
    public void setterm(String t) {
        this.term = t;
    }
    
    public PageReference condense(){
        PageReference pageRef = ApexPages.currentPage();
        pageRef.setRedirect(false);
        return pageRef;
    }
    
    List<LLProducts> products;
    
    public List<LLProducts> getTalkTalkProducts() {
        products = new List<LLProducts>();
        
        if(term.equals('All')){
        for(PricebookEntry prod : [
        SELECT Id, Name, UnitPrice, Product2.Term__c, Product2.lineProvider__c FROM PricebookEntry 
        WHERE Pricebook2Id = '01sb0000000Im2zAAC' AND Product2.lineProvider__c = 'Talktalk']) {
        products.add(new LLProducts(prod));   
            }
        }
        else {
        for(PricebookEntry prod : [
        SELECT Id, Name, UnitPrice, Product2.Term__c, Product2.lineProvider__c FROM PricebookEntry 
        WHERE Pricebook2Id = '01sb0000000Im2zAAC' AND Product2.lineProvider__c = 'Talktalk' AND Product2.Term__c =: term]) {
        products.add(new LLProducts(prod));   
            }
        }
        
        
        return products;
    }    
    
    public class LLProducts {
        
        private PricebookEntry product;
        public LLProducts(PricebookEntry prod){
            this.product = prod;
        }
        
        public String term {
            get { return product.product2.term__c; }
        }
        
        public String lineprovider {
            get { return product.product2.lineprovider__C; }
        }
        
        public decimal unitprice {
            get {return product.unitprice; }   
        }
        
        public String id {
            get { return product.id; }   
        }
            
        public String name {
            get { return product.name; }  
        }
        
        public Boolean selected
            { get; set; }
    } 
}