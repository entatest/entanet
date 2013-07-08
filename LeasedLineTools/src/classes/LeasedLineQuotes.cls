public class LeasedLineQuotes {
    public Opportunity oppt;
    //public List<Leased_Line_Quote_Request__c> quoteoptions;
    Leased_Line_Quote_Request__c llqr;
    String[] applications = new String[]{};
    
    public PageReference save(){
    //PageReference pageRef = new PageReference('http://www.google.com');
    //pageRef.setredirect(true);
    //return pageRef;
    insert llqr;
    return page.linecheckerresults;
    }       

    public LeasedLineQuotes(ApexPages.StandardController controller) {
        this.oppt = (Opportunity)controller.getRecord();
    } 
    
    public Leased_Line_Quote_Request__c getleasedlinequotefields(){
        llqr = new Leased_Line_Quote_Request__c();
        return llqr;
    }
    
    
    
    //Contract Term
    public List<SelectOption> CTOptions {
     get {
       List<SelectOption> options = new List<SelectOption>();
       for( Schema.PicklistEntry f : Leased_Line_Quote_Request__c.Contract_Term__c.getDescribe().getPicklistValues()) {
         options.add(new SelectOption(f.getValue(), f.getLabel()));
        } 
       return options;
     }  
     set;
    }
    
    //get and set the multi-select pick list as checkboxes
    public String[] CTItems { 
     get {
        String[] selected = new List<String>();
        List<SelectOption> sos = this.CTOptions;
        for(SelectOption s : sos) {
        if (this.llqr.Contract_Term__c!=null && this.llqr.Contract_Term__c.contains(s.getValue()))
           selected.add(s.getValue());
        }
        return selected;
     }public set {
        String selectedConcat = '';
        for(String s : value) {
         if (selectedConcat == '') 
           selectedConcat += s;
         else selectedConcat += ';' + s;
        }
        llqr.Contract_Term__c= selectedConcat;
     }
   }     
    
    
    //Product Options
    public List<SelectOption> ProdOptions {
     get {
       List<SelectOption> options = new List<SelectOption>();
       for( Schema.PicklistEntry f : Leased_Line_Quote_Request__c.Product_Option__c.getDescribe().getPicklistValues()) {
         options.add(new SelectOption(f.getValue(), f.getLabel()));
        } 
       return options;
     }  
     set;
    }
    
    //get and set the multi-select pick list as checkboxes
    public String[] ProdItems { 
     get {
        String[] selected = new List<String>();
        List<SelectOption> sos = this.ProdOptions;
        for(SelectOption s : sos) {
        if (this.llqr.Product_Option__c!=null && this.llqr.Product_Option__c.contains(s.getValue()))
           selected.add(s.getValue());
        }
        return selected;
     }public set {
        String selectedConcat = '';
        for(String s : value) {
         if (selectedConcat == '') 
           selectedConcat += s;
         else selectedConcat += ';' + s;
        }
        llqr.Product_Option__c= selectedConcat;
     }
   }     

    //Bearer
    public List<SelectOption> BearerOptions {
     get {
       List<SelectOption> options = new List<SelectOption>();
       for( Schema.PicklistEntry f : Leased_Line_Quote_Request__c.Bearer__c.getDescribe().getPicklistValues()) {
         options.add(new SelectOption(f.getValue(), f.getLabel()));
        } 
       return options;
     }  
     set;
    }
    
    //get and set the multi-select pick list as checkboxes
    public String[] BearerItems { 
     get {
        String[] selected = new List<String>();
        List<SelectOption> sos = this.CTOptions;
        for(SelectOption s : sos) {
        if (this.llqr.Bearer__c!=null && this.llqr.Bearer__c.contains(s.getValue()))
           selected.add(s.getValue());
        }
        return selected;
     }public set {
        String selectedConcat = '';
        for(String s : value) {
         if (selectedConcat == '') 
           selectedConcat += s;
         else selectedConcat += ';' + s;
        }
        llqr.Bearer__c= selectedConcat;
     }
   }   
    
    
    //Etherflow Bandwidth
    public List<SelectOption> EtherOptions {
     get {
       List<SelectOption> options = new List<SelectOption>();
       for( Schema.PicklistEntry f : Leased_Line_Quote_Request__c.Etherflow_Bandwidth__c.getDescribe().getPicklistValues()) {
         options.add(new SelectOption(f.getValue(), f.getLabel()));
        } 
       return options;
     }  
     set;
    }
    
    //get and set the multi-select pick list as checkboxes
    public String[] EtherItems { 
     get {
        String[] selected = new List<String>();
        List<SelectOption> sos = this.EtherOptions;
        for(SelectOption s : sos) {
        if (this.llqr.Etherflow_Bandwidth__c!=null && this.llqr.Etherflow_Bandwidth__c.contains(s.getValue()))
           selected.add(s.getValue());
        }
        return selected;
     }public set {
        String selectedConcat = '';
        for(String s : value) {
         if (selectedConcat == '') 
           selectedConcat += s;
         else selectedConcat += ';' + s;
        }
        llqr.Etherflow_Bandwidth__c= selectedConcat;
     }
   }   

    //Diverse Circuit
    public List<SelectOption> DCOptions {
     get {
       List<SelectOption> options = new List<SelectOption>();
       for( Schema.PicklistEntry f : Leased_Line_Quote_Request__c.Diverse_Circuit__c.getDescribe().getPicklistValues()) {
         options.add(new SelectOption(f.getValue(), f.getLabel()));
        } 
       return options;
     }  
     set;
    }
    
    //get and set the multi-select pick list as checkboxes
    public String[] DCItems { 
     get {
        String[] selected = new List<String>();
        List<SelectOption> sos = this.DCOptions;
        for(SelectOption s : sos) {
        if (this.llqr.Product_Option__c!=null && this.llqr.Diverse_Circuit__c.contains(s.getValue()))
           selected.add(s.getValue());
        }
        return selected;
     }public set {
        String selectedConcat = '';
        for(String s : value) {
         if (selectedConcat == '') 
           selectedConcat += s;
         else selectedConcat += ';' + s;
        }
        llqr.Diverse_Circuit__c= selectedConcat;
     }
   }       
    
    //Bandwidth
    public List<SelectOption> BandwidthOptions {
     get {
       List<SelectOption> options = new List<SelectOption>();
       for( Schema.PicklistEntry f : Leased_Line_Quote_Request__c.Bandwidth__c.getDescribe().getPicklistValues()) {
         options.add(new SelectOption(f.getValue(), f.getLabel()));
        } 
       return options;
     }  
     set;
    }
    
    //get and set the multi-select pick list as checkboxes
    public String[] BandwidthItems { 
     get {
        String[] selected = new List<String>();
        List<SelectOption> sos = this.BandwidthOptions;
        for(SelectOption s : sos) {
        if (this.llqr.Bandwidth__c!=null && this.llqr.Bandwidth__c.contains(s.getValue()))
           selected.add(s.getValue());
        }
        return selected;
     }public set {
        String selectedConcat = '';
        for(String s : value) {
         if (selectedConcat == '') 
           selectedConcat += s;
         else selectedConcat += ';' + s;
        }
        llqr.Bandwidth__c= selectedConcat;
     }
   }      

    
    
    
    //public List<Leased_Line_Quote_Request__c> getquoteoptions() {
    //    quoteoptions = [ SELECT id, name FROM Leased_Line_Quote_Request__c ];
    //    return quoteoptions;
    //}
    
          public String[] getcrmAppplications() {
        return applications;
    }
 
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
    
    public Leased_Line_Quote_Request__c getllqr(){
        if (llqr == null) llqr = new Leased_Line_Quote_Request__c();
        return llqr;
    }           
}