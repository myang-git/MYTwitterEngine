//
//  ViewController.h
//  MYTwitterEngineDemo
//
//  Created by Ming Yang on 5/5/12.
//

#import <UIKit/UIKit.h>
#import "MYTwitterEngine.h"
#import "TwitterAuthViewController.h"

@interface ViewController : UIViewController <MYTwitterEngineAPIDelegate> {
    IBOutlet UIButton* btnSignIn;
    IBOutlet UIView* tweetView;
    IBOutlet UIButton* btnTweet;
    IBOutlet UITextView* textView;
    MYTwitterEngine* twitterEngine;
}

- (IBAction)btnSignInPressed:(id)sender;
- (IBAction)btnTweetPressed:(id)sender;

@property (nonatomic, retain) IBOutlet UIButton* btnSignIn;
@property (nonatomic, retain) IBOutlet UIView* tweetView;
@property (nonatomic, retain) IBOutlet UIButton* btnTweet;
@property (nonatomic, retain) IBOutlet UITextView* textView;


@end
