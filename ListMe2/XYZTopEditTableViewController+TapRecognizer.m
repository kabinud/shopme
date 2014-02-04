//
//  XYZTopEditTableViewController+TapRecognizers.m
//  ListMe2
//
//  Created by Marcin Kmieć on 03.02.2014.
//  Copyright (c) 2014 BQDev. All rights reserved.
//

#import "XYZTopEditTableViewController+TapRecognizer.h"
#import "XYZToDoItem.h"

@implementation XYZTopEditTableViewController (TapRecognizers)

- (IBAction)recognizeTapGesture:(id)sender {
    CGPoint location = [self.tapGestureRecognizer locationInView:self.tableView];
    NSIndexPath *swippedIndexPath = [self.tableView indexPathForRowAtPoint:location];
    //if clicked on an empty table cell return to main table view
    if(swippedIndexPath == nil){
        [self addData: self.editField.text];
        [self.editField resignFirstResponder];
        [self dismissViewControllerAnimated:NO completion:^{}];
    }
    else if([swippedIndexPath section]==1){
        XYZToDoItem *item;
        item = [self.historicalItemsToShow objectAtIndex:swippedIndexPath.row];
            
        [self.globalContainer.toDoItems insertObject:item atIndex:0];
        [self.globalContainer saveItemsToFile];
        self.itemAdded = YES;
        
        [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
        [self.tableView reloadData];
    }
}




@end
