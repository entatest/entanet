public class quoteoptions {

    public List<LLProducts> products;
        
    public List<LLProducts> getproducts() {
        products = new List<LLProducts>();
        String oppid = ApexPages.currentPage().getParameters().get('opportunityid');
        String siteref = ApexPages.currentPage().getParameters().get('siteref');
        for(Talk_Talk_Product__c ttp : [SELECT Name, Product__c, Connection_Price_1_Year__c, Connection_Price_3_Year__c,
                                   Rental_Price__c, Fibre_Exchange_Name__c, Ethernet_Exchange_Name__c,
                                   Collector_Exchange_Name__c, Zone__c, Distance__c
                           FROM Talk_Talk_Product__c
                            WHERE Site_Ref__c = 'a0Dg0000000Jd6w' ORDER BY Name Desc
                           ]){
                   products.add(new LLProducts(ttp));
        }
        return products;   
    }      
        
    public class LLProducts {
        
        public Talk_Talk_Product__c product { get; set; }
        public LLProducts(Talk_Talk_Product__c prod){
            product = prod;
            selected = false;
        }
        
        public String productname {
            get { return product.name; }
            set {}
        }
        
        public Decimal connectionprice1year {
            get { return product.Connection_Price_1_Year__c; }
            set {}
        }
        
        public Decimal connectionprice3year {
            get { return product.Connection_Price_3_Year__c; }
            set {}
        }
        
        public Decimal rentalprice {
            get { return product.Rental_Price__c; }  
            set {}
        }
        
        public String quantity {
            get { return product.Fibre_Exchange_Name__c; }  
            set {}
        }        
        
        public Boolean selected
                { get; set; }
    }        

}