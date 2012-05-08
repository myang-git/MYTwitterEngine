//
//  MYTwitterEngine.h
//
//  Created by Ming Yang on 4/26/12.
//

#import <Foundation/Foundation.h>
#import "OAuthConsumer.h"
#import "MultipartBuilder.h"


static NSString* const TWITTER_CONSUMER_KEY = @"YOUR_TWITTER_CONSUMER_KEY";
static NSString* const TWITTER_CONSUMER_SECRET = @"YOUR_TWITTER_CONSUMER_SECRET";


static NSString* const TWITTER_REQUEST_TOKEN_URL = @"https://api.twitter.com/oauth/request_token";
static NSString* const TWITTER_AUTHORIZE_URL = @"https://api.twitter.com/oauth/authorize";
static NSString* const TWITTER_ACCESS_TOKEN_URL = @"https://api.twitter.com/oauth/access_token";
static NSString* const USER_DEFAULT_KEY_FOR_TOKEN = @"MYTwitterEngineDelegateTokenKey";

static NSString* const TWITTER_API_STATUS_UPDATE = @"https://api.twitter.com/1/statuses/update.json"; 
static NSString* const TWITTER_API_STATUS_UPDATE_WITH_MEDIA = @"https://upload.twitter.com/1/statuses/update_with_media.json";

@protocol MYTwitterEngineAuthDelegate;
@protocol MYTwitterEngineAPIDelegate;

@interface MYTwitterEngine : NSObject {
    OAConsumer* consumer;
    OAToken* requestToken;
    OAToken* accessToken;
    id<MYTwitterEngineAuthDelegate> authDelegate;
    id<MYTwitterEngineAPIDelegate> apiDelegate;
}

- (void)auth;
- (void)logout;
- (void)proceedWithPin:(NSString*)pin;
- (void)post:(NSString*)status;
- (void)post:(NSString*)status withImage:(NSData*)imageData;

@property (nonatomic, retain) id<MYTwitterEngineAPIDelegate> apiDelegate;
@property (nonatomic, retain) id<MYTwitterEngineAuthDelegate> authDelegate;
@property (nonatomic, readonly) BOOL isSessionValid;

@end

@protocol MYTwitterEngineAuthDelegate <NSObject>

- (void)showAuthWebViewWithURL:(NSURL*)authURL;

- (void)permissionGrantedWithKey:(NSString*)key 
                          secret:(NSString*)secret 
                         session:(NSString*)session 
                         created:(NSDate*)created
                        duration:(NSNumber*)duration
                       renewable:(BOOL)renewable
                      attributes:(NSDictionary*)atttributes;

- (void)permissionRejectedWithError:(NSError*)error;

@end

@protocol MYTwitterEngineAPIDelegate <NSObject>

- (void)apiCall:(NSURL*)url didFinishWithResponse:(NSString*)response;

- (void)apiCall:(NSURL*)url didFailWithError:(NSError*)error;

@end
