//
//  TestAppDelegate.h
//  RecordMyApp
//
//  Created by Rahul Nair on 01/02/13.
//  Copyright (c) 2013 Rahul Nair. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TestViewController;

@interface TestAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property(nonatomic,retain)UINavigationController *navigationController ;
@property (strong, nonatomic) TestViewController *viewController;

@end
