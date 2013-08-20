public class sendCRFEmail {
    public Opportunity oppt;
    public String restURL;
    
    public string setURL{get{
    return oppt.CRF_URL__c;}}
    
    public sendCRFEmail(ApexPages.StandardController controller) {
        oppt = [SELECT Id, Name, CRF_URL__c FROM Opportunity WHERE Id = :ApexPages.currentPage().getParameters().get('id')];
        restURL = 'http://sfgw.enta.net/rest/crfurl';
    }
        
    public string getURLFromAPI() {
        HttpRequest req = new HttpRequest();
        req.setEndpoint(restURL + '?opportunityId=' + oppt.Id);
        req.setMethod('GET');

        //send the request
        Http http = new Http();
        HttpResponse res = http.send(req);
        String url = res.getBody();
        return url;
    }
    
    public string createCrfByAPI() {
        oppt = [SELECT Id, Name, CRF_URL__c, Account.Id, Account.Name, Account.BillingStreet, Account.BillingCity, Account.BillingState, Account.BillingPostalCode FROM Opportunity WHERE Id = :ApexPages.currentPage().getParameters().get('id')];
        contact contact = [SELECT Salutation, Firstname, Lastname, Email, Phone FROM Contact WHERE AccountId =: oppt.Account.Id];
        String xml = '<CrfUrl>';
        xml += '<Request>';
        xml += '    <OpportunityId>' + oppt.Id + '</OpportunityId>';
        xml += '    <Fields>';
        xml += '        <Title>' + contact.Salutation + '</Title>';
        xml += '        <Firstname>' + contact.Firstname + '</Firstname>';
        xml += '        <Surname>' + contact.Lastname + '</Surname>';
        xml += '        <CompanyName>' + oppt.Account.Name + '</CompanyName>';
        xml += '        <ContactTel>' + contact.Phone + '</ContactTel>';
        xml += '        <ContactEmail>' + contact.Email + '</ContactEmail>';
        xml += '        <Street>' + oppt.Account.BillingStreet + '</Street>';
        xml += '        <Town>' + oppt.Account.BillingCity + '</Town>';
        xml += '        <County>' + oppt.Account.BillingState + '</County>';
        xml += '        <Postcode>' + oppt.Account.BillingPostalCode + '</Postcode>';
        xml += '    </Fields>';
        xml += '</Request>';
        xml += '</CrfUrl>';
        HttpRequest req = new HttpRequest();
        req.setEndpoint(restURL);
        req.setMethod('POST');
        req.setBody(xml);

        //send the request
        Http http = new Http();
        HttpResponse res = http.send(req);
        
        return this.getURLFromAPI();
    }
    
    public void sendEmail() {

    }
    
    public void setURL() {
        if (String.isEmpty(oppt.CRF_URL__c)) {
            oppt.CRF_URL__c = this.getURLFromAPI();
            Database.Update(oppt);
        }
    }
    
    public void postURL() {
        if (String.isEmpty(oppt.CRF_URL__c)) {
            oppt.CRF_URL__c = this.createCrfByAPI();
            Database.Update(oppt);
        }
    }
    
    public void clearURL() {
        oppt.CRF_URL__c = '';
        update oppt;
    }
}