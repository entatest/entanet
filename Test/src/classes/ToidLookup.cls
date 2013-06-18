public class ToidLookup{
    public ToidLookup(){
        getXml();
    }
   public String basicAuthCallout(){
     Http http = new Http();
     HttpRequest req = new HttpRequest();
     req.setMethod('GET');
     req.setEndpoint('https://api.enta.net/xml/beta/ADSLChecker.php?phoneno=01743242874');

     // Create a new http object to send the request object
     // A response object is generated as a result of the request  
  
         String username = 'testjohnsf';
         String password = 'salesforcerocks';
      
         Blob headerValue = Blob.valueOf(username + ':' + password);
         String authorizationHeader = 'Basic ' +  EncodingUtil.base64Encode(headerValue);
         req.setHeader('Authorization', authorizationHeader);
       
       System.debug('sending request...');
     HTTPResponse res = http.send(req);
      System.debug('uuuuu' + req.getHeader('Authorization'));
      System.debug('uuuuu' + res.getStatusCode());
      System.debug('zzzzzzz' + res.getBody());
       return res.getBody();
   }
    public String getXml() {
        return basicAuthCallout();
    }
}