public class qtest {

    public List<LLProducts> llproductsList {get; set;}

    public class LLProducts {
        public Talk_Talk_Product__c product {get; set;}
        public Boolean selected {get; set;}
        
    public LLProducts(Talk_Talk_Product__c prod){
        product = prod;
        selected = false;
        }        
    } 

}