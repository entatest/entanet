public class sendEmail {
    public String body { get; set; }
    public String to { get; set; }
    public String subject { get; set; }

    private final Opportunity opportunity;
    
    public sendEmail(ApexPages.StandardController controller) {
        opportunity = [SELECT Id, Name FROM Opportunity WHERE Id = :ApexPages.currentPage().getParameters().get('id')];
        body = this.getQuotes();
    }
      
    public String getQuotes(){
        String oppId = opportunity.id;
        List<Quote> quo = [SELECT Id, Name, TotalPrice FROM Quote WHERE OpportunityId=:oppId AND IncludeInSummary__c=true];
        body = 'Dear Sir/Madam\n\nPlease see attached your quotes for ';
        
        for(Quote q : quo){
            body = body+q.Name+' priced at '+q.TotalPrice+', ';
        }
        
        body = body+'\n\nKind Regards,\n\nEnta';
        return body;
    }
    
    public PageReference send() {
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {to};
        
        String oppId = opportunity.id;
        email.setSubject( subject );
        email.setPlainTextBody( body );
        email.setToAddresses( toAddresses );
        Messaging.SendEmailResult [] r = 
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});   
        
        return new PageReference('/apex/success');
    }
}