//
//  NewRecordScreen.h
//  RecordMyApp
//
//  Created by Rahul Nair on 01/02/13.
//  Copyright (c) 2013 Rahul Nair. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCFScreenRecorderConsts.h"
#import <AVFoundation/AVFoundation.h>
#import "PlayBackViewController.h"

@interface NewRecordScreen : NSObject <UIGestureRecognizerDelegate,UIAlertViewDelegate>{
    UIView *recordView;
    UIView *myParentView;
    UIViewController *myParentViewController;
    NSTimer *assetWriterTimer;
	AVMutableComposition *mutableComposition;
	AVAssetWriter *assetWriter;
	AVAssetWriterInput *assetWriterInput;
	AVAssetWriterInputPixelBufferAdaptor *assetWriterPixelBufferAdaptor;
	CFAbsoluteTime firstFrameWallClockTime;
    BOOL isRecording;
   
    @private
    UILabel *textLabel;
    UIAlertView *alertConfirmation;

    PlayBackViewController *playBackView;
}

@property(nonatomic,readwrite)BOOL shouldStopRecording;
@property(nonatomic,readwrite)BOOL isRecording;
-(id)initWithView:(UIView*)parentView andViewController:(UIViewController*)parentViewController;
-(void) startRecording;
-(void) stopRecording ;
-(void)startRecordingAlpha;
-(void)confirmRecording;
-(void)confirmStopRecording;

@end
