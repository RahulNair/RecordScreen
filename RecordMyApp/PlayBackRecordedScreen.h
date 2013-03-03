//
//  PlayBackRecordedScreen.h
//  RecordMyApp
//
//  Created by Rahul Nair on 03/02/13.
//  Copyright (c) 2013 Rahul Nair. All rights reserved.
//

#import <UIKit/UIKit.h>
#import  <MediaPlayer/MediaPlayer.h>


@interface PlayBackRecordedScreen : UIView{
    UIView *header;
}



@property(retain,nonatomic)MPMoviePlayerController *player;

-(id)initWithFrame:(CGRect)frame andParentView:(UIView*)parentView;
@end
