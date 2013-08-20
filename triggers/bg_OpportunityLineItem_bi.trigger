trigger bg_OpportunityLineItem_bi on OpportunityLineItem (before insert) {
	bg_OpportunityLineItem_Helper.setFixedPriceLineItemPrices(Trigger.new);
}