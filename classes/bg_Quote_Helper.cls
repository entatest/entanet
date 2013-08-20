public with sharing class bg_Quote_Helper {
	
	public static void setExpirationDate(List<Quote> quotes) {
		
		for (Quote quote : quotes) {
			Opportunity opp = [select Id, Quote_Expiry_Date__c, All_Products_Fixed_Price__c from Opportunity where Id = :quote.OpportunityId];
			if (opp.All_Products_Fixed_Price__c) {
				quote.ExpirationDate = system.today() + Integer.valueOf(Label.Product_Expiry_Days);				
			} else {
				quote.ExpirationDate = opp.Quote_Expiry_Date__c;
			}
		}
	}
}