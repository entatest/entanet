public class ToidLookup{
   public String basicAuthCallout(){
     HttpRequest req = new HttpRequest();
     req.setEndpoint('http://www.enta.net/feed.xml');
     req.setMethod('GET');

     // Create a new http object to send the request object
     // A response object is generated as a result of the request  
  
     Http http = new Http();
     HTTPResponse res = http.send(req);
     // System.debug(res.getBody());
       return res.getBody();
   }
    public String getXml() {
        return basicAuthCallout();
    }
}