//
//  TwitterAuthViewController.h
//
//  Created by Ming Yang on 4/28/12.
//

#import <UIKit/UIKit.h>
#import "MYTwitterEngine.h"
#import "ModalWebViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface TwitterAuthViewController : UIViewController <MYTwitterEngineAuthDelegate> {
    IBOutlet UITextField* pinField;
    IBOutlet UIButton* btnRequestForPin;
    IBOutlet UIBarButtonItem* btnDone;
    IBOutlet UIBarButtonItem* btnCancel;
    MYTwitterEngine* twitterEngine;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil twitterEngine:(MYTwitterEngine*)_twitterEngine;
- (IBAction)btnRequestForPinPressed:(id)sender;
- (IBAction)btnCancelPressed:(id)sender;
- (IBAction)btnDonePressed:(id)sender;

@property (nonatomic, retain) IBOutlet UITextField* pinField;
@property (nonatomic, retain) IBOutlet UIButton* btnRequestForPin;
@property (nonatomic, retain) IBOutlet UIBarButtonItem* btnDone;
@property (nonatomic, retain) IBOutlet UIBarButtonItem* btnCancel;


@end
