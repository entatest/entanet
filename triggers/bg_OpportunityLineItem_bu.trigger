trigger bg_OpportunityLineItem_bu on OpportunityLineItem (before update) {
	bg_OpportunityLineItem_Helper.setLineItemPrices(Trigger.new, Trigger.oldMap);
}