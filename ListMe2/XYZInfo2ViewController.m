//
//  XYZInfo2ViewController.m
//  ListMe2
//
//  Created by Marcin Kmieć on 07.02.2014.
//  Copyright (c) 2014 BQDev. All rights reserved.
//

#import "XYZInfo2ViewController.h"

@interface XYZInfo2ViewController ()

@end

@implementation XYZInfo2ViewController
- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
