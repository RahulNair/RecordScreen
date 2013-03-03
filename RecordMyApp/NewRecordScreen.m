//
//  NewRecordScreen.m
//  RecordMyApp
//
//  Created by Rahul Nair on 01/02/13.
//  Copyright (c) 2013 Rahul Nair. All rights reserved.
//

#import "NewRecordScreen.h"
#import "PlayBackRecordedScreen.h"
#import "PlayBackViewController.h"
@implementation NewRecordScreen

@synthesize shouldStopRecording;
@synthesize isRecording;



-(id)initWithView:(UIView *)parentView andViewController:(UIViewController *)parentViewController{
    self = [super init];
    if (self) {
        myParentView =  parentView;
        myParentViewController = parentViewController;
        
        if (parentView) {
            recordView = [[UIView alloc]initWithFrame:CGRectMake(parentView.frame.size.width-100, 0, 100, 30)];
            [recordView setBackgroundColor:[UIColor redColor]];
            [recordView setAlpha:0.1];
            textLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, 30)];
            [textLabel setBackgroundColor:[UIColor clearColor]];
            [textLabel setText:@"OnRecord"];
            [recordView addSubview:textLabel];
            [recordView setHidden:YES];
            [parentView addSubview:recordView];

        }

        
      
        
        
    }
    return self;
}

-(void)dealloc{
    [super dealloc];
    [textLabel release];
    [playBackView release];
}

#pragma mark screenshot
// copied from http://developer.apple.com/library/ios/#qa/qa1703/_index.html ,
// with new imageScale to take Retina-to-320x480 scaling into account
- (UIImage*)screenshot
{
    // Create a graphics context with the target size
    // On iOS 4 and later, use UIGraphicsBeginImageContextWithOptions to take the scale into consideration
    // On iOS prior to 4, fall back to use UIGraphicsBeginImageContext
    CGSize imageSize = [[UIScreen mainScreen] bounds].size;
	CGFloat imageScale = imageSize.width / FRAME_WIDTH;
    if (NULL != UIGraphicsBeginImageContextWithOptions)
        UIGraphicsBeginImageContextWithOptions(imageSize, NO, imageScale);
    else
        UIGraphicsBeginImageContext(imageSize);
	
    CGContextRef context = UIGraphicsGetCurrentContext();
	
    // Iterate over every window from back to front
    for (UIWindow *window in [[UIApplication sharedApplication] windows])
    {
        if (![window respondsToSelector:@selector(screen)] || [window screen] == [UIScreen mainScreen])
        {
            // -renderInContext: renders in the coordinate space of the layer,
            // so we must first apply the layer's geometry to the graphics context
            CGContextSaveGState(context);
            // Center the context around the window's anchor point
            CGContextTranslateCTM(context, [window center].x, [window center].y);
            // Apply the window's transform about the anchor point
            CGContextConcatCTM(context, [window transform]);
            // Offset by the portion of the bounds left of and above the anchor point
            CGContextTranslateCTM(context,
                                  -[window bounds].size.width * [[window layer] anchorPoint].x,
                                  -[window bounds].size.height * [[window layer] anchorPoint].y);
			
            // Render the layer hierarchy to the current context
            [[window layer] renderInContext:context];
			
            // Restore the context
            CGContextRestoreGState(context);
        }
    }
	
    // Retrieve the screenshot image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();

	
    UIGraphicsEndImageContext();
	
    return image;
}


#pragma mark helpers
-(NSString*) pathToDocumentsDirectory {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	return documentsDirectory;
}
-(void) writeSampleAlpha: (NSTimer*) _timer {
    
    
    
	if (assetWriterInput.readyForMoreMediaData && !shouldStopRecording) {
		// CMSampleBufferRef sample = nil;
		
		CVReturn cvErr = kCVReturnSuccess;
		
		// get screenshot image!
		CGImageRef image = (CGImageRef) [[self screenshot] CGImage];
		NSLog (@"made screenshot");

		// prepare the pixel buffer
        
		CVPixelBufferRef pixelBuffer = NULL;
		CFDataRef imageData= CGDataProviderCopyData(CGImageGetDataProvider(image));
		NSLog (@"copied image data");
		cvErr = CVPixelBufferCreateWithBytes(kCFAllocatorDefault,
											 FRAME_WIDTH,
											 FRAME_HEIGHT,
											 kCVPixelFormatType_32BGRA,
											 (void*)CFDataGetBytePtr(imageData),
											 CGImageGetBytesPerRow(image),
											 NULL,
											 NULL,
											 NULL,
											 &pixelBuffer);
		NSLog (@"CVPixelBufferCreateWithBytes returned %d", cvErr);
		
		// calculate the time
		CFAbsoluteTime thisFrameWallClockTime = CFAbsoluteTimeGetCurrent();
		CFTimeInterval elapsedTime = thisFrameWallClockTime - firstFrameWallClockTime;
		NSLog (@"elapsedTime: %f", elapsedTime);
		CMTime presentationTime =  CMTimeMake (elapsedTime * TIME_SCALE, TIME_SCALE);
		// write the sample
        
//
//        
		BOOL appended = [assetWriterPixelBufferAdaptor appendPixelBuffer:pixelBuffer withPresentationTime:presentationTime];
        
		if (appended) {
			NSLog (@"appended sample at time %lf", CMTimeGetSeconds(presentationTime));
		} else {
			NSLog (@"failed to append");
			[self stopRecording];
			//self.startStopButton.selected = NO;
		}
        CFRelease(imageData);
//
//        
        
	}else{
        NSLog(@"----assetWriterInput.readyForMoreMediaData && !shouldStopRecording----adasdasdadsadadasd %d",self.shouldStopRecording);
        
        [self stopRecordingAlpha];
    }
}

