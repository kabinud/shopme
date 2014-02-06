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
#import "XYZTopEditTableViewController.h"
#import <MessageUI/MFMailComposeViewController.h>
#import "XYZToDoItem.h"
#import "XYZGlobalContainer.h"
#import "XYZArchivedList.h"
#import "XYZHistoryNavigationViewController.h"



#define SLIDE_TIMING_SLOW .45
#define SLIDE_TIMING_FAST .25

@interface XYZOberViewController () <OberViewControllerDelegate, MFMailComposeViewControllerDelegate, UIActionSheetDelegate>

@property XYZMainViewController *mainViewController;
@property XYZTopViewController *topViewController;
@property XYZTopEditNavigationController *topEditNavigationController;
@property BOOL showingTopPanel;
@property BOOL movingTopEditPanel;
@property XYZGlobalContainer *globalContainer;


@end

@implementation XYZOberViewController

- (void)returnToRoot {
    [self dismissViewControllerAnimated:NO completion:nil];
    [self.navigationController popToRootViewControllerAnimated:NO];
}

- (void)shoppingHistory{
    [self bringTopPanel:
     ^{
         [self performSegueWithIdentifier: @"HistoryFromOberSegue" sender: self];
    }
     WithAnimationDuration:SLIDE_TIMING_FAST
     ];
    
    
}


- (void)finishShopping{
    [self bringTopPanel:
     ^{
         [self performSegueWithIdentifier: @"FinishShoppingSegue" sender: self];
     }
     WithAnimationDuration:SLIDE_TIMING_FAST
     ];
    
}

- (IBAction)unwindOberViewController:(UIStoryboardSegue *)segue
{
    if(self.showingTopPanel){
        [self bringTopPanel:nil WithAnimationDuration:SLIDE_TIMING_SLOW];
        self.mainViewController.tableView.scrollEnabled = YES;
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    self.mainViewController.tableView.scrollEnabled = YES;
    
    //(1)
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(appEnteredBackground:)
                                                 name: UIApplicationDidEnterBackgroundNotification
                                               object: nil];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    if(self.showingTopPanel){
        [self bringTopPanel:nil WithAnimationDuration:SLIDE_TIMING_SLOW];
    }
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
    //(2)
     [[NSNotificationCenter defaultCenter] removeObserver:self];

}

//if app loses focus, in this view only, this is triggered in order to close the top menu,
// (1) and (2) register and unregister this selector so that it is only triggered in this very view
-(void)appEnteredBackground:(NSNotification *)appEnteredBackgroundNotification {
    if(self.showingTopPanel){
        [self bringTopPanel:nil WithAnimationDuration:SLIDE_TIMING_SLOW];
    }
}

- (void)sendListByEmail{
    
    
    [self bringTopPanel:
     ^{
         if ([MFMailComposeViewController canSendMail]) {
             MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
             controller.mailComposeDelegate = self;
             [controller setSubject:@"My shopping list"];
             
             NSMutableString *messageBody = [NSMutableString new];
             [messageBody appendString:@"My shopping list:\n\n "];
             for(XYZToDoItem *item in self.globalContainer.toDoItems) {
                 [messageBody appendString:@"- "];
                 [messageBody appendString:item.itemName];
                 [messageBody appendString:@"\n"];
             }
             
             [controller setMessageBody:messageBody isHTML:NO];
             
             if (controller){
                 //bring top panel up and when done proceed to present view controller, which overall looks cool
               //  [self bringTopPanel:^{
                     self.mainViewController.tableView.scrollEnabled = YES;
                     [self presentViewController:controller animated:NO completion:NULL];
               //  }];
                 
                 
                 
             }
         }
         else {
             UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error" message:@"Unable to send e-mail" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
             [alert show];
             return;
         }
     }
     
     WithAnimationDuration:SLIDE_TIMING_FAST
     ];
    
    

}

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error;
{
    if (result == MFMailComposeResultSent) {
       // NSLog(@"It's away!");
    }

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)removeAllItemsFromMainTable{
    
    UIActionSheet *popupQuery;
    
    popupQuery = [[UIActionSheet alloc] initWithTitle:@"Do you want to remove all the items from your shopping list?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Clear list"
                                    otherButtonTitles: nil];
    
    
    popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [popupQuery showInView:self.view];
    
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0)
    {
        [self.mainViewController removeAllItemsFromCurrentShoppingList];
        [self.mainViewController bringOrCloseToPanel];
        
    }
    else if (buttonIndex == 1)
    {
        //[self.mainViewController bringOrCloseToPanel];
    }
    
}

