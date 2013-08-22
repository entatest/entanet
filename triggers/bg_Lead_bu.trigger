trigger bg_Lead_bu on Lead (before update) {
	bg_Lead_Helper.setDefaultReasonForClosure(Trigger.New);
}