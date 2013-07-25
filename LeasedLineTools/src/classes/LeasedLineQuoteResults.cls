public class LeasedLineQuoteResults {
    
    public List<Virgin_Media_Product__c> virginproducts;
    public List<Talk_Talk_Product__c> talktalkproducts;   
    public List<BT_Wholesale_Product__c> btproducts;
    public Opportunity oppt;
    
    public LeasedLineQuoteResults(ApexPages.StandardController controller) {
        this.oppt = (Opportunity)controller.getRecord();
    }
    
    public List<Virgin_Media_Product__c> getvirginproducts() {
        virginproducts = new List<Virgin_Media_Product__c>();
        virginproducts = [SELECT Bearer__c, Bandwidth__c, Product_Term__c, Connection_Price__c,
                                         Rental_Price__c, Total_Pricing_Summary__c, BPT_Quote__c, 
                                         Reference__c, Site_B_Access__c, Flavour__c
                          FROM Virgin_Media_Product__c];
        return virginproducts;   
    }
    
    public List<Talk_Talk_Product__c> gettalktalkproducts() {
        talktalkproducts = new List<Talk_Talk_Product__c>();
        talktalkproducts = [SELECT Product__c, Product_Term__c, Price__c, Product_Family__c,
                                   Fibre_Exchange_Name__c, Ethernet_Exchange_Name__c,
                                   Collector_Exchange_Name__c, Zone__c, Distance__c, Error_Message__c
                            FROM Talk_Talk_Product__c];
        return talktalkproducts;   
    }

    public List<BT_Wholesale_Product__c> getbtproducts() {
        btproducts = new List<BT_Wholesale_Product__c>();
        btproducts = [SELECT Bearer__c, Bandwidth__c, Product_Term__c, Etherflow_Pricing__c,
                                 Connection_Price__c, Rental_Price__c, Hub_Site_Postcode__c, Access_Type__c
                      FROM BT_Wholesale_Product__c];
        return btproducts;   
    }    
}