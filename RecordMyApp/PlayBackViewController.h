//
//  PlayBackViewController.h
//  ScreenCaptureViewTest
//
//  Created by Rahul Nair on 21/01/13.
//
//

#import <UIKit/UIKit.h>
#import  <MediaPlayer/MediaPlayer.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface PlayBackViewController : UIViewController <UIGestureRecognizerDelegate,MFMailComposeViewControllerDelegate>
@property (retain, nonatomic) IBOutlet UIButton *DismissView;
@property(retain,nonatomic)MPMoviePlayerController *player;
- (IBAction)DismissClicked:(id)sender;

@property (retain, nonatomic) IBOutlet UIView *headerView;
@property (retain, nonatomic) IBOutlet UIButton *sendButton;
- (IBAction)sendButtonClick:(id)sender;

@end
