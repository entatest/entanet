public class salesorder {

        public Quote quote;
        public String template { get; set; }

        public salesorder(ApexPages.StandardController controller) {
        this.quote = (Quote)controller.getRecord();
    }
    
    public PageReference createso(){
    return page.salesorderpdf;
    }

}