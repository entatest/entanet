public class productManager{
    public String price;
    public String name;
    
    public String json { 
        get{ return json; }
        set{ json = ''; } 
    }
    
    public productManager() {
     	system.debug('halo');
        this.parse();
        //Product2 p = new Product2(name = 'copper'); 
        //Product2 p = [SELECT Name FROM Product2 WHERE Name = 'copper3'];
        //p.Name = 'copper3';
        //update p;
    }
        
    public void parse() {
        String JSONContent = '{"name":"zinc","price":"20"}';
        JSONParser parser = system.JSON.createParser(JSONContent);
        parser.nextToken();
        parser.nextValue();
        system.debug(parser.getCurrentName());
        system.debug(parser.getText());
    }
}