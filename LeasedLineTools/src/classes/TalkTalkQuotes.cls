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
                                              UnitPrice = con.unitprice, 
                                              Quantity = 1);
        insert qli; 
        }
        
        if(quotebook != null){
            for(LLProducts conn: quotebook) {
                        QuoteLineItem qli2 = new QuoteLineItem(QuoteId = quo.id, 
                                              PriceBookEntryId = conn.id, 
                                              UnitPrice = conn.unitprice, 
                                              Quantity = 1);
        insert qli2; 
            }
        }
        PageReference pageRef = new PageReference('/'+quo.id);
        pageRef.setRedirect(false);
        return pageRef;
    }
    
    public List<LLProducts> getTalkTalkProducts() {
            talktalkproducts = new List<LLProducts>();
            
            if(term.equals('All'))
                {
            for(PricebookEntry prod : [
            SELECT Id, Name, UnitPrice, Product2.Term__c, Product2.lineProvider__c
                FROM PricebookEntry WHERE Pricebook2Id = '01sb0000000Im2zAAC' AND Product2.lineprovider__c = 'Talktalk']) {
                talktalkproducts.add(new LLProducts(prod));   
            }
                }
            else {
            for(PricebookEntry prod : [
            SELECT Id, Name, UnitPrice, Product2.Term__c, Product2.lineProvider__c FROM PricebookEntry WHERE Pricebook2Id = '01sb0000000Im2zAAC' AND Product2.lineprovider__c = 'Talktalk' AND Product2.Term__c =: term]) {
                talktalkproducts.add(new LLProducts(prod));   
            }                
        }
        return talktalkproducts;
    }
    
    public List<LLProducts> getVirginProducts() {
            virginproducts = new List<LLProducts>();
            
            if(term.equals('All'))
                {
            for(PricebookEntry prod : [
            SELECT Id, Name, UnitPrice, Product2.Term__c, Product2.lineProvider__c FROM PricebookEntry WHERE Pricebook2Id = '01sb0000000Im2zAAC' AND Product2.lineprovider__c = 'Virgin']) {
                virginproducts.add(new LLProducts(prod));   
            }
                }
            else {
            for(PricebookEntry prod : [
            SELECT Id, Name, UnitPrice, Product2.Term__c, Product2.lineProvider__c FROM PricebookEntry WHERE Pricebook2Id = '01sb0000000Im2zAAC' AND Product2.lineprovider__c = 'Virgin' AND Product2.Term__c =: term]) {
                virginproducts.add(new LLProducts(prod));   
            }                
        }
        return virginproducts;
    }  
    
    public List<LLProducts> getBTProducts() {
            btproducts = new List<LLProducts>();
            
            if(term.equals('All'))
                {
            for(PricebookEntry prod : [
            SELECT Id, Name, UnitPrice, Product2.Term__c, Product2.lineProvider__c FROM PricebookEntry WHERE Pricebook2Id = '01sb0000000Im2zAAC' AND Product2.lineprovider__c = 'BT']) {
                btproducts.add(new LLProducts(prod));   
            }
                }
            else {
            for(PricebookEntry prod : [
            SELECT Id, Name, UnitPrice, Product2.Term__c, Product2.lineProvider__c FROM PricebookEntry WHERE Pricebook2Id = '01sb0000000Im2zAAC' AND Product2.lineprovider__c = 'BT' AND Product2.Term__c =: term]) {
                btproducts.add(new LLProducts(prod));   
            }                
        }
        return btproducts;
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
    
    public PageReference addToQuoteBook() {
                for(LLProducts t : talktalkproducts) {
                        if(t.selected==true) {
                                quotebook.add(t);
                        }
                }
                for(LLProducts v : virginproducts) {
                        if(v.selected==true) {
                                quotebook.add(v);
                        }
                }
                for(LLProducts b : btproducts) {
                        if(b.selected==true) {
                                quotebook.add(b);
                        }
                }        
        return page.linecheck; // stay on the same page
        }

    public String getQuoteBookContents() {
                if(0 == quotebook.size()) {
                        return '(empty)';
                }
        String msg = '<table>';
        for(LLProducts p : quotebook) {
        msg += '<tr>';
        msg += '<td>'+p.name+'</td>'+'<td>'+p.lineprovider+'</td>'+'<td>'+p.unitprice+'</td>';
        msg += '</tr>';
        }
        msg += '</table>';
        return msg;
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