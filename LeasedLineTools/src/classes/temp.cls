public class temp{
    public temp(){
        /**
		//FeedItem post = new FeedItem();
		//post.ParentId = '005b0000000hjkfAAA';
		//post.Body = '@Lee Savage If this works im gonna be angry'; // And i was... super simple :D
		//post.createdById = '005b0000000hjkfAAA';
		//insert post;
        String salesforceHost = System.Url.getSalesforceBaseURL().toExternalForm();
        
		String url =  salesforceHost + '/services/data/v23.0/chatter/feeds/record/' + RecordId + '/feed-items';
            
		HttpRequest req = new HttpRequest();
            
		req.setMethod('POST');
		req.setEndpoint(url);
		req.setHeader('Content-type', 'application/json');
		req.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId());
            
		req.setBody('{ "body" : { "messageSegments" : [ { "type": "mention", "id" : "' + UserId + '" }, { "type": "text",  "text" : "' + ' ' + chatterAlert +  '" } ] } }');
		Http http = new Http();
  
		HTTPResponse res = http.send(req);

------------------------------------------------------------------------
**/
        /**
        //Create FeedItemInput to hold message body and @mentions//
        ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();    
        
        //Create MessageBodyInput (child of FeedItemInput) to hold message segments
        feedItemInput.body = new ConnectApi.MessageBodyInput();        
        
        //Create text segment to hold message body//
        ConnectApi.TextSegmentInput textSegment = new ConnectApi.TextSegmentInput();
        textSegment.text = 'Blah Blah';
        //Add body to message segment//
        segments.add(textSegment); 
        
        //Create mention segment to hold an @mention//
        ConnectApi.MentionSegmentInput mention = new ConnectApi.MentionSegmentInput();
        mention.id = 'Lee Savage';
        //Add mention to message segment//
        segments.add(mention);

        //Assign created segments to the messageBodyInput, then assign that to the be the feedItemInput's body//
        feedItemInput.body.messageSegments = segments;

        //FeedType//
        ConnectApi.FeedType feedType = ConnectAPI.FeedType.RECORD;

        //Create FeedItemPost//
        ConnectApi.ChatterFeeds.postFeedItem(null, feedType, 'me', feedItemInput, null);  
		
        **/
        /**
String salesforceHost = System.Url.getSalesforceBaseURL().toExternalForm();
        
String url =  salesforceHost + '/services/data/v23.0/chatter/feeds/record/005b0000000hjkfAAA/feed-items';
            
HttpRequest req = new HttpRequest();
            
req.setMethod('POST');
req.setEndpoint(url);
req.setHeader('Content-type', 'application/json');
req.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId());
            
req.setBody('{ "body" : { "messageSegments" : [ { "type": "mention", "id" : "005b0000000hjkfAAA" }, { "type": "text",  "text" : "test text" } ] } }');
Http http = new Http();
  
HTTPResponse res = http.send(req);   
**/

String communityId = null;
ConnectApi.FeedType feedType = ConnectApi.FeedType.UserProfile;
String userToMention = '005b0000000hgqlAAA';
String subjectId = '005b0000000hgr5AAA';

ConnectApi.MessageBodyInput messageInput = new ConnectApi.MessageBodyInput();
messageInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();

ConnectApi.TextSegmentInput textSegment = new ConnectApi.TextSegmentInput();
textSegment.text = 'Hey there ';
messageInput.messageSegments.add(textSegment);

ConnectApi.MentionSegmentInput mentionSegment = new ConnectApi.MentionSegmentInput();
mentionSegment.id = userToMention;
messageInput.messageSegments.add(mentionSegment);

textSegment = new ConnectApi.TextSegmentInput();
textSegment.text = '. How are you?';
messageInput.messageSegments.add(textSegment);

ConnectApi.FeedItemInput input = new ConnectApi.FeedItemInput();
input.body = messageInput;

ConnectApi.FeedItem feedItemRep = ConnectApi.ChatterFeeds.postFeedItem(communityId, feedType, subjectId, input, null);        
        
    }
}