trigger bg_Lead_bi on Lead (before insert) {
	bg_Lead_Helper.matchLead(Trigger.new);
}