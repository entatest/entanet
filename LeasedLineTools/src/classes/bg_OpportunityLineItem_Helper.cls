public with sharing class bg_OpportunityLineItem_Helper {
    
    public static void setFixedPriceLineItemPrices(list<OpportunityLineItem> lineItems) {

        // list to hold all the opportunity ids in the oli sent in
        list<Id> opportunityIdList = new list<Id>();
        
        // map to hold account id by opp id
        map<Id, Id> accountIdByOpportunityIdMap = new map<Id, Id>();
        
        list<Id> pbeIdList = new list<Id>();
        
        map<Id, Id> product2IdByPBEId = new map<Id, Id>();
        
        // Dump all opp IDs and pricebook entry IDs in lists from the opp line items
        for (OpportunityLineItem oli : lineItems) {
            opportunityIdList.add(oli.OpportunityId);
            
            pbeIdList.add(oli.PricebookEntryId);
        }
        
        if (!opportunityIdList.isEmpty()) {
            
            // loop round all the opps whose id is in the oppid list and get the account id from them
            for (Opportunity opportunity : [select Id, AccountId from Opportunity where Id in : opportunityIdList]) {
                
                // add the account id into a map with the opp id as the key
                accountIdByOpportunityIdMap.put(opportunity.Id, opportunity.AccountId);
                
            }
            
            if (!accountIdByOpportunityIdMap.isEmpty()) {
                
                // go and get all the account objects (just need the flag) that have ids in the map from above and add em straight in a map by id
                map<Id, Account> accountByAccountIdMap = new map<Id, Account>([select Default_Margin__c from Account where Id in : accountIdByOpportunityIdMap.values()]);
                
                if (!accountByAccountIdMap.isEmpty()) {
            
                    // prod
                    for (PricebookEntry pbe : [select Id, Product2Id from PricebookEntry where Id = :pbeIdList]) {
                        
                        product2IdByPBEId.put(pbe.Id, pbe.Product2Id);
                    }
                    
                    map<Id, Product2> product2ById = new map<Id, Product2>([select Id, Family, Cost_Price__c, Fixed_Price_Product__c from Product2 where Id in : product2IdByPBEId.values()]);
                    
                    for (OpportunityLineItem oli : lineItems) {

                        if (product2ById.get(product2IdByPBEId.get(oli.PricebookEntryId)).Fixed_Price_Product__c) {

                            oli.Fixed_Price_Product__c = true;

							if (product2ById.get(product2IdByPBEId.get(oli.PricebookEntryId)).Family == 'One-Off Charges') {
                            	// This if statement is required to get the tests to run! oli.ListPrice should never be null when adding products 
                            	// to opportunities via the UI, but it is null when doing so in a test class
	                            if (oli.ListPrice != null) {
	                            	oli.Cost_Price__c = oli.ListPrice;
	                            } else {
									oli.Cost_Price__c = [select UnitPrice from PriceBookEntry where Id = :oli.PricebookEntryId].UnitPrice;
	                            }
	                            oli.UnitPrice = oli.Cost_Price__c;
							} else {
								oli.Cost_Price__c = product2ById.get(product2IdByPBEId.get(oli.PricebookEntryId)).Cost_Price__c; 
	                           	oli.UnitPrice = oli.Cost_Price__c + (oli.Cost_Price__c * (accountByAccountIdMap.get(accountIdByOpportunityIdMap.get(oli.OpportunityId)).Default_Margin__c / 100));
							}
                        }
                    }

                    for (OpportunityLineItem oli : lineItems) {
                        Opportunity opp = [select All_Products_Fixed_Price__c from Opportunity where Id = :oli.OpportunityId limit 1];

                        if (oli.Fixed_Price_Product__c) {
                            opp.All_Products_Fixed_Price__c = true;
                        } else {
                            opp.All_Products_Fixed_Price__c = false;
                        }
                        update opp;
                    }
                }
            }
        }
    }
    
    public static void setLineItemPrices(list<OpportunityLineItem> updatedLineItems, Map<Id, OpportunityLineItem> oldLineItems) {
        // list to hold all the opportunity ids in the oli sent in
        list<Id> opportunityIdList = new list<Id>();
        
        // map to hold account id by opp id
        map<Id, Id> accountIdByOpportunityIdMap = new map<Id, Id>();
        
        list<Id> pbeIdList = new list<Id>();
        
        map<Id, Id> product2IdByPBEId = new map<Id, Id>();
        
        // Dump all opp IDs and pricebook entry IDs in lists from the opp line items
        for (OpportunityLineItem oli : updatedLineItems) {
            opportunityIdList.add(oli.OpportunityId);
            
            pbeIdList.add(oli.PricebookEntryId);
        }
        
        if (!opportunityIdList.isEmpty()) {
            
            // loop round all the opps whose id is in the oppid list and get the account id from them
            for (Opportunity opportunity : [select Id, AccountId from Opportunity where Id in : opportunityIdList]) {
                
                // add the account id into a map with the opp id as the key
                accountIdByOpportunityIdMap.put(opportunity.Id, opportunity.AccountId);
                
            }
            
            if (!accountIdByOpportunityIdMap.isEmpty()) {
                
                // go and get all the account objects (just need the flag) that have ids in the map from above and add em straight in a map by id
                map<Id, Account> accountByAccountIdMap = new map<Id, Account>([select Default_Margin__c from Account where Id in : accountIdByOpportunityIdMap.values()]);
                
                if (!accountByAccountIdMap.isEmpty()) {
            
                    // prod
                    for (PricebookEntry pbe : [select Id, Product2Id from PricebookEntry where Id = :pbeIdList]) {
                        
                        product2IdByPBEId.put(pbe.Id, pbe.Product2Id);
                    }
                    
                    map<Id, Product2> product2ById = new map<Id, Product2>([select Id, Fixed_Price_Product__c from Product2 where Id in : product2IdByPBEId.values()]);
                    
                    for (OpportunityLineItem oli : updatedLineItems) {
                        
                        if (!product2ById.get(product2IdByPBEId.get(oli.PricebookEntryId)).Fixed_Price_Product__c && oli.Cost_Price__c != null) {

							// If the Sales Price (UnitPrice) has been changed in the UI we want to preserve that change.
							// Only set Sales Price equal to Cost Price + Default Margin when Sales Price (UnitPrice) has not changed 
							if (oli.UnitPrice == oldLineItems.get(oli.Id).UnitPrice) {
                            	oli.UnitPrice = oli.Cost_Price__c + (oli.Cost_Price__c * (accountByAccountIdMap.get(accountIdByOpportunityIdMap.get(oli.OpportunityId)).Default_Margin__c / 100));
							}
                            oli.Supplier_Expiry_Date__c = system.today() + Integer.valueOf(Label.Product_Expiry_Days);
                            oli.Price_Locked__c = true;
                            
                        }
                    }

                    // Loop through the opp line items and set Quote Expiry Date equal to the latest (furthest in the future) Supplier Expiry Date value                   
                    for (OpportunityLineItem oli : updatedLineItems) {
                        Opportunity opp = [select Quote_Expiry_Date__c from Opportunity where Id = :oli.OpportunityId limit 1];

                        if (oli.Fixed_Price_Product__c) {
                            opp.All_Products_Fixed_Price__c = true;
                        } else {
                            opp.All_Products_Fixed_Price__c = false;
                        }
                        
                        if (oli.Supplier_Expiry_Date__c != null && oli.Supplier_Expiry_Date__c > opp.Quote_Expiry_Date__c) {
                            opp.Quote_Expiry_Date__c = oli.Supplier_Expiry_Date__c;
                            update opp;
                        }
                    }
                }
            }
        }
    }
}