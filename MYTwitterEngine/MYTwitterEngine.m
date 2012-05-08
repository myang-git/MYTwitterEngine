//
//  MYTwitterEngine.m
//
//  Created by Ming Yang on 4/26/12.
//

#import "MYTwitterEngine.h"

@implementation MYTwitterEngine
@synthesize authDelegate;
@synthesize apiDelegate;


- (id)init {
    if (self = [super init]) {
        consumer = [[OAConsumer alloc] initWithKey:TWITTER_CONSUMER_KEY secret:TWITTER_CONSUMER_SECRET];
        requestToken = nil;

        NSDictionary* dic = [[NSUserDefaults standardUserDefaults] dictionaryForKey:USER_DEFAULT_KEY_FOR_TOKEN];
        if (dic!=nil) {
            NSString* key = [dic valueForKey:@"key"];
            NSString* secret = [dic valueForKey:@"secret"];
            NSString* session = [dic valueForKey:@"session"];
            NSDate* created = [dic valueForKey:@"created"];
            NSNumber* duration = [dic valueForKey:@"duration"];
            NSNumber* renewable = [dic valueForKey:@"renewable"];
            NSDictionary* attrs = [dic valueForKey:@"attributes"];
            
            accessToken = [[OAToken alloc] initWithKey:key 
                                                secret:secret 
                                               session:session 
                                              duration:duration 
                                            attributes:attrs 
                                               created:created 
                                             renewable:renewable.boolValue];
        }
        else {
            accessToken = nil;
        }
        
    }
    return self;
}

- (void)auth {
    [self authWithURL:TWITTER_REQUEST_TOKEN_URL
             authToken:nil 
             verifier:nil 
    didFinishSelector:@selector(requestTokenTicket:didFinishWithData:) 
      didFailSelector:@selector(requestTokenTicket:didFailWithError:)];
}

- (void)logout {
    if (accessToken!=nil) {
        [accessToken release];
        accessToken = nil;
    }
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_DEFAULT_KEY_FOR_TOKEN];
}

- (void)post:(NSString*)status {
    NSURL* statusUpdateUrl = [NSURL URLWithString:TWITTER_API_STATUS_UPDATE];
    OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:statusUpdateUrl
                                                                   consumer:consumer
                                                                      token:accessToken
                                                                      realm:nil
                                                          signatureProvider:[[[OAHMAC_SHA1SignatureProvider alloc] init] autorelease]];
    [request setHTTPMethod:@"POST"];
    
    OARequestParameter *statusParam = [[OARequestParameter alloc] initWithName:@"status"
                                                                         value:status];
    NSArray *params = [NSArray arrayWithObjects:statusParam, nil];
    [request setParameters:params];
    
    OADataFetcher *fetcher = [[OADataFetcher alloc] init];
    [fetcher fetchDataWithRequest:request
                         delegate:self
                didFinishSelector:@selector(apiTicket:didFinishWithData:)
                  didFailSelector:@selector(apiTicket:didFailWithError:)];
    
    [statusParam release];
    [fetcher release];
    [request release];
}

- (void)post:(NSString*)status withImage:(NSData*)imageData {
    NSURL* statusUpdateUrl = [NSURL URLWithString:TWITTER_API_STATUS_UPDATE_WITH_MEDIA];
    OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:statusUpdateUrl
                                                                   consumer:consumer
                                                                      token:accessToken
                                                                      realm:nil
                                                          signatureProvider:[[[OAHMAC_SHA1SignatureProvider alloc] init] autorelease]];
    [request setHTTPMethod:@"POST"];
    MultipartBuilder* builder = [[MultipartBuilder alloc] init];
    [request setValue:builder.contentType forHTTPHeaderField:@"content-type"];
    
    [builder addData:imageData withFilename:@"file_name" forName:@"media_data[]"];
    [builder addValue:status forName:@"status"];
    
    [request prepare];
    
    [request setHTTPBody:builder.body];
    
    OADataFetcher *fetcher = [[OADataFetcher alloc] init];
    [fetcher fetchDataWithRequest:request
                         delegate:self
                didFinishSelector:@selector(apiTicket:didFinishWithData:)
                  didFailSelector:@selector(apiTicket:didFailWithError:)];
    
    [builder release];
    [request release];
}

- (void)authWithURL:(NSString*)url 
          authToken:(OAToken*)token 
           verifier:(NSString*)verifier 
  didFinishSelector:(SEL)didFinishSelector 
    didFailSelector:(SEL)didFailSelector {
    
    NSURL* _url = [NSURL URLWithString:url];
    OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:_url
                                                                   consumer:consumer
                                                                      token:token
                                                                      realm:nil
                                                          signatureProvider:nil];
    
    [request setHTTPMethod:@"POST"];
    
    OADataFetcher *fetcher = [[OADataFetcher alloc] init];
    
    [fetcher fetchDataWithRequest:request
                         delegate:self
                didFinishSelector:didFinishSelector
                  didFailSelector:didFailSelector];    
    
    [fetcher release];
}

