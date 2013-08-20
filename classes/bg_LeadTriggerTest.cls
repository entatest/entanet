@isTest
private class bg_LeadTriggerTest {

    static testMethod void myUnitTest() {
    	leadMatchingUnitTest();
    	defaultReasonForClosureUnitTest();
    }

    static testMethod void leadMatchingUnitTest() {

		// Get the HubSpot Duplicates queue so we can use the ID during the test
    	List<Group> hubSpotQueue = [select Id from Group where Name = 'HubSpot Duplicates' and Type = 'Queue']; 
    	
    	// Create a test lead to be used as an existing lead
    	Lead existingLead = new Lead(FirstName='Timothy', LastName='Tester', Company='Test Company', Phone='01138889999', 
    									Twitter_Username__c='twit-twoo', Facebook__c='Facebook', Product_Interest__c='Broadband', 
    									LeadSource='HubSpot');
    	insert existingLead;
    	
    	// Create a test account to be used as an existing account
    	UserRole role = [select Id from UserRole where Name = 'Sales Admin Team'];
    	User salesAdminUser = [select Id from User where UserRoleId = :role.Id limit 1];
    	Account existingAccount = new Account(Name='Test Company Limited', Type='Reseller', Phone='01134445555', 
    											SAGE_Code__c='ABC12345', Accounts_Sales_Admin__c=salesAdminUser.Id);
    	insert existingAccount;
    	Account insertedAccount = [select Id, Name from Account where Name = :existingAccount.Name];
    	
    	// Create a test contact to be used as an existing contact and associate it with the existing test account
		Contact existingContact = new Contact(FirstName='Terry', LastName='Tester', AccountId=insertedAccount.Id, 
												Twitter_Username__c='twit', Facebook__c='Face', LinkedIn__c='Linked');
		insert existingContact;

    	// Create a lead, Company same as existing account name, first name & last name same as existing contact
    	Lead testLead = new Lead(FirstName=existingContact.FirstName, LastName=existingContact.LastName, 
    								Company=existingAccount.Name, Phone='01131112222', Product_Interest__c='Broadband', LeadSource='HubSpot',
    								Twitter_Username__c='tweety');
    	insert testLead;
    	Lead insertedLead = [select Id, FirstName, LastName, Company, Phone, OwnerId, Twitter_Username__c,
    							Product_Interest__c, LeadSource from Lead where Phone = :testLead.Phone];

		Contact insertedContact = [select FirstName, LastName, AccountId, Twitter_Username__c, Facebook__c, 
									LinkedIn__c from Contact where FirstName = :existingContact.FirstName];

		// Incoming lead should be inserted with HubSpot Duplicates queue set as the owner
        System.assertEquals(hubSpotQueue[0].Id, insertedLead.OwnerId);
		// Existing contact should be updated with values from the incoming lead
        System.assertEquals(insertedContact.Twitter_Username__c, insertedLead.Twitter_Username__c);
        
    	// Create a lead, Company same as existing account name, first name & last name different to existing contact
    	Lead testLead2 = new Lead(FirstName='Johnny', LastName='McTester', Company=existingAccount.Name, Phone='01135556666', 
    								Product_Interest__c='Broadband', LeadSource='HubSpot', Twitter_Username__c='tweetybird');
    	insert testLead2;
    	Lead insertedLead2 = [select Id, FirstName, LastName, Company, Phone, OwnerId, Twitter_Username__c,
    							Product_Interest__c, LeadSource from Lead where Phone = :testLead2.Phone];

		// Incoming lead should be inserted with HubSpot Duplicates queue set as the owner
        System.assertEquals(hubSpotQueue[0].Id, insertedLead2.OwnerId);
        
    	// Create a lead, Phone same as existing lead
    	Lead testLead3 = new Lead(FirstName='Timothy', LastName='Testerson', Company='Test Company', Phone=existingLead.Phone, 
    								Twitter_Username__c='tw1t-tw00', Facebook__c='Fac3b00k', Product_Interest__c='Broadband', 
    								LeadSource='HubSpot');
    	insert testLead3;
    	Lead insertedLead3 = [select Id, FirstName, LastName, Company, Phone, OwnerId, Twitter_Username__c, Facebook__c,
    							Product_Interest__c, LeadSource from Lead where Phone = :testLead3.Phone and LastName = :testLead3.LastName];
    	Lead updatedLead = [select Id, FirstName, LastName, Company, Phone, OwnerId, Twitter_Username__c, Facebook__c,
    						Product_Interest__c, LeadSource from Lead where Phone = :existingLead.Phone and LastName = :existingLead.LastName];
		// Incoming lead should be inserted with HubSpot Duplicates queue set as the owner
        System.assertEquals(hubSpotQueue[0].Id, insertedLead3.OwnerId);
        // Existing lead should be updated with values from the incoming lead
        System.assertEquals(insertedLead3.Twitter_Username__c, updatedLead.Twitter_Username__c);
        System.assertEquals(insertedLead3.Facebook__c, updatedLead.Facebook__c);

    	// Create a lead, no matches with existing records
    	Lead testLead4 = new Lead(FirstName='Thomas', LastName='Testington', Company='Tests R Us', Phone='01130001111', 
    								Twitter_Username__c='twittery', Facebook__c='Facemask', Product_Interest__c='Broadband', 
    								LeadSource='HubSpot');
    	insert testLead4;
    	Lead insertedLead4 = [select OwnerId from Lead where Phone = :testLead4.Phone];
    	// Lead should be inserted as normal, with the current user as the owner
        System.assertEquals(UserInfo.getUserId(), insertedLead4.OwnerId);
    }

    static testMethod void defaultReasonForClosureUnitTest() {
        
		Profile profile = [select Id from Profile where Name='System Administrator']; 

		UserRole role = [select Id from UserRole where Name='General Manager']; 
		
		User generalManager = new User(Alias = 'newUser', Email='generalmanager@entanet.com', 
										EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
										LocaleSidKey='en_US', ProfileId = profile.Id, UserRoleId = role.Id, 
										TimeZoneSidKey='America/Los_Angeles', UserName='generalmanager@entanet.com');

		System.runAs(generalManager) {
	        Lead testLead = new Lead(LastName='TestLead', Status='Open', Phone='123456789', 
	        							Company='Lead Company', Product_Interest__c='Broadband',
	        							LeadSource='HubSpot');
	        insert testLead;

	        Lead lead = [select Status from Lead where LastName = 'TestLead'];
	        lead.Status = 'Closed';
	        update lead;

			Lead updatedLead = [select Status, Reason_for_Closure__c from Lead where Id = :lead.Id];
			System.assertEquals('Closed', updatedLead.Status);
			System.assertEquals('Project abandoned', updatedLead.Reason_for_Closure__c);
		}
    }
}