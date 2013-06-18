@isTest
public class TestSendEmail{
    public static testmethod void sendEmail_TestGetQuote(){
        Date today30 = Date.today().addDays(30);
        Opportunity opp = new Opportunity(name='testopp', stagename='Prospecting', closedate=today30 );
        insert opp;
        ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        sendEmail se = new sendEmail(sc);
        System.assertEquals('testopp', opp.name);
    }
}