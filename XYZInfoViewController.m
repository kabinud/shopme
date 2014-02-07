//
//  XYZInfoViewController.m
//  ListMe2
//
//  Created by Marcin Kmieć on 02.02.2014.
//  Copyright (c) 2014 BQDev. All rights reserved.
//

#import "XYZInfoViewController.h"
#import "XYZOberViewController.h"
#import "XYZGlobalContainer.h"


@interface XYZInfoViewController ()

@property XYZGlobalContainer *globalContainer;

@end

@implementation XYZInfoViewController

//- (IBAction)backButtonPressed:(id)sender {
//    [self dismissViewControllerAnimated:YES completion:nil];
//    
//}


- (void)changeBackgroundColor{
    
    
    [UIView animateWithDuration:2.0 animations:^{
        [self.view setBackgroundColor:[UIColor whiteColor]];
    }];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.globalContainer = [XYZGlobalContainer globalContainer];
    
    if([self.globalContainer.hasAppTourBeenTaken isEqual:@0]){
        self.globalContainer.hasAppTourBeenTaken = @1;
        [self.globalContainer saveAppTourTaken];
    }
    
    //removes toolbar border
    self.navigationController.toolbar.clipsToBounds = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
