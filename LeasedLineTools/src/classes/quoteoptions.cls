public class quoteoptions {

    public List<LeasedLineResults.LLProducts> products;
        
    public List<LeasedLineResults.LLProducts> getproducts() {
        products = new List<LeasedLineResults.LLProducts>();
        String oppid = ApexPages.currentPage().getParameters().get('opportunityid');
        String siteref = ApexPages.currentPage().getParameters().get('siteref');
        for(Talk_Talk_Product__c ttp : [SELECT Product__c, Product_Term__c, Price__c, Product_Family__c,
                                   Fibre_Exchange_Name__c, Ethernet_Exchange_Name__c,
                                   Collector_Exchange_Name__c, Zone__c, Distance__c, Error_Message__c
                           FROM Talk_Talk_Product__c
                            WHERE Site_Ref__c = 'a0Dg0000000Jd6w' ORDER BY Name Desc
                           ]){
                   products.add(new LeasedLineResults.LLProducts(ttp));
        }
        return products;   
    }
}