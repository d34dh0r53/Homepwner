//
//  HomepwnerAppDelegate.h
//  Homepwner
//
//  Created by Dave Wilde on 6/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ItemsViewController;

@interface HomepwnerAppDelegate : NSObject <UIApplicationDelegate> {
    ItemsViewController *itemsViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end