- (void)performEditSegue{
    [self performSegueWithIdentifier: @"EditSegue" sender: self];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.showingTopPanel = NO;
        self.movingTopEditPanel = NO;
       
    }
    return self;
}

- (void)loadMainView{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    self.mainViewController = (XYZMainViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"mainViewId"];
    self.mainViewController.delegate = self;
    
    
    self.mainViewController.view.frame = CGRectMake(0, 22, self.mainViewController.view.frame.size.width, self.mainViewController.view.frame.size.height);
    
    [self.view addSubview:self.mainViewController.view];
   
    self.showingTopPanel = NO;
    
    [self addChildViewController:_mainViewController];
    [_mainViewController didMoveToParentViewController:self];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    

    self.globalContainer = [XYZGlobalContainer globalContainer];
    [self.globalContainer readItemsFromFile];
    [self.globalContainer readHistoricalItemsFromFile];
    [self.globalContainer readListsFromFile];
    
    [self loadMainView];
    //removes toolbar border
     self.navigationController.toolbar.clipsToBounds = YES;
    
    
    
   
}

- (UITableView *)getTopView
{
  
    if(_topViewController == nil){
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        self.topViewController = (XYZTopViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"topViewId"];
        self.topViewController.delegate = self;
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
    
   
    [UIView animateWithDuration:SLIDE_TIMING_SLOW delay:0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                      
                         _mainViewController.view.frame = CGRectMake(0, 22, self.view.frame.size.width, self.view.frame.size.height);
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                                [self.topEditNavigationController.view removeFromSuperview];
                             self.topEditNavigationController = nil;
                         }
                     }];

   
    
    
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
    
    
    if(_mainViewController.view.frame.origin.y<100){
       // NSLog(@"%f", _mainViewController.view.frame.origin.y);
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
    }
    else{
        if(self.movingTopEditPanel==NO){
            self.movingTopEditPanel = YES;
            UITableView *childView = [self getTopEditView];
            [self.view sendSubviewToBack:childView];
            [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionBeginFromCurrentState
                             animations:^{
                                 _mainViewController.view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
                             }
                             completion:^(BOOL finished) {
                                 if (finished ) {
                                     self.movingTopEditPanel = NO;
                                     
                                     
                                     [self performSegueWithIdentifier: @"EditSegue" sender: self];
                                     [self.topEditNavigationController.view removeFromSuperview];
                                     self.topEditNavigationController = nil;
                                     
                                     _mainViewController.view.frame = CGRectMake(0, 22, self.view.frame.size.width, self.view.frame.size.height);
                                 }
                             }];
            
            
            
            
            
        }
    }
    
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue.identifier isEqualToString:@"EditSegue"]) {
        XYZTopEditNavigationController *navController = (XYZTopEditNavigationController *)segue.destinationViewController;
        XYZTopEditTableViewController *controller = (XYZTopEditTableViewController *)navController.viewControllers[0];
        controller.editFieldAutoResponderAllowed = YES;
    }
    else if([segue.identifier isEqualToString:@"FinishShoppingSegue"]){
        XYZArchivedList *list = [[XYZArchivedList alloc] initWithListAndSetTheRestAutomatically:self.globalContainer.toDoItems];
        
        self.globalContainer.listToBeArchived = list;
    }
    else if([segue.identifier isEqualToString:@"HistoryFromOberSegue"]){

        
     
    }
    
    

    
}


- (void)bringTopPanel: (void (^)(void))block WithAnimationDuration: (double )duration{
    
    if(self.showingTopPanel){
        
        [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             _mainViewController.view.frame = CGRectMake(0, 22, self.view.frame.size.width, self.view.frame.size.height);
                         }
                         completion:^(BOOL finished) {
                             if (finished) {
                                 [_topViewController.view removeFromSuperview];
                                 _topViewController = nil;
                                 _showingTopPanel = NO;
                                 if(block!=nil){
                                     block();
                                 }
                             }
                         }];
        
    
        
    }
    
    else{
    
    UITableView *childView = [self getTopView];
    [self.view sendSubviewToBack:childView];
     
 
    
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         _mainViewController.view.frame = CGRectMake(0, 4.5*childView.rowHeight, self.view.frame.size.width, self.view.frame.size.height);
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             self.showingTopPanel = YES;
                         }
                     }];
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
