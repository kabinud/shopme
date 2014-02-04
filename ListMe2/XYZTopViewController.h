//
//  XYZTopViewController.h
//  ListMe2
//
//  Created by Marcin Kmieć on 01.02.2014.
//  Copyright (c) 2014 BQDev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYZOberViewController.h"

@interface XYZTopViewController : UITableViewController
@property (nonatomic, assign) id<OberViewControllerDelegate> delegate;
@end
