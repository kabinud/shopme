//
//  XYZOberViewController.m
//  ListMe2
//
//  Created by Marcin Kmieć on 31.01.2014.
//  Copyright (c) 2014 BQDev. All rights reserved.
//

#import "XYZOberViewController.h"
#import "XYZMainViewController.h"
#import "XYZTopViewController.h"

#define SLIDE_TIMING .45

@interface XYZOberViewController () <OberViewControllerDelegate>

@property XYZMainViewController *mainViewController;
@property XYZTopViewController *topViewController;
@property BOOL showingTopPanel;

@end

@implementation XYZOberViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.showingTopPanel = NO;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    
    self.mainViewController = (XYZMainViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"mainViewId"];
    self.mainViewController.delegate = self;
    
    self.topViewController = (XYZTopViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"topViewId"];
    
    [self.view addSubview:self.mainViewController.view];
    [self addChildViewController:_mainViewController];
    
    [_mainViewController didMoveToParentViewController:self];
}


- (UIView *)getTopView
{
  
    
    
    [self.view addSubview:self.topViewController.view];
    
    [self addChildViewController:_topViewController];
    [_topViewController didMoveToParentViewController:self];
    
    _topViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
  //  self.showingLeftPanel = YES;
    
    // set up view shadows
   // [self showCenterViewWithShadow:YES withOffset:-2];
    
    UIView *view = self.topViewController.view;
    return view;
}

- (void)bringTopPanel{
    
    if(self.showingTopPanel){
        [UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             _mainViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
                         }
                         completion:^(BOOL finished) {
                             if (finished) {
                                 
                                 [self.topViewController.view removeFromSuperview];
                             }
                         }];
        self.showingTopPanel = NO;
    }
    
    else{
    
    UIView *childView = [self getTopView];
    [self.view sendSubviewToBack:childView];
    
    [UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         _mainViewController.view.frame = CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.height);
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             
                     //        _centerViewController.leftButton.tag = 0;
                         }
                     }];
        self.showingTopPanel = YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
