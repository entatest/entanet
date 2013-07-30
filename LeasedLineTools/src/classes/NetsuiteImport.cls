public virtual class NetsuiteImport{
	
    virtual class NetsuiteImportException extends Exception {}    
    class NetsuiteImportNoDataFoundException extends NetsuiteImportException {}
    
    public NetsuiteImport() {
    }
               
    public void processContactsWithNoLinkedAccount() {
        List<Contact> contacts = [SELECT Id, name, Netsuite_Customer_Id__c FROM Contact WHERE Netsuite_Customer_Id__c != NULL AND AccountId = NULL];
                		        
        for(Contact c: contacts){              
            try {            
            	Account account = getAccountFromNetsuiteCustomerId((Integer)c.Netsuite_Customer_Id__c);            
            	c.AccountId = account.Id;                                                                                                
                system.debug('Updating contact: ' + c.name);                            
            } catch (NetsuiteImportNoDataFoundException e) {
                
            }            
        }
        
        update contacts;
    }   
    
    public void processOpportunitiesWithNoLinkedAccount() {
        List<Opportunity> opportunities = [SELECT Id, name, Netsuite_Customer_Id__c FROM Opportunity WHERE Netsuite_Customer_Id__c != NULL AND AccountId = NULL];
        
        for(Opportunity o: opportunities){  
            
            try {            
            	Account account = getAccountFromNetsuiteCustomerId((Integer)o.Netsuite_Customer_Id__c);            
            	o.AccountId = account.Id;                
                system.debug('Updating opportunity: ' + o.name);                            
            } catch (NetsuiteImportNoDataFoundException e) {
                
            }
        }
        
        update opportunities;
    }
    
    protected Account getAccountFromNetsuiteCustomerId(Integer netsuiteCustomerId) {
        List<Account> accounts = [SELECT Id, name FROM Account WHERE Netsuite_Customer_Id__c = :netsuiteCustomerId LIMIT 1];
        
        if (accounts.size() < 1) {            	   
			throw new NetsuiteImportNoDataFoundException('Cannot find account with netsuite customer id:' + netsuiteCustomerId);              
        }
        
        return accounts.get(0);        		
    }
}