- (OAToken*)createTokenFromData:(NSData*)data {
    NSString *responseBody = [[NSString alloc] initWithData:data
                                                   encoding:NSUTF8StringEncoding];
    OAToken* token = [[OAToken alloc] initWithHTTPResponseBody:responseBody];
    [responseBody release];
    return token;
}

- (void)requestTokenTicket:(OAServiceTicket*)ticket didFinishWithData:(NSData*)data {
    if (ticket.didSucceed) {
        requestToken = [self createTokenFromData:data];
        NSString* authorizeURLString = [NSString stringWithFormat:@"%@?oauth_token=%@", TWITTER_AUTHORIZE_URL, requestToken.key];
        NSURL* authorizeURL = [NSURL URLWithString:authorizeURLString];
        [authDelegate showAuthWebViewWithURL:authorizeURL];
    }
    else {
        NSString* responseBody = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
        NSDictionary* userInfo = [NSDictionary dictionaryWithObjectsAndKeys:responseBody, NSLocalizedDescriptionKey, nil];
        NSError* error = [NSError errorWithDomain:@"MYTwitterEngine" code:-1 userInfo:userInfo];
        [authDelegate permissionRejectedWithError:error];
    }
}

- (void)requestTokenTicket:(OAServiceTicket*)ticket didFailWithError:(NSError*)error {
    [authDelegate permissionRejectedWithError:error];
}

- (void)proceedWithPin:(NSString *)pin {
    [self authWithURL:TWITTER_ACCESS_TOKEN_URL
            authToken:requestToken 
                   verifier:pin 
          didFinishSelector:@selector(authorizeTokenTicket:didFinishWithData:) 
            didFailSelector:@selector(authorizeTokenTicket:didFailWithError:)];
}

- (void)saveAccessToken:(OAToken*)token {
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    [dic setValue:token.key forKey:@"key"];
    [dic setValue:token.secret forKey:@"secret"];
    [dic setValue:token.session forKey:@"session"];
    [dic setValue:token.created forKey:@"created"];
    [dic setValue:token.duration forKey:@"duration"];
    [dic setValue:[NSNumber numberWithBool:token.isRenewable] forKey:@"renewable"];
    [dic setValue:token.attributes forKey:@"attributes"];
    [[NSUserDefaults standardUserDefaults] setObject:dic forKey:USER_DEFAULT_KEY_FOR_TOKEN];
    
}

- (BOOL)isSessionValid {
    return accessToken!=nil;
}

- (void)authorizeTokenTicket:(OAServiceTicket*)ticket didFinishWithData:(NSData*)data {
    if (ticket.didSucceed) {
        accessToken = [self createTokenFromData:data];
        [authDelegate permissionGrantedWithKey:accessToken.key 
                                        secret:accessToken.secret 
                                       session:accessToken.session 
                                       created:nil
                                      duration:accessToken.duration 
                                     renewable:accessToken.isRenewable 
                                    attributes:accessToken.attributes];
        [self saveAccessToken:accessToken];
    }
    else {
        NSString* responseBody = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
        NSError* error = [NSError errorWithDomain:responseBody code:0 userInfo:nil];
        [authDelegate permissionRejectedWithError:error];
    }
    [requestToken release];
    requestToken = nil;
}

- (void)authorizeTokenTicket:(OAServiceTicket*)ticket didFailWithError:(NSError*)error {
    [requestToken release];
    requestToken = nil;
    [authDelegate permissionRejectedWithError:error];
}

#pragma mark - API callbacks

- (void)apiTicket:(OAServiceTicket*)ticket didFinishWithData:(NSData*)data {
    if (ticket.didSucceed) {
        if ([apiDelegate respondsToSelector:@selector(apiCall:didFinishWithResponse:)]) {
            NSString* response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            [apiDelegate apiCall:ticket.request.URL didFinishWithResponse:response];
        }
    }
    else {
        NSString* response = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
        NSDictionary* userInfo = [NSDictionary dictionaryWithObjectsAndKeys:response, NSLocalizedDescriptionKey, nil];
        NSError* error = [NSError errorWithDomain:@"MYTwitterEngine" code:-1 userInfo:userInfo];
        [self apiTicket:ticket didFailWithError:error];
    }
}

- (void)apiTicket:(OAServiceTicket*)ticket didFailWithError:(NSError*)error {
    if ([apiDelegate respondsToSelector:@selector(apiCall:didFailWithError:)]) {
        [apiDelegate apiCall:ticket.request.URL didFailWithError:error];
    }
}
    


- (void)dealloc {
    [consumer release];
    if (accessToken) {
        [accessToken release];
        accessToken = nil;
    }
    if (requestToken) {
        [requestToken release];
        requestToken = nil;
    }
    [super dealloc];
}

@end
