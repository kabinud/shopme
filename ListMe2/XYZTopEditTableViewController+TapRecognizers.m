//
//  XYZTopEditTableViewController+TapRecognizers.m
//  ListMe2
//
//  Created by Marcin Kmieć on 03.02.2014.
//  Copyright (c) 2014 BQDev. All rights reserved.
//

#import "XYZTopEditTableViewController+TapRecognizers.h"

@implementation XYZTopEditTableViewController (TapRecognizers)


- (IBAction)recognizeTapGesture:(id)sender {
    NSLog(@"Tap");
}

- (IBAction)recognizeSwipeRightGesture:(id)sender {
    NSLog(@"Left");
}
- (IBAction)recognizeSwipeLeftGesture:(id)sender {
    NSLog(@"Right");
}


@end
