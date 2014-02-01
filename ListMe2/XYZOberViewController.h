//
//  XYZOberViewController.h
//  ListMe2
//
//  Created by Marcin Kmieć on 31.01.2014.
//  Copyright (c) 2014 BQDev. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OberViewControllerDelegate <NSObject>

- (void)bringTopPanel;

@end

@interface XYZOberViewController : UIViewController

@end
