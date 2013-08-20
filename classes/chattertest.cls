public class chattertest{
    
    public chattertest(){
		String sendersid = '005b0000000hjkf';
        String salesforceHost = System.Url.getSalesforceBaseURL().toExternalForm();
        String url =  salesforceHost + '/services/data/v28.0/chatter/users/me/messages?recipients=005b0000000hgqN&text=Your+prices+prices+have+arrived!';
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setEndpoint(url);
        req.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId());
    	Http http = new Http();
    	HttpResponse res = http.send(req);        
        system.debug(url);
        system.debug(res);
        
   } 
}