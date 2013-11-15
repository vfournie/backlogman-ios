//
//  BKGMasterViewController.h
//  Backlogman
//
//  Created by Vincent Fournié on 11.11.13.
//  Copyright (c) 2013 VFE. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BKGDetailViewController;

@interface BKGMasterViewController : UITableViewController

@property (strong, nonatomic) BKGDetailViewController *detailViewController;

- (void)loadObjects;

@end
