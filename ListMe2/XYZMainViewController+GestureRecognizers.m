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
            }
            
            else if(tappedItem.toBeDeleted == YES){
                tappedItem.toBeDeleted = NO;
                [self.tableView reloadRowsAtIndexPaths:@[swippedIndexPath] withRowAnimation:UITableViewRowAnimationNone];
            }
            
            [self.globalContainer saveItemsToFile];
            
        }
    
}

- (IBAction)swipeLeftGestureRecognizer:(id)sender {

        CGPoint location = [self.swipeLeftGestureRecognizer locationInView:self.tableView];
        NSIndexPath *swippedIndexPath = [self.tableView indexPathForRowAtPoint:location];
        
        if(swippedIndexPath != nil){
            
            XYZToDoItem *tappedItem = [self.globalContainer.toDoItems objectAtIndex:swippedIndexPath.row];
            [self.tableView deselectRowAtIndexPath:swippedIndexPath animated:NO];
            
            if(tappedItem.completed == YES){
                
                tappedItem.completed = NO;
                
                [self.tableView reloadRowsAtIndexPaths:@[swippedIndexPath] withRowAnimation:UITableViewRowAnimationNone];
                
                NSIndexPath *indexPathOfFirstItem =
                [NSIndexPath indexPathForRow:(0) inSection:0];
                
                [self.tableView moveRowAtIndexPath:swippedIndexPath toIndexPath:indexPathOfFirstItem];
                [self tableView:self.tableView moveRowAtIndexPath:swippedIndexPath toIndexPath:indexPathOfFirstItem];
                [self.globalContainer saveItemsToFile];
            }
            else{
                tappedItem.toBeDeleted = YES;
                [self.globalContainer saveItemsToFile];
                [self.tableView reloadRowsAtIndexPaths:@[swippedIndexPath] withRowAnimation:UITableViewRowAnimationNone];
                
            }
        }
}


@end
