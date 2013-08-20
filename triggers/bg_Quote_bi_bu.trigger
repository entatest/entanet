trigger bg_Quote_bi_bu on Quote (before insert, before update) {
	bg_Quote_Helper.setExpirationDate(Trigger.new);
}