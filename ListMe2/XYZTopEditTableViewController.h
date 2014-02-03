//
//  XYZTopEditTableViewController.h
//  ListMe2
//
//  Created by Marcin Kmieć on 02.02.2014.
//  Copyright (c) 2014 BQDev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYZGlobalContainer.h"

@interface XYZTopEditTableViewController : UITableViewController<UITextFieldDelegate>

@property BOOL editFieldAutoResponderAllowed;
@property XYZGlobalContainer *globalContainer;

@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapGestureRecognizer;

@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *swipeRightGestureRecognizer;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *swipeLeftGestureRecognizer;

@end
