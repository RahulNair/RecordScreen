//
//  TestViewController.m
//  RecordMyApp
//
//  Created by Rahul Nair on 01/02/13.
//  Copyright (c) 2013 Rahul Nair. All rights reserved.
//

#import "TestViewController.h"

@interface TestViewController ()

@end

@implementation TestViewController{
    NSThread *myThread;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   // self.screenCapture = [[ScreenCaptureView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
//  [self.view sendSubviewToBack:self.screenCapture];
    newRecordObj = [[NewRecordScreen alloc]initWithView:self.view andViewController:self];
    
    myTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTapHandle:)];
    [myTapGesture setNumberOfTapsRequired:2];
    [self.view addGestureRecognizer:myTapGesture];
    
 //  
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [myTapGesture release];
    [_screenCapture release];
    [_loginButton release];
    [_startRecording release];
    [_stopRecording release];
    [_usernameText release];
    [_passwordText release];
    [_okButton release];
    [super dealloc];
}
-(void)doubleTapHandle:(UITapGestureRecognizer *)recognizer{
    NSLog(@"---tapppedddd");
    if (newRecordObj) {
        
        if (!newRecordObj.isRecording) {
            newRecordObj.shouldStopRecording = NO;
            [newRecordObj confirmRecording];
        }else if (newRecordObj.isRecording){
             newRecordObj.shouldStopRecording = YES;
           [newRecordObj confirmStopRecording];
        }
    }
    
}
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    if(touch.phase==UITouchPhaseBegan){
        //find first response view
        for (UIView *view in [self.view subviews]) {
            if ([view isFirstResponder]) {
                [view resignFirstResponder];
                break;
            }
        }
    }
}

- (IBAction)okClick:(id)sender {
    UIAlertView *showAlert;
    showAlert = [[UIAlertView alloc]initWithTitle:@"Wrong Password" message:@"Authentication Failed" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    if ([self.usernameText.text isEqualToString:@"rawuser"] && [self.passwordText.text isEqualToString:@"raw123"]) {
        showAlert = [[UIAlertView alloc]initWithTitle:@"Welcome In" message:@"Successful Authentication" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [showAlert show];
    }else{
        showAlert = [[UIAlertView alloc]initWithTitle:@"Wrong Password" message:@"Authentication Failed" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];

        [showAlert show];
    }
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
}
- (IBAction)loginClick:(id)sender {
    
    PlayBackViewController *playBackController = [[PlayBackViewController alloc]initWithNibName:@"PlayBackViewController" bundle:nil];
    [self.navigationController pushViewController:playBackController animated:NO];
}

- (IBAction)startClick:(id)sender {
   //  [self.screenCapture startRecording];
  [self startRec];
    
    
}

- (IBAction)stopClick:(id)sender {
   //  [self.screenCapture stopRecording];
   [self stopRec];
    
}

-(void)startRec{
    newRecordObj.shouldStopRecording = NO;
    [newRecordObj startRecordingAlpha];
}
-(void)stopRec{
     newRecordObj.shouldStopRecording = YES;
    //[newRecordObj stopRecording];
}

@end
