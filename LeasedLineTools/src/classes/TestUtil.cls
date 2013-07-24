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
		List<Product2> products2 = new List<Product2>();
		for (String bearer: bearers) {
			for (String bandwidth: bandwidths) {
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
		insert products2;
	}
}