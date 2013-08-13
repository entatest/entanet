public class so {
    
    public List<Sales_Order_Option__c> getSalesOrderOptions(){
    
        List<Sales_Order_Option__c> soo = [SELECT Id, Name, Detail__c FROM Sales_Order_Option__c];
        
        return soo;
    
    }
}