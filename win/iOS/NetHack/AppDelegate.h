//
//  AppDelegate.h
//  NetHack
//
//  Created by Dirk Zimmermann on 1/31/12.
//  Copyright Dirk Zimmermann 2012. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
}

@property (nonatomic, retain) UIWindow *window;

@end
