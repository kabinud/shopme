//
//  XYZMainViewController.h
//  ListMe2
//
//  Created by Marcin Kmieć on 31.01.2014.
//  Copyright (c) 2014 BQDev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYZOberViewController.h"
#import "XYZGlobalContainer.h"

@interface XYZMainViewController : UITableViewController

@property (nonatomic, assign) id<OberViewControllerDelegate> delegate;

@property XYZGlobalContainer *globalContainer;

@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *swipeRightGestureRecognizer;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *swipeLeftGestureRecognizer;


@end
