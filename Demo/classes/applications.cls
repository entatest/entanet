public with sharing class applications {
    
    String[] applications = new String[]{};
	String testington = 'test';
    public List<Sales_Order_Option__c> selectedsos;
    
    public List<Sales_Order_Option__c> getselectedsos(){
        return selectedsos;
    }
     
      public String[] getcrmAppplications() {
        return applications;
    }
    
    public string test {get; set;}
 
    public void setcrmAppplications(String[] applications) {
        this.applications = applications;
    }
    
 
    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('BT EFM','BT EFM'));
        options.add(new SelectOption('TalkTalk EFM','TalkTalk EFM'));
        options.add(new SelectOption('TalkTalk Education','TalkTalk Education'));
        options.add(new SelectOption('Upgrade Option 1','Upgrade Option 1'));
        options.add(new SelectOption('Upgrade Option 2','Upgrade Option 2'));
        options.add(new SelectOption('Point to Point Circuit','Point to Point Circuit'));

        return options;
    }
    
    
    public PageReference saveOptions() {
        String selectedField;
        test = 'test';
        selectedsos = new List<Sales_Order_Option__c>();
        
        for (String field : getcrmAppplications()){
            Sales_Order_Option__c sooc = [SELECT Id, Name, Detail__c FROM Sales_Order_Option__c WHERE Name =: field];
            selectedField = selectedField == null ? field : +selectedField+','+field;
            //test += field + '<br/>' + sooc.Detail__c + '<br/><br/>';
            selectedsos.add(sooc);
            
        }
        System.debug('Fields are '+selectedField);
        // Output as A,B,C based on the selected fields
        return null;
    }
    
    public List<Sales_Order_Option__c> getSalesOrderOptions(){
        List<Sales_Order_Option__c> soo = [SELECT Id, Name, Detail__c FROM Sales_Order_Option__c];
        return soo;
    }
    
    public class salesorderoption {
        private Sales_Order_Option__c salesorder;
        public salesorderoption(Sales_Order_Option__c soo){
            this.salesorder = soo;
        }        
    
    }    
}