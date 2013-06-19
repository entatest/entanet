public class LookupProduct {

	Opportunity oppo = [SELECT Id, Name, Pricebook2Id FROM Opportunity WHERE Name='Disco' limit 3];

}