//
//  TestViewController.h
//  RecordMyApp
//
//  Created by Rahul Nair on 01/02/13.
//  Copyright (c) 2013 Rahul Nair. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScreenCaptureView.h"
#import "PlayBackViewController.h"
#import "NewRecordScreen.h"


@interface TestViewController : UIViewController <UIGestureRecognizerDelegate,UIAlertViewDelegate>{
	NewRecordScreen *newRecordObj;
    UITapGestureRecognizer *myTapGesture;

}
@property (retain, nonatomic) IBOutlet UIButton *okButton;
@property (retain, nonatomic) IBOutlet UITextField *passwordText;
@property (retain, nonatomic) IBOutlet UITextField *usernameText;
@property (retain, nonatomic) IBOutlet UIButton *stopRecording;
@property (retain, nonatomic) IBOutlet UIButton *startRecording;
@property (retain, nonatomic)IBOutlet ScreenCaptureView *screenCapture;
@property (retain, nonatomic) IBOutlet UIButton *loginButton;
- (IBAction)okClick:(id)sender;
- (IBAction)loginClick:(id)sender;
- (IBAction)startClick:(id)sender;
- (IBAction)stopClick:(id)sender;

@end
