@isTest
public class TestUtil {
    
    static public void createTalktalkProducts()
	{
		//String[] bearers = new String[]{'100Mb', '1Gb'};
		//String[] bandwidths = new String[]{'10Mb', '20Mb', '30Mb', '40Mb', '50Mb', '100Mb', '200Mb', '300Mb', '500Mb', '1Gb'};
		String[] bearers = new String[]{'100Mb'};
		String[] bandwidths = new String[]{'10Mb', '20Mb'};
		String[] terms = new String[]{'1', '3'};
		String[] families = new String[]{'Installation Charges', 'Recurring Charges'};
		list<Product2> products2 = new list<Product2>();
		for (String bearer: bearers) {
			for (String bandwidth: bandwidths) {
				Integer intBearer = convertToMb(bearer);
				Integer intBandwidth = convertToMb(bandwidth);
				if (intBearer < 1024 || (bearer == '1Gb' && intBandwidth > 99)) {
					if (intBandwidth <= intBearer) {
						for (String term: terms) {
							for (String family: families) {
								Product2 prod = new Product2(
						    		Name = bandwidth + ' / ' + bearer + ' - ' + term + ' year',
						    		Bearer__c = bearer,
						    		Bandwidth__c = bandwidth,
						    		Term__c = term,
						    		Family = family,
						    		IsActive = true,
						    		lineProvider__c = 'Talktalk'
						    	);
						    	products2.add(prod);
							}
						}
					}
				}
			}
		}
		insert products2;
	}
	
	static private Integer convertToMb(String bandwidth)
	{
		String[] tokens = bandwidth.toLowerCase().splitByCharacterType();
		Integer multiplier = 1;
		if (tokens[1] == 'gb') {
			multiplier = 1024;
		}
		return Integer.valueOf(tokens[0]) * multiplier;
	}
	
	static public void deleteVirginProducts()
	{
		list<Product2> products = [SELECT Id FROM Product2 WHERE lineProvider__c = 'Virgin'];
		delete products;
	}
    
    static public void createVirginProducts()
	{
		//String[] bearers = new String[]{'10Mb', '100Mb', '1Gb'};
		//String[] bandwidths = new String[]{'2Mb', '4Mb', '6Mb', '8Mb', '10Mb', '20Mb', '30Mb', '40Mb', '50Mb', '60Mb', '70Mb', '80Mb', '90Mb', '100Mb', '200Mb', '300Mb', '400Mb', '500Mb', '600Mb', '700Mb', '800Mb', '900Mb', '1Gb'};
		//String[] terms = new String[]{'1', '2', '3', '4', '5'};
		String[] bearers = new String[]{'100Mb'};
		String[] bandwidths = new String[]{'10Mb'};
		String[] terms = new String[]{'3', '5'};
		String[] families = new String[]{'Installation Charges', 'Recurring Charges'};
		list<Product2> products2 = new list<Product2>();
		for (String bearer: bearers) {
			for (String bandwidth: bandwidths) {
				Integer intBearer = convertToMb(bearer);
				Integer intBandwidth = convertToMb(bandwidth);
				if (intBearer <= 10 || (bearer == '100Mb' && intBandwidth > 9) || (bearer == '1Gb' && intBandwidth > 99)) {
					if (intBandwidth <= intBearer) {
						for (String term: terms) {
							for (String family: families) {
								Product2 prod = new Product2(
						    		Name = bandwidth + ' / ' + bearer + ' - ' + term + ' year',
						    		Bearer__c = bearer,
						    		Bandwidth__c = bandwidth,
						    		Term__c = term,
						    		Family = family,
						    		IsActive = true,
						    		lineProvider__c = 'Virgin'
						    	);
						    	products2.add(prod);
							}
						}
					}
				}
			}
		}
		insert products2;
	}
}