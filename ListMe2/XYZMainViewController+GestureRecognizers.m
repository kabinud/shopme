//
//  XYZMainViewController+GestureRecognizers.m
//  ListMe2
//
//  Created by Marcin Kmieć on 03.02.2014.
//  Copyright (c) 2014 BQDev. All rights reserved.
//

#import "XYZMainViewController+GestureRecognizers.h"
#import "XYZToDoItem.h"

@implementation XYZMainViewController (GestureRecognizers)
- (IBAction)tapGestureRecognizer:(id)sender {
    
        CGPoint location = [self.swipeRightGestureRecognizer locationInView:self.tableView];
        NSIndexPath *swippedIndexPath = [self.tableView indexPathForRowAtPoint:location];
        //an empty cell tapped
        if(swippedIndexPath == nil){
            [self.delegate performEditSegue];
        }
    
}

- (IBAction)swipeRightGestureRecognizer:(id)sender {
  
        CGPoint location = [self.swipeRightGestureRecognizer locationInView:self.tableView];
        NSIndexPath *swippedIndexPath = [self.tableView indexPathForRowAtPoint:location];
        
        if(swippedIndexPath != nil){
            
            XYZToDoItem *tappedItem = [self.globalContainer.toDoItems objectAtIndex:swippedIndexPath.row];
            [self.tableView deselectRowAtIndexPath:swippedIndexPath animated:NO];
            
            
            if(!tappedItem.completed && tappedItem.toBeDeleted == NO){
                tappedItem.completed = YES;
                
                [self.tableView reloadRowsAtIndexPaths:@[swippedIndexPath] withRowAnimation:UITableViewRowAnimationNone];
                
                NSIndexPath *indexPathOfLastItem =
                [NSIndexPath indexPathForRow:([self.globalContainer.toDoItems count] - 1) inSection:0];
                
                [self.tableView moveRowAtIndexPath:swippedIndexPath toIndexPath:indexPathOfLastItem];
                [self tableView:self.tableView moveRowAtIndexPath:swippedIndexPath toIndexPath:indexPathOfLastItem];
                
                
                [self.globalContainer saveItemsToFile];
            }
            
            else if(tappedItem.toBeDeleted == YES){
                tappedItem.toBeDeleted = NO;
                [self.tableView reloadRowsAtIndexPaths:@[swippedIndexPath] withRowAnimation:UITableViewRowAnimationNone];
            }
            
        }
    
}

- (IBAction)swipeLeftGestureRecognizer:(id)sender {
}


@end
