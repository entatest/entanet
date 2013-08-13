public class LeasedLineQuotes {
    public Opportunity oppt;
    //public List<Leased_Line_Quote_Request__c> quoteoptions;
    Leased_Line_Quote_Request__c llqr;
    String[] applications = new String[]{};
    List<Leased_Line_Quote_Request__c> savedllqr;
    
    public String savedsiteref { get; set; }
    public String savedoppid { get; set; }    
    
    public PageReference save(){
    //PageReference pageRef = new PageReference('http://www.google.com');
    //pageRef.setredirect(true);
    //return pageRef;
    //construct an HTTP request
      
    llqr.xml__c = this.llqrxml('test');
    llqr.Opportunity_ID__c = ApexPages.currentPage().getParameters().get('Id');        
	insert llqr;
    String idresult = llqr.id;    
    String xml = this.llqrxml(idresult);    
    LeasedLineQuotes.restreq(xml);    
    
	PageReference page = new PageReference('/apex/llPriceResults?siteref='+idresult+'&opportunityid='+llqr.Opportunity_ID__c);
    return page;
    }  
    
    public PageReference saveandnew(){  
    	llqr.xml__c = this.llqrxml('test');
    	llqr.Opportunity_ID__c = ApexPages.currentPage().getParameters().get('Id');        
		insert llqr;
    	String idresult = llqr.id;    
    	String xml = this.llqrxml(idresult);    
    	LeasedLineQuotes.restreq(xml);    
    
		PageReference page = new PageReference('/apex/leasedlinecheck?id='+llqr.Opportunity_ID__c);
    	return page;
    }

	@future (callout=true)
    static void restreq(string xml) {
    HttpRequest req = new HttpRequest();
    req.setEndpoint('http://sfgw.enta.net/rest/quotes');
    req.setMethod('POST');
    req.setBody(xml);    

    //send the request
    Http http = new Http();
    HttpResponse res = http.send(req);           
        }
    
    public PageReference loadquotes(){
     	
        PageReference page = new PageReference('/apex/llPriceResults?siteref='+savedsiteref+'&opportunityid='+savedoppid);
        return page;
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
        List<SelectOption> sos = this.BearerOptions;
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
    
    public List<Leased_Line_Quote_Request__c> getsavedllqr(){
        savedllqr = [SELECT Id, Name, TOID__c, Postcode__c, Street__c, Opportunity_ID__c, Site_Reference__c FROM Leased_Line_Quote_Request__c WHERE Opportunity_ID__c =: ApexPages.currentPage().getParameters().get('Id')];
        return savedllqr;
    }   
    
    public pageReference showSite(){
        String selectedSite = ApexPages.currentPage().getParameters().get('siteid');
        PageReference pageRef = new PageReference('/apex/leasedlinecheck?siteref='+selectedsite);
        pageRef.setredirect(true);
        return pageRef;
    }
    
    public String llqrxml(string llqrid){
          XmlStreamWriter w = new XmlStreamWriter();
          w.writeStartDocument(null, '1.0');
          w.writeStartElement('', 'LeasedLineQuoteRequest', '');
          w.writeStartElement('', 'RequestersId', '');        
          w.writeCharacters(llqrid);
          w.writeEndElement(); //end requestorsid
          w.writeStartElement('', 'LeasedLineQuoteSites', ''); 
          w.writeStartElement('', 'LeasedLineQuoteSite', '');
		  w.writeStartElement('', 'SiteReference', '');
          w.writeCharacters(llqrid);
		  w.writeEndElement(); //end SiteReferemce
		  w.writeStartElement('', 'AEndPostCode', '');
          w.writeCharacters(llqr.Postcode__c);
		  w.writeEndElement(); //end AEndPostCode
		  w.writeStartElement('', 'AEndToid', '');
          w.writeCharacters(llqr.TOID__c);
		  w.writeEndElement(); //end AEndToid
		  w.writeStartElement('', 'BEndPostCode', '');
          w.writeCharacters(llqr.Postcode__c);
		  w.writeEndElement(); //end BEndPostCode
		  w.writeStartElement('', 'BEndToid', '');
          w.writeCharacters(llqr.TOID__c);
		  w.writeEndElement(); //end BEndToid
		  w.writeStartElement('', 'LeasedLineQuoteSuppliers', '');
		  w.writeStartElement('', 'LeasedLineQuoteSupplier', '');
          w.writeStartElement('', 'Name', '');
          w.writeCharacters('TalkTalk');
		  w.writeEndElement(); //end name
        
          /**
          w.writeStartElement('', 'LeasedLineQuoteSupplierOptions', '');
          
          
        
          //Supplier Product Options
          List<SelectOption> supplieros = this.ProdOptions;
          for(SelectOption prodo : supplieros) {
          if (this.llqr.Product_Option__c!=null && this.llqr.Product_Option__c.contains(prodo.getValue()))
          {   
          w.writeStartElement('', 'LeasedLineQuoteSupplierOption', '');
          w.writeStartElement('', 'Name', ''); 
          w.writeCharacters('Some Option'); 
          w.writeEndElement(); //end name 
          w.writeStartElement('', 'Value', '');
          w.writeCharacters(prodo.getValue());
		  w.writeEndElement(); //end value     
          w.writeEndElement(); //end leasedlinequotesupplieroption              
          } 
          }
        
        //Supplier Bearer Options
        List<SelectOption> beareros  = this.BearerOptions;
        for(SelectOption bearero : beareros) {
        if (this.llqr.Bearer__c!=null && this.llqr.Bearer__c.contains(bearero.getValue()))
        {
          w.writeStartElement('', 'LeasedLineQuoteSupplierOption', '');
          w.writeStartElement('', 'Name', ''); 
          w.writeCharacters('Some Option'); 
          w.writeEndElement(); //end name 
          w.writeStartElement('', 'Value', '');
          w.writeCharacters(bearero.getValue());
		  w.writeEndElement(); //end value     
          w.writeEndElement(); //end leasedlinequotesupplieroption    
        }
        }  
        
        
         List<SelectOption> etheros = this.EtherOptions;
        for(SelectOption ethero : etheros) {
        if (this.llqr.Etherflow_Bandwidth__c!=null && this.llqr.Etherflow_Bandwidth__c.contains(ethero.getValue()))
        {
          w.writeStartElement('', 'LeasedLineQuoteSupplierOption', '');
          w.writeStartElement('', 'Name', ''); 
          w.writeCharacters('Some Option'); 
          w.writeEndElement(); //end name 
          w.writeStartElement('', 'Value', '');
          w.writeCharacters(ethero.getValue());
		  w.writeEndElement(); //end value     
          w.writeEndElement(); //end leasedlinequotesupplieroption    
        }           
        }
        
        List<SelectOption> dcos = this.DCOptions;
        for(SelectOption dco : dcos) {
        if (this.llqr.Product_Option__c!=null && this.llqr.Diverse_Circuit__c.contains(dco.getValue()))
        {
          w.writeStartElement('', 'LeasedLineQuoteSupplierOption', '');
          w.writeStartElement('', 'Name', ''); 
          w.writeCharacters('Some Option'); 
          w.writeEndElement(); //end name 
          w.writeStartElement('', 'Value', '');
          w.writeCharacters(dco.getValue());
		  w.writeEndElement(); //end value     
          w.writeEndElement(); //end leasedlinequotesupplieroption    
        }      
        }   
        
        
                List<SelectOption> bandwidthos = this.BandwidthOptions;
        for(SelectOption bandwidtho : bandwidthos) {
        if (this.llqr.Bandwidth__c!=null && this.llqr.Bandwidth__c.contains(bandwidtho.getValue()))
        {
          w.writeStartElement('', 'LeasedLineQuoteSupplierOption', '');
          w.writeStartElement('', 'Name', ''); 
          w.writeCharacters('Some Option'); 
          w.writeEndElement(); //end name 
          w.writeStartElement('', 'Value', '');
          w.writeCharacters(bandwidtho.getValue());
		  w.writeEndElement(); //end value     
          w.writeEndElement(); //end leasedlinequotesupplieroption    
        }   
        }
        
        
          w.writeEndElement(); //end leasedlinequotesupplieroptions
		  **/

          w.writeEndElement(); //end leasedlinequotesupplier
		  w.writeStartElement('', 'LeasedLineQuoteSupplier', '');
          w.writeStartElement('', 'Name', '');
          w.writeCharacters('Virgin');
		  w.writeEndElement(); //end name
          w.writeStartElement('', 'LeasedLineQuoteSupplierOptions', '');
        
          //Leased Line Supplier Options
		  List<SelectOption> llso = this.BandwidthOptions;
          for(SelectOption so : llso) {
          if (this.llqr.Bandwidth__c!=null && this.llqr.Bandwidth__c.contains(so.getValue())){
          w.writeStartElement('', 'Name', '');
          w.writeCharacters('Ethernet Speed');
          w.writeEndElement(); //end name
          w.writeStartElement('', 'Value', '');
          w.writeCharacters(so.getValue());
          w.writeEndElement(); //end Value              
          }
          }
        
          w.writeEndElement(); //end LeasedLineSupplierOptions        
          w.writeEndElement(); //end leasedlinequotesupplier        
          w.writeEndElement(); //end leasedlinequotesuppliers
          w.writeStartElement('', 'LeasedLineContractTerms', '');
          
          //Contract Term Options
		  List<SelectOption> sos = this.CTOptions;
          for(SelectOption s : sos) {
          if (this.llqr.Contract_Term__c!=null && this.llqr.Contract_Term__c.contains(s.getValue())){
          w.writeStartElement('', 'LeasedLineContractTerm', '');
          w.writeCharacters(s.getValue());
          w.writeEndElement(); //end leasedlinecontractterm 
          }
          }
        
          w.writeEndElement(); //end leasedlinecontractterms
          w.writeEndElement(); //end leasedlinequotesite
          w.writeEndElement(); //end leasedlinequotesites        
          w.writeEndElement(); //end leasedlinequoterequest
          w.writeEndDocument();
          String xmlOutput = w.getXmlString();
          w.close();
        
          return xmlOutput;        
    } 
}