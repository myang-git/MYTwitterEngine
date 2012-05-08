//
//  TwitterAuthViewController.m
//
//  Created by Ming Yang on 4/28/12.
//

#import "TwitterAuthViewController.h"

@interface TwitterAuthViewController ()

@end

@implementation TwitterAuthViewController

@synthesize pinField;
@synthesize btnRequestForPin;
@synthesize btnDone;
@synthesize btnCancel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil twitterEngine:(MYTwitterEngine*)_twitterEngine
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        twitterEngine = _twitterEngine;
        twitterEngine.authDelegate = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = self.btnCancel;
    self.navigationItem.rightBarButtonItem = self.btnDone;
    self.pinField.layer.cornerRadius = 12;
    self.pinField.layer.borderWidth = 1;
    self.pinField.layer.borderColor = [UIColor darkGrayColor].CGColor;
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Twitter engine 

- (void)showAuthWebViewWithURL:(NSURL*)authURL {
    NSURLRequest* request = [NSURLRequest requestWithURL:authURL];
    ModalWebViewController* vc = [[ModalWebViewController alloc] initWithNibName:@"ModalWebView" bundle:nil];
    vc.urlRequest = request;
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [vc release];
    [self.navigationController presentModalViewController:nav animated:YES];
}

- (void)permissionRejectedWithError:(NSError *)error {
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" 
                                                    message:error.description 
                                                   delegate:nil 
                                          cancelButtonTitle:@"Dismiss" 
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}

- (void)permissionGrantedWithKey:(NSString *)key 
                          secret:(NSString *)secret 
                         session:(NSString *)session 
                         created:(NSDate *)created 
                        duration:(NSNumber *)duration 
                       renewable:(BOOL)renewable 
                      attributes:(NSDictionary *)atttributes {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Actions

- (IBAction)btnRequestForPinPressed:(id)sender {
    [twitterEngine auth];
}

- (IBAction)btnDonePressed:(id)sender {
    [twitterEngine proceedWithPin:self.pinField.text];
}

- (IBAction)btnCancelPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc {
    twitterEngine.authDelegate = nil;
    [btnDone release];
    [btnCancel release];
    [btnRequestForPin release];
    [pinField release];
    [super dealloc];
}

@end
