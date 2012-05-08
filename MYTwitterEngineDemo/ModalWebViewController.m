//
//  ModalWebViewController.m
//
//  Created by Ming Yang on 4/28/12.
//

#import "ModalWebViewController.h"

@interface ModalWebViewController ()

@end

@implementation ModalWebViewController

@synthesize webView;
@synthesize btnDismiss;
@synthesize urlRequest;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = self.btnDismiss;
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewDidAppear:(BOOL)animated {
    [self.webView loadRequest:self.urlRequest];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Actions

- (IBAction)btnDismissPressed:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)dealloc {
    [webView release];
    [btnDismiss release];
    [urlRequest release];
    [super dealloc];
}

@end