- (CVPixelBufferRef) pixelBufferFromCGImage: (CGImageRef) image
{
    
    CGSize frameSize = CGSizeMake(CGImageGetWidth(image), CGImageGetHeight(image));
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:NO], kCVPixelBufferCGImageCompatibilityKey,
                             [NSNumber numberWithBool:NO], kCVPixelBufferCGBitmapContextCompatibilityKey,
                             nil];
    CVPixelBufferRef pxbuffer = NULL;
    CVReturn status = CVPixelBufferCreate(kCFAllocatorDefault, frameSize.width,
                                          frameSize.height,  kCVPixelFormatType_32ARGB, (CFDictionaryRef) options,
                                          &pxbuffer);
    NSParameterAssert(status == kCVReturnSuccess && pxbuffer != NULL);
    
    CVPixelBufferLockBaseAddress(pxbuffer, 0);
    void *pxdata = CVPixelBufferGetBaseAddress(pxbuffer);
    
    
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pxdata, frameSize.width,
                                                 frameSize.height, 8, 4*frameSize.width, rgbColorSpace,
                                                 kCGImageAlphaNoneSkipLast);
    
    CGContextDrawImage(context, CGRectMake(0, 0, CGImageGetWidth(image),
                                           CGImageGetHeight(image)), image);
    CGColorSpaceRelease(rgbColorSpace);
    CGContextRelease(context);
    
    CVPixelBufferUnlockBaseAddress(pxbuffer, 0);
    
    return pxbuffer;
}


-(void)confirmRecording{
    NSLog(@"-confirmRecording-- ");
    alertConfirmation = [[UIAlertView alloc]initWithTitle:@"Start Recording" message:@"Are You sure You wanna record screen of your app" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [alertConfirmation setTag:1];
    [alertConfirmation show];
}
-(void)confirmStopRecording{
    NSLog(@"-confirmRecording-- ");
    alertConfirmation = [[UIAlertView alloc]initWithTitle:@"Recording stopped" message:@"Succefully Recording Completed." delegate:self cancelButtonTitle:@"Play" otherButtonTitles:nil, nil];
    [alertConfirmation setTag:2];
    [alertConfirmation show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (alertView.tag == 1) {
        if (buttonIndex == 1) {
           [self startRecordingAlpha];

        }
    }else if (alertView.tag == 2){
        NSLog(@"--ppp");
        if (playBackView) {
            [playBackView release];
            playBackView = nil;
        }
        
//        playBackView = [[PlayBackRecordedScreen alloc]initWithFrame:CGRectMake(0, 50,myParentView.self.frame.size.width, myParentView.self.frame.size.height)];
//            [myParentView addSubview:playBackView];

        
       playBackView = [[PlayBackViewController alloc]initWithNibName:@"PlayBackViewController" bundle:nil];
        [myParentViewController.navigationController pushViewController:playBackView animated:NO];
        
    }
}
-(void)startRecordingAlpha{
	NSLog(@"---alpha");
    isRecording = YES;
    [recordView setHidden:NO];
	//	// create the AVComposition
	//	[mutableComposition release];
	//	mutableComposition = [[AVMutableComposition alloc] init];
	
	// create the AVAssetWriter
	NSString *moviePath = [[self pathToDocumentsDirectory] stringByAppendingPathComponent:OUTPUT_FILE_NAME];
	if ([[NSFileManager defaultManager] fileExistsAtPath:moviePath]) {
		[[NSFileManager defaultManager] removeItemAtPath:moviePath error:nil];
	}
	
	NSURL *movieURL = [NSURL fileURLWithPath:moviePath];
	NSError *movieError = nil;
	[assetWriter release];
	assetWriter = [[AVAssetWriter alloc] initWithURL:movieURL
                                            fileType: AVFileTypeQuickTimeMovie
                                               error: &movieError];
	NSDictionary *assetWriterInputSettings = [NSDictionary dictionaryWithObjectsAndKeys:
											  AVVideoCodecH264, AVVideoCodecKey,
											  [NSNumber numberWithInt:FRAME_WIDTH], AVVideoWidthKey,
											  [NSNumber numberWithInt:FRAME_HEIGHT], AVVideoHeightKey,
											  nil];
	assetWriterInput = [AVAssetWriterInput assetWriterInputWithMediaType: AVMediaTypeVideo
														  outputSettings:assetWriterInputSettings];
	assetWriterInput.expectsMediaDataInRealTime = YES;
	[assetWriter addInput:assetWriterInput];
	
	[assetWriterPixelBufferAdaptor release];
	assetWriterPixelBufferAdaptor = [[AVAssetWriterInputPixelBufferAdaptor  alloc]
									 initWithAssetWriterInput:assetWriterInput
									 sourcePixelBufferAttributes:nil];
	[assetWriter startWriting];
	firstFrameWallClockTime = CFAbsoluteTimeGetCurrent();
	[assetWriter startSessionAtSourceTime: CMTimeMake(0, TIME_SCALE)];

	
	// start writing samples to it
	[assetWriterTimer release];
	assetWriterTimer = [NSTimer scheduledTimerWithTimeInterval:0.20
														target:self
													  selector:@selector (writeSampleAlpha:)
													  userInfo:nil
													   repeats:YES] ;
    
    
    
	
}


-(void) stopRecordingAlpha {
    NSLog(@"---alpha finish");
    isRecording = NO;
    [recordView setHidden:YES];
	[assetWriterTimer invalidate];
	assetWriterTimer = nil;
	
	[assetWriter finishWriting];
	NSLog (@"finished writing");
}







@end
