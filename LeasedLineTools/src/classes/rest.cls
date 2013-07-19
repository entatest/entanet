public class rest{
    public rest(){
    HttpRequest req = new HttpRequest();
    req.setEndpoint('http://sfgw.enta.net/rest/quotes');
    req.setMethod('GET');
    //send the request
    Http http = new Http();
    HttpResponse res = http.send(req);
    String xml = res.getBody();
    system.debug(xml);
        
        
    }
}