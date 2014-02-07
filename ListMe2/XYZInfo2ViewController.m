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

- (void)loadTipImageView{
    
    UIImageView *presentationView;
    
    UIImage *image = [UIImage imageNamed:@"tips.png"];
    
    presentationView = [[UIImageView alloc] initWithFrame:CGRectMake(
                                                                     25
                                                                     ,  25
                                                                     , image.size.width , image.size.height)];
    presentationView.image = image;
    
    UIView *backGroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height)];
    
    [backGroundView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7]];
    
    UIView *whiteGroundView = [[UIImageView alloc] initWithFrame:CGRectMake(25,25, self.view.frame.size.width-50, self.view.frame.size.height-44-50)];
    
    [whiteGroundView setBackgroundColor:[UIColor whiteColor]];
    
    [self.view addSubview:backGroundView];
    [self.view addSubview:whiteGroundView];
    [self.view addSubview:presentationView];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self loadTipImageView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
