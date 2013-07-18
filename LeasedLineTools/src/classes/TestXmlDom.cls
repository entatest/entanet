@isTest
private class TestXmlDom
{
    private static String xmlTestString = '<xml><node><value>7</value></node><secondNode><value type=\'int\'>Nineteen</value></secondNode></xml>';
    private static String xmlNodeList = '<xml><cheeses><cheese><name>Gouda</name></cheese><cheese><name>Brie</name></cheese><cheese><name>Edam</name></cheese></cheeses></xml>';
    private static String xmlChildList = '<xml><children><child type=\"son\"><name>Dennis</name></child><child type=\"daughter\"><name>Denise</name></child></children></xml>';
        
    @isTest static void canGetElementValue()
    {
    	XMLDom dom = new XMLDom(xmlTestString);
    	XMLDom.Element testXmlNode = dom.getElementByTagName('node');
    	String testValue = testXmlNode.getValue('value');
    	System.assertEquals('7', testValue);
    }
    
    @isTest static void canGetElementAttribute()
    {
    	XMLDom dom = new XMLDom(xmlTestString);
    	XMLDom.Element testXmlNode = dom.getElementByTagName('secondNode');
    	XMLDom.Element testNode = testXmlNode.getElementByTagName('value');
    	String testAttribute = testNode.getAttribute('type');
    	System.assertEquals('int', testAttribute);
    }
    
    @isTest static void canGetNodeList()
    {
    	XMLDom dom = new XMLDom(xmlNodeList);
    	List<XMLDom.Element> cheeses = dom.getElementsByTagName('cheese');
    	System.assertEquals(3, cheeses.size());
    }
    
    @isTest static void canRemoveChild()
    {
    	XMLDom.element targetChild;
    	XMLDom dom = new XMLDom(xmlChildList);
    	XMLDom.Element childList = dom.getElementByTagName('children'); 
    	List<XMLDom.Element> allChildren = childList.getElementsByTagName('child');
    	System.assertEquals(2, allChildren.size());
    	for (XMLDom.Element child : allChildren) {
    		if (child.getAttribute('type') == 'son') {
    			 targetChild = child;
    		}
    	}
    	childList.removeChild(targetChild);
    	allChildren = childList.getElementsByTagName('child');
    	System.assertEquals(1, allChildren.size());
    }
    
    @isTest static void canConvertToString()
    {
    	XMLDom dom = new XMLDom(xmlTestString);
    	XMLDom.Element testElement = dom.getElementByTagName('xml');
    	System.assertEquals(xmlTestString, testElement.toXmlString().replace('\n', '').replace(' >', '>'));
    	
    	System.assertEquals('<#document>' + xmlTestString + '</#document>', dom.toXmlString().replace('\n', '').replace(' >', '>'));
    }
    
    @isTest static void canGetChildNodeUtilities()
    {
    	XMLDom.element targetChild;
    	XMLDom dom = new XMLDom(xmlChildList);
    	XMLDom.Element childList = dom.GetElementByTagName('children');
    	
    	System.assertEquals(true, childList.hasChildNodes());
    	
    	XMLDom.Element firstChild = childList.firstChild();
  		
    	List<XMLDom.Element> allChildren = childList.getElementsByTagName('child');
    	for (XMLDom.Element child : allChildren) {
    		if (child.getAttribute('type') == 'son') {
    			 targetChild = child;
    		}
    	}
    	System.assertEquals(targetChild, firstChild);
    }
    
    @isTest static void testMiscellaneousUtilities()
    {
    	XMLDom dom = new XMLDom(xmlTestString);
    	XMLDom.Element testElement = dom.getElementByTagName('xml');
    	XMLDom.Element clonedNode = testElement.cloneNode();
    	System.assert(testElement.isEqualNode(clonedNode));
    	
    	XMLDom.Element textTag = testElement.getElementByTagName('secondNode').getElementByTagName('value');
    	System.assertEquals('Nineteen', textTag.textContent());
    	System.assert(textTag.hasAttributes());
    	
    	System.assertEquals('/xml/secondNode/value', textTag.path());
    	
    	XMLDom.Element ownerDoc = textTag.ownerDocument();
    	System.assertEquals('#document', ownerDoc.nodeName);
    	
    	System.assertEquals('#document', dom.ownerDocument().nodeName);
    }
    
    @isTest static void testFindByPath()
    {
    	XMLDom dom = new XMLDom(xmlTestString);
    	string path = '/xml/secondNode';
    	XMLDom.Element testElement = dom.getElementByTagName('xml');
    	List<XMLDom.Element> testResult = testElement.getElementsByPath(path);
    	
    	System.assertEquals(1, testResult.size());
    	for(XMLDom.Element tempTest: testResult) {
    		System.assertEquals('secondNode', tempTest.nodeName);
    	}
    }
    
    @isTest static void testSameNodeComparison()
    {
    	XMLDom dom = new XMLDom(xmlTestString);
    	XMLDom.Element testElement = dom.getElementByTagName('secondNode');
    	XMLDom.Element testElementClone = dom.getElementByTagName('secondNode');
    	
    	System.assert(testElement.isSameNode(testElementClone));
    }
}