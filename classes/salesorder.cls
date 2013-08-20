public class salesorder {
        
        String[] soptions = new String[]{};

        public Quote quote;
        public String template { get; set; }
        public List<SelectOption> options;
        public List<Sales_Order_Option__c> selectedsos;
        
        public List<Sales_Order_Option__c> getselectedsos(){
            return selectedsos;
        }        

        public salesorder(ApexPages.StandardController controller) {
            this.quote = (Quote)controller.getRecord();
        }
        
      public String[] getsoptions() {
        return soptions;
    }
 
    public void setsoptions(String[] soptions) {
        this.soptions = soptions;
    }        
    
        public PageReference createso(){
        selectedsos = new List<Sales_Order_Option__c>();
        String selectedField;
        
        for (String field : getsoptions()){
            Sales_Order_Option__c sooc = [SELECT Id, Name, Detail__c FROM Sales_Order_Option__c WHERE Name =: field];
            selectedField = selectedField == null ? field : +selectedField+','+field;
            //test += field + '<br/>' + sooc.Detail__c + '<br/><br/>';
            selectedsos.add(sooc); 
        }        
        
            return page.salesorderpdf;
        }
        
        public List<SelectOption> getdetails() {
            options = new List<SelectOption>();
            options.add(new SelectOption('Talk Talk EFM','Talk Talk EFM'));
            options.add(new SelectOption('Talk Talk Education','Talk Talk Education'));
            options.add(new SelectOption('BT EFM','BT EFM'));
            options.add(new SelectOption('Point to Point Circuit','Point to Point Circuit'));            
            options.add(new SelectOption('Upgrade Option 1','Upgrade Option 1'));            
            options.add(new SelectOption('Upgrade Option 2','Upgrade Option 2'));            
            return options;
        }
        
}