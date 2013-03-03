//
//  PlayBackRecordedScreen.m
//  RecordMyApp
//
//  Created by Rahul Nair on 03/02/13.
//  Copyright (c) 2013 Rahul Nair. All rights reserved.
//

#import "PlayBackRecordedScreen.h"

@implementation PlayBackRecordedScreen{
    UIButton *cancelButton;
    UIButton *mailButton;

}
@synthesize player = _player;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSLog(@"----------- adsdasd ");
        
        header = [[UIView alloc]initWithFrame:CGRectMake(5, 0, self.frame.size.width-10, 50)];
        [header setBackgroundColor:[UIColor redColor]];
        [self addSubview:header];
        
        cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [cancelButton setFrame:CGRectMake(50,10, 100, 40)];
        [cancelButton setTitle:@"Dismiss" forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(cancelButtonClicked) forControlEvents:UIControlEventTouchDown];
        [header addSubview:cancelButton];
        
        mailButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [mailButton setFrame:CGRectMake(200,10, 100, 40)];
        [mailButton setTitle:@"Send" forState:UIControlStateNormal];
        [mailButton addTarget:self action:@selector(mailButtonClick) forControlEvents:UIControlEventTouchDown];
        [header addSubview:mailButton];
       
        
        NSString *docPath = [NSSearchPathForDirectoriesInDomains
                             (NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *docaPathFull = [docPath stringByAppendingPathComponent:@"/output.mov"];
        
        NSLog(@"--path %@",docaPathFull);
        //    NSURL *nurl = [NSURL fileURLWithPath:@"file://localhost/Users/rahul/Library/Application%20Support/iPhone%20Simulator/6.0/Applications/439E5299-848F-40D6-8499-DEAF8A12BD3E/Documents/output.mp4"];
        NSURL *nurl = [NSURL fileURLWithPath:docaPathFull];
        _player = [[MPMoviePlayerController alloc]initWithContentURL:nurl];

        [_player.view setFrame: CGRectMake(5,50 , self.frame.size.width-10,  self.frame.size.height-130)];
        [_player prepareToPlay];
        _player.controlStyle = MPMovieControlStyleDefault;
        _player.movieSourceType = MPMovieSourceTypeFile;
        [self addSubview: _player.view];
        [_player play];

    }
    return self;
}
-(id)initWithFrame:(CGRect)frame andParentView:(UIView *)parentView{

    self = [super initWithFrame:frame];
    if (self) {
        NSLog(@"----------- adsdasd ");
        NSString *docPath = [NSSearchPathForDirectoriesInDomains
                             (NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *docaPathFull = [docPath stringByAppendingPathComponent:@"/output.mov"];
        
        NSLog(@"--path %@",docaPathFull);
        //    NSURL *nurl = [NSURL fileURLWithPath:@"file://localhost/Users/rahul/Library/Application%20Support/iPhone%20Simulator/6.0/Applications/439E5299-848F-40D6-8499-DEAF8A12BD3E/Documents/output.mp4"];
        NSURL *nurl = [NSURL fileURLWithPath:docaPathFull];
        _player = [[MPMoviePlayerController alloc]initWithContentURL:nurl];
        [_player.view setFrame: CGRectMake(5,5 , self.frame.size.width-10,  self.frame.size.height-130)];
        [_player prepareToPlay];
        _player.controlStyle = MPMovieControlStyleDefault;
        _player.movieSourceType = MPMovieSourceTypeFile;
        [self addSubview: _player.view];
        [_player play];
    }

    
    return self;
}
-(void)mailButtonClick{
    NSLog(@"--mailButtonClick-");
}

-(void)cancelButtonClicked{
    [_player stop];
    [self setHidden:YES];
}

-(void)dealloc{
    [super dealloc];
    [_player release];
    [cancelButton release];
    [mailButton release];
}

// Displays an email composition interface inside the application. Populates all the Mail fields.
-(void)displayComposerSheet
{

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
