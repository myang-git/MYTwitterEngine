//
//  ViewController.m
//  MYTwitterEngineDemo
//
//  Created by Ming Yang on 5/5/12.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize btnSignIn;
@synthesize btnTweet;
@synthesize tweetView;
@synthesize textView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"MYTwitterEngine Demo";
    twitterEngine = [[MYTwitterEngine alloc] init];
    [twitterEngine logout];
    twitterEngine.apiDelegate = self;
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewWillAppear:(BOOL)animated {
    [self setTweetViewVisible:twitterEngine.isSessionValid];
}

- (void)setTweetViewVisible:(BOOL)visible {
    tweetView.hidden = !visible;
    btnSignIn.hidden = visible;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Tweeter Engine

- (void)apiCall:(NSURL *)url didFailWithError:(NSError *)error {
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Unable to send tweet" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [alert release];
}

- (void)apiCall:(NSURL *)url didFinishWithResponse:(NSString *)response {
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Demo" message:@"Tweet sent" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [alert release];
}

#pragma mark - Actions

- (IBAction)btnSignInPressed:(id)sender {
    TwitterAuthViewController* vc = [[TwitterAuthViewController alloc] initWithNibName:@"TwitterAuthView" bundle:nil twitterEngine:twitterEngine];
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

- (IBAction)btnTweetPressed:(id)sender {
    NSString* message = textView.text;
    [twitterEngine post:message];
}

- (void)dealloc {
    [twitterEngine release];
    [btnSignIn release];
    [btnTweet release];
    [textView release];
    [tweetView release];
    [super dealloc];
}

@end
