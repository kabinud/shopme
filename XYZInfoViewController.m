//
//  XYZInfoViewController.m
//  ListMe2
//
//  Created by Marcin Kmieć on 02.02.2014.
//  Copyright (c) 2014 BQDev. All rights reserved.
//

#import "XYZInfoViewController.h"

@interface XYZInfoViewController ()

@end

@implementation XYZInfoViewController

//- (IBAction)closeButton:(id)sender {
//     [self dismissViewControllerAnimated:NO completion:^{}];
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
    //[self changeBackgroundColor];
	//[self performSelector:@selector(changeBackgroundColor) withObject:nil afterDelay:0.1f];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
