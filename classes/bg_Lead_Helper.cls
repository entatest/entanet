public with sharing class bg_Lead_Helper {
	
	private static Map<String, Id> existingLeads = new Map<String, Id>();
	private static Map<String, Id> existingAccounts = new Map<String, Id>();
	private static Map<Id, Id> existingContacts = new Map<Id, Id>();

	private static String EXISTING_ACCOUNT_CONTACT_UPDATED = 'Company match - existing account found, existing contact updated';
	private static String EXISTING_ACCOUNT_CONTACT_CREATED = 'Company match - existing account found, new contact created';
	private static String EXISTING_LEAD_UPDATED = 'Phone match - existing lead updated';
	private static String leadMatchingAction = '';
	
    public static void matchLead(list<Lead> leads) {
		
		setUpMaps();
		
 		for (Lead lead : leads) {

			if (lead.LeadSource == 'HubSpot') {
				
				// Do we have an account that matches this lead's company name?
				if (!matchLeadByCompany(lead)) {
					// If not, do we have a lead that matches this lead's phone?
					matchLeadByPhone(lead);
				}
			}
		}
    }	

	private static void setUpMaps() {
		
		// Create a map of all existing open (not converted) leads using Phone as the key
		//Map<String, Id> existingLeads = new Map<String, Id>();
		for (Lead lead : [select Id, Name, Phone from Lead where IsConverted = false]) {
			existingLeads.put(lead.Phone, Lead.Id);
		}

		// Create a map of all existing accounts using Name as the key
		//Map<String, Id> existingAccounts = new Map<String, Id>();
		for (Account account : [select Id, Name from Account]) {
			existingAccounts.put(account.Name, account.Id);
		}

		// Create map of all existing contacts using AccountId as the key
		//Map<Id, Id> existingContacts = new Map<Id, Id>();
		for (Contact contact : [select Id, AccountId from Contact]) {
			existingContacts.put(contact.AccountId , contact.Id);
		}
	}

	private static Boolean matchLeadByCompany(Lead lead) {

		Boolean result = false;

		// Do we have an account matching the lead's company name?
		if (existingAccounts.containsKey(lead.Company) ) {
			system.debug('~@~@~@~@ we have a matching account');

			system.debug('~@~@~@~@ account ID is ' + existingAccounts.get(lead.Company));
			//getContactsByAccountId(existingAccounts.get(lead.Company));
					
			system.debug('~@~@~@~@ lead name is ' + lead.Name);
			system.debug('~@~@~@~@ lead firstname lastname is ' + lead.FirstName + ' ' + lead.LastName);
			//system.debug('~@~@~@~@ contact ID is ' + contactNames.get(lead.FirstName + ' ' + lead.LastName));
			// If so, check for a contact with the same name as the lead
			matchLeadByName(lead);

			// Add the lead to the HubSpot Duplicates queue
	    	addLeadToHubSpotQueue(lead);
	    	
	    	result = true;
		}
		
		return result;
	}

	private static void matchLeadByName(Lead lead) {

		Map<String, Id> contactNames = getContactsByAccountId(existingAccounts.get(lead.Company));
		
		if (contactNames.containsKey(lead.FirstName + ' ' + lead.LastName)) {
			system.debug('~@~@~@~@ we have a matching contact');
			// If we have a contact with the same name as the lead, update the contact with data from the lead
			Contact existingContact = [select Phone, MobilePhone, Email, Title, MailingStreet, MailingCity, MailingState, 
										MailingCountry, MailingPostalCode,Twitter_Username__c, Facebook__c, 
										LinkedIn__c from Contact where Id = :contactNames.get(lead.FirstName + ' ' + lead.LastName)]; 

			existingContact.Phone=lead.Phone;
			existingContact.MobilePhone=lead.MobilePhone;
			existingContact.Email=lead.Email; 
			existingContact.Title=lead.Title;
			existingContact.MailingStreet=lead.Street;
			existingContact.MailingCity=lead.City;
			existingContact.MailingState=lead.State;
			existingContact.MailingCountry=lead.Country;
			existingContact.MailingPostalCode=lead.PostalCode;
			existingContact.Twitter_Username__c = lead.Twitter_Username__c;
			existingContact.Facebook__c = lead.Facebook__c;
			existingContact.LinkedIn__c = lead.LinkedIn__c;

			leadMatchingAction = EXISTING_ACCOUNT_CONTACT_UPDATED;
			update existingContact;
		} else {
			// Otherwise, create a new contact and associate it with the account
			Contact newContact = new Contact(Salutation=lead.Salutation, FirstName=lead.FirstName, LastName=lead.LastName,
												AccountId=existingAccounts.get(lead.Company),
												Phone=lead.Phone,
												MobilePhone=lead.MobilePhone,
												Email=lead.Email, 
												LeadSource=lead.LeadSource,
												Title=lead.Title,
												MailingStreet=lead.Street,
												MailingCity=lead.City,
												MailingState=lead.State,
												MailingCountry=lead.Country,
												MailingPostalCode=lead.PostalCode,
												Twitter_Username__c=lead.Twitter_Username__c, 
												Facebook__c=lead.Facebook__c, 
												LinkedIn__c=lead.LinkedIn__c); 

			leadMatchingAction = EXISTING_ACCOUNT_CONTACT_CREATED;
			insert newContact;
		}
	}
    
    private static void matchLeadByPhone(Lead lead) {
		
		if (existingLeads.containsKey(lead.Phone)) {
			Lead existingLead = [select Id, Name, Salutation, Title, Email, Alternate_Email__c, MobilePhone, Product_Interest__c,
									Number_of_Sites__c, Number_of_Employees__c, Order_Timeframe__c, Lead_Requirements__c, 
									Street, City, State, Country, PostalCode, 
									Twitter_Username__c, Facebook__c, LinkedIn__c, Speed_Required__c, Installation_Postcode__c,
									How_Did_you_Hear_About_Entanet__c from Lead where Id = :existingLeads.get(lead.Phone)];
									
			existingLead.Salutation=lead.Salutation;
			existingLead.Title=lead.Title; 
			existingLead.Email=lead.Email;
			existingLead.Alternate_Email__c=lead.Alternate_Email__c;
			existingLead.MobilePhone=lead.MobilePhone;
			existingLead.Product_Interest__c=lead.Email; 
			existingLead.Number_of_Sites__c=lead.Number_of_Sites__c; 
			existingLead.Number_of_Employees__c=lead.Number_of_Employees__c; 
			existingLead.Order_Timeframe__c=lead.Order_Timeframe__c;
			existingLead.Lead_Requirements__c=lead.Lead_Requirements__c;
			existingLead.LeadSource=lead.LeadSource;
			existingLead.Title=lead.Title;
			existingLead.Street=lead.Street;
			existingLead.City=lead.City;
			existingLead.State=lead.State;
			existingLead.Country=lead.Country;
			existingLead.PostalCode=lead.PostalCode;
			existingLead.Twitter_Username__c=lead.Twitter_Username__c; 
			existingLead.Facebook__c=lead.Facebook__c;
			existingLead.LinkedIn__c=lead.LinkedIn__c; 
			existingLead.Speed_Required__c=lead.Speed_Required__c;
			existingLead.Installation_Postcode__c=lead.Installation_Postcode__c;
			existingLead.How_Did_you_Hear_About_Entanet__c=lead.How_Did_you_Hear_About_Entanet__c;
					
			leadMatchingAction = EXISTING_LEAD_UPDATED;
			existingLead.Updated_from_HubSpot__c = true;
			update existingLead;

	    	addLeadToHubSpotQueue(lead);
		}
    }
    
    private static void addLeadToHubSpotQueue(Lead lead) {
    	// Add lead to the HubSpot Duplicates queue and set lead matching action
    	List<Group> hubSpotQueue = [select Id from Group where Name = 'HubSpot Duplicates' and Type = 'Queue']; 
    	lead.OwnerId = hubSpotQueue[0].Id;
    	lead.Lead_Matching_Action__c = leadMatchingAction;
    } 
    
    private static Map<String, Id> getContactsByAccountId(Id accountId) {

    	Map<String, Id> contactNames = new Map<String, Id>();
		
		for (Contact contact : [select Id, Name from Contact where AccountId = :accountId]) {
			contactNames.put(contact.Name, contact.Id);
		}
		
		return contactNames;
    }
    
	// If Lead Status is Closed...
	// AND Reason for Closure is not specified...
	// AND the current user's role is one of the ones with access to the Lead pool...
	// Default Reason for Closure to Project Abandoned
    public static void setDefaultReasonForClosure(list<Lead> leads) {

		List<UserRole> roles = [select Id, Name from UserRole where Id=:userinfo.getUserRoleId()];

		String currentUserRoleName = roles[0].Name;

    	for (Lead lead : leads) {
    		if (lead.Status == 'Closed' && lead.Reason_for_Closure__c == null && 
    			(currentUserRoleName == 'General Manager' || 
    				currentUserRoleName == 'Marketing Manager' || 
    				currentUserRoleName == 'Marketing Team' || 
    				currentUserRoleName == 'Sales Co-ordinator' || 
    				currentUserRoleName == 'Sales Manager')) {

    			lead.Reason_for_Closure__c = 'Project Abandoned';
    		}
    	}
    }	
}