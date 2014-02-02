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
#import "XYZTopEditNavigationController.h"

#define SLIDE_TIMING .45

@interface XYZOberViewController () <OberViewControllerDelegate>

@property XYZMainViewController *mainViewController;
@property XYZTopViewController *topViewController;
@property XYZTopEditNavigationController *topEditNavigationController;
@property BOOL showingTopPanel;
@property BOOL showingTopEditPanel;

@end

@implementation XYZOberViewController



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.showingTopPanel = NO;
        self.showingTopEditPanel = NO;
    }
    return self;
}

- (void)loadMainView{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    self.mainViewController = (XYZMainViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"mainViewId"];
    self.mainViewController.delegate = self;
    
    self.mainViewController.view.frame = CGRectMake(0, 22, self.mainViewController.view.frame.size.width, self.mainViewController.view.frame.size.height);
    
    [self.view addSubview:self.mainViewController.view];
   
    
    
    [self addChildViewController:_mainViewController];
    [_mainViewController didMoveToParentViewController:self];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadMainView];
    //removes toolbar border
    self.navigationController.toolbar.clipsToBounds = YES;
   
}


- (UITableView *)getTopView
{
    if(_topViewController == nil){
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        self.topViewController = (XYZTopViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"topViewId"];
        [self addChildViewController:_topViewController];
        [self.view addSubview:self.topViewController.view];
        [_topViewController didMoveToParentViewController:self];
        _topViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }
    self.showingTopPanel = YES;
    
    UITableView *view = (UITableView *)self.topViewController.view;
    return view;
}




- (void)closeTopEditPanel{
    if(self.showingTopEditPanel == NO){
    [UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                      
                         _mainViewController.view.frame = CGRectMake(0, 22, self.view.frame.size.width, self.view.frame.size.height);
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                                [self.topEditNavigationController.view removeFromSuperview];
                             self.topEditNavigationController = nil;
                             self.showingTopEditPanel = NO;
                     
                         }
                     }];
    }
   
    
    
}

- (UITableView *)getTopEditView
{
    if(_topEditNavigationController == nil){
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        self.topEditNavigationController = (XYZTopEditNavigationController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"topEditViewId"];
        [self addChildViewController:_topEditNavigationController];
        [self.view addSubview:self.topEditNavigationController.view];
        [_topEditNavigationController didMoveToParentViewController:self];
        _topEditNavigationController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }
    
    UITableView *view = (UITableView *)self.topEditNavigationController.view;
    return view;
}

- (void)bringTopEditPanelToAnExtend: (int)topY{
    

    if(_mainViewController.view.frame.origin.y<66 ){
        UITableView *childView = [self getTopEditView];
        [self.view sendSubviewToBack:childView];
        [UIView animateWithDuration:0 delay:0 options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             _mainViewController.view.frame = CGRectMake(0, topY + _mainViewController.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
                         }
                         completion:^(BOOL finished) {
                             if (finished ) {
                              
                             }
                         }];
        self.showingTopEditPanel = NO;
    }
    else{
        [self performSegueWithIdentifier: @"EditSegue" sender: self];
           [self closeTopEditPanel];
    }
    
    
}

-(IBAction)returned1:(UIStoryboardSegue *)segue animated:(BOOL)animated{
    [self closeTopEditPanel];
}

- (void)bringTopPanel{
    
    if(self.showingTopPanel){
        
        [UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             _mainViewController.view.frame = CGRectMake(0, 22, self.view.frame.size.width, self.view.frame.size.height);
                         }
                         completion:^(BOOL finished) {
                             if (finished) {
                                 
                                 NSLog(@"Done");
                                 [self.topViewController.view removeFromSuperview];
                                 self.topViewController = nil;
                                 self.showingTopPanel = NO;
                             }
                         }];
    
        
    }
    
    else{
    
    UITableView *childView = [self getTopView];
    [self.view sendSubviewToBack:childView];
     
       
    
    
    [UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         _mainViewController.view.frame = CGRectMake(0, 3.5*childView.rowHeight, self.view.frame.size.width, self.view.frame.size.height);
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             

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
