//
//  ItemsViewController.h
//  Homepwner
//
//  Created by Dave Wilde on 6/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ItemDetailViewController;


@interface ItemsViewController : UITableViewController {
//    UIView *headerView;
    ItemDetailViewController *detailViewController;
    NSMutableArray *possessions;
}

//- (UIView *)headerView;

@end
