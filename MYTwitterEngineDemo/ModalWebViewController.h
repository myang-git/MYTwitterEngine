//
//  ModalWebViewController.h
//
//  Created by Ming Yang on 4/28/12.
//

#import <UIKit/UIKit.h>

@interface ModalWebViewController : UIViewController {
    IBOutlet UIWebView* webView;
    IBOutlet UIBarButtonItem* btnDismiss;
    NSURLRequest* urlRequest;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;
- (IBAction)btnDismissPressed:(id)sender;

@property (nonatomic, retain) IBOutlet UIWebView* webView;
@property (nonatomic, retain) IBOutlet UIBarButtonItem* btnDismiss;
@property (nonatomic, retain) NSURLRequest* urlRequest;

@end
