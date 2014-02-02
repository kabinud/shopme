//
//  XYZTopEditViewController.m
//  ListMe2
//
//  Created by Marcin Kmieć on 01.02.2014.
//  Copyright (c) 2014 BQDev. All rights reserved.
//

#import "XYZTopEditViewController.h"
#import "XYZOberViewController.h"

@interface XYZTopEditViewController ()


@end

@implementation XYZTopEditViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)segue2back:(id)sender {
    

    [self dismissViewControllerAnimated:NO completion:^{
     
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
