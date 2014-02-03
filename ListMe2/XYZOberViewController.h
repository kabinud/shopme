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
- (void)bringTopEditPanelToAnExtend: (int)topY;
- (void)closeTopEditPanel;
- (void)performEditSegue;

@end

@interface XYZOberViewController : UIViewController
-(IBAction)returned1:(UIStoryboardSegue *)segue animated:(BOOL)animated;
@end
