//
//  PlayBackViewController.m
//  ScreenCaptureViewTest
//
//  Created by Rahul Nair on 21/01/13.
//
//

#import "PlayBackViewController.h"
#import "CCFScreenRecorderConsts.h"


@interface PlayBackViewController ()

@end

@implementation PlayBackViewController{
    NSString *docaPathFull;
}
@synthesize DismissView;
@synthesize player = _player;


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
    NSLog(@"----------- adsdasd ");

    NSString *docPath = [NSSearchPathForDirectoriesInDomains
                         (NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    docaPathFull = [[NSString alloc] initWithString:[docPath stringByAppendingPathComponent:@"/output.mov"]];
//    docaPathFull = [docPath stringByAppendingPathComponent:@"/output.mov"];
    
    NSLog(@"--path %@",docaPathFull);
//    NSURL *nurl = [NSURL fileURLWithPath:@"file://localhost/Users/rahul/Library/Application%20Support/iPhone%20Simulator/6.0/Applications/439E5299-848F-40D6-8499-DEAF8A12BD3E/Documents/output.mp4"];
    NSURL *nurl = [NSURL fileURLWithPath:docaPathFull];

     _player = [[MPMoviePlayerController alloc]initWithContentURL:nurl];
    [_player.view setFrame: CGRectMake(5,60 , self.view.frame.size.width-10,  self.view.frame.size.height-200)];
     [_player prepareToPlay];
    _player.controlStyle = MPMovieControlStyleDefault;
    _player.movieSourceType = MPMovieSourceTypeFile;
    
    [self.view addSubview: _player.view];
    [_player play];
  
//    CustomGesture *gesture = [[CustomGesture alloc]initWithTarget:self action:@selector(rightSwipe)];
//    [self.view addGestureRecognizer:gesture];
//    [gesture release];
    
    
//    UISwipeGestureRecognizer *swipegesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(rightSwipe)];
//    
//    [swipegesture setDirection:UISwipeGestureRecognizerDirectionRight];
//    [self.view addGestureRecognizer:swipegesture];
//    [swipegesture release];
    
    
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}


-(void)rightSwipe{
    NSLog(@"------------- sfafgdgashsdfgjk");

}



- (void)dealloc {
    [DismissView release];
    [_sendButton release];
    [_headerView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setDismissView:nil];
    [self setSendButton:nil];
    [self setHeaderView:nil];
    [super viewDidUnload];
}

- (IBAction)DismissClicked:(id)sender {
    NSLog(@"-------- adasd");
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the message field with the result of the operation.
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
	
	// Notifies users about errors associated with the interface
//	switch (result)
//	{
//		case MFMailComposeResultCancelled:
//			message.text = @"Result: canceled";
//			break;
//		case MFMailComposeResultSaved:
//			message.text = @"Result: saved";
//			break;
//		case MFMailComposeResultSent:
//			message.text = @"Result: sent";
//			break;
//		case MFMailComposeResultFailed:
//			message.text = @"Result: failed";
//			break;
//		default:
//			message.text = @"Result: not sent";
//			break;
//	}
	[self dismissModalViewControllerAnimated:YES];
}

- (IBAction)sendButtonClick:(id)sender {
    
    NSLog(@"----- button click ");
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
	
	[picker setSubject:@"Hello from California!"];
	
    
	// Set up recipients
	NSArray *toRecipients = [NSArray arrayWithObject:@"rhlnair@gmail.com"];
//	NSArray *ccRecipients = [NSArray arrayWithObjects:@"second@example.com", @"third@example.com", nil];
//NSArray *bccRecipients = [NSArray arrayWithObject:@"fourth@example.com"];
	
	[picker setToRecipients:toRecipients];
//	[picker setCcRecipients:ccRecipients];
//	[picker setBccRecipients:bccRecipients];
	
	// Attach an image to the email
    NSLog(@"---path %@",docaPathFull);
    NSData *myData = [NSData dataWithContentsOfFile:docaPathFull];
	[picker addAttachmentData:myData mimeType:@"video/mov" fileName:OUTPUT_FILE_NAME];
	
	// Fill out the email body text
	NSString *emailBody = @"It is raining in sunny California!";
	[picker setMessageBody:emailBody isHTML:NO];
	
	[self presentModalViewController:picker animated:YES];
    [picker release];
}
@end
