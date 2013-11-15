//
//  BKGLoginViewController.h
//  Backlogman
//
//  Created by Vincent Fournié on 15.11.13.
//  Copyright (c) 2013 VFE. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BKGLoginViewControllerDelegate;

@interface BKGLoginViewController : UIViewController

@property (nonatomic, weak) id<BKGLoginViewControllerDelegate> signInDelegate;

@end

@protocol BKGLoginViewControllerDelegate
@required

- (void)signInDidSucceed:(BKGLoginViewController *)viewController;

@end
