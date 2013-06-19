public class AdslLineChecker{
	
    public String xml {get; set;}
    protected String username = 'isaac@enta.net';
    protected String password = 'isaac12';
    protected String apiUrl = 'https://api.enta.net/xml/stable/ADSLChecker.php?';
    
    public String getXml(String telephoneNumber, String macCode){
        HttpRequest req = new HttpRequest();
         req.setEndpoint(apiUrl + 'PhoneNo=' + telephoneNumber + '&maccode=' + macCode);
         req.setMethod('GET');

         Blob headerValue = Blob.valueOf(username + ':' + password);
         String authorizationHeader = 'Basic ' +  EncodingUtil.base64Encode(headerValue);
         req.setHeader('Authorization', authorizationHeader);
       
         Http http = new Http();
         HTTPResponse res = http.send(req); 
         return res.getBody();
    }
}