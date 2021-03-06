//
//  XYZOberViewController.h
//  ListMe2
//
//  Created by Marcin Kmieć on 31.01.2014.
//  Copyright (c) 2014 BQDev. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OberViewControllerDelegate <NSObject>

- (void)bringTopPanel: (void (^)(void))block WithAnimationDuration: (double )duration;
- (void)bringTopEditPanelToAnExtend: (int)topY;
- (void)closeTopEditPanel;
- (void)performEditSegue;
- (void)removeAllItemsFromMainTable;
- (void)sendListByEmail;
- (void)finishShopping;
- (void)returnToRoot;
- (void)shoppingHistory;

@end

@interface XYZOberViewController : UIViewController

@end
