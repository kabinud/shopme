//
//  XYZMainViewController.m
//  ListMe2
//
//  Created by Marcin Kmieć on 31.01.2014.
//  Copyright (c) 2014 BQDev. All rights reserved.
//

#define SLIDE_TIMING .95

#import "XYZMainViewController.h"
#import "XYZGlobalContainer.h"
#import "XYZToDoItem.h"


@interface XYZMainViewController ()

@end

@implementation XYZMainViewController

//call (void)stoppedScrolling when user lifts their finger
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self stoppedScrolling];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                  willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        [self stoppedScrolling];
    }
}

- (void)stoppedScrolling
{
    [self.delegate closeTopEditPanel];
}
////////////


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(scrollView.contentOffset.y<0){
        [self.delegate bringTopEditPanelToAnExtend:(-1)*scrollView.contentOffset.y];
    }

}


- (void)viewWillAppear:(BOOL)animated {
     NSLog(@"View will appear");
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.globalContainer = [XYZGlobalContainer globalContainer];
    [self.globalContainer readItemsFromFile];
    [self.globalContainer readHistoricalItemsFromFile];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)menuButtonAction:(id)sender {
    
    self.tableView.scrollEnabled = !self.tableView.scrollEnabled;
    [self.delegate bringTopPanel];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.globalContainer.toDoItems count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        return self.tableView.rowHeight;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    static NSString *CellIdentifier = @"Header";
    UITableViewCell *headerView = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    headerView.backgroundColor = [UIColor whiteColor];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    static NSString *CellIdentifier = @"Header";
    UITableViewCell *headerView = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    return headerView.frame.size.height;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.globalContainer updateBadge];
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    

    XYZToDoItem *item = [self.globalContainer.toDoItems objectAtIndex:indexPath.row];
    cell.textLabel.text = item.itemName;
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    if(item.toBeDeleted){
        UIImage *image = [UIImage imageNamed:@"clear-button-114.png"];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        CGRect frame = CGRectMake(0.0, 0.0, 42.0, 42.0);
        button.frame = frame;
        [button setBackgroundImage:image forState:UIControlStateNormal];
        [button addTarget:self action:@selector(checkButtonTapped:event:)  forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor = [UIColor clearColor];
        cell.accessoryView = button;
    }
    else{
        cell.accessoryView = nil;
    }
    
    UIFont *myFont = [ UIFont fontWithName: @"Helvetica" size: 17.0 ];
    cell.textLabel.font  = myFont;
    cell.textLabel.textColor = [UIColor blackColor];
    
    if(item.completed)
    {
        NSDictionary* attributes = @{
                                     NSStrikethroughStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleSingle]
                                     };
        NSAttributedString* attrText = [[NSAttributedString alloc] initWithString:item.itemName attributes:attributes];
        cell.textLabel.attributedText = attrText;
        
    }
    else
    {
        cell.textLabel.text = item.itemName;
    }
    
    return cell;
}

- (void)checkButtonTapped:(id)sender event:(id)event
{
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint: currentTouchPosition];
    
    if (indexPath != nil)
    {
        [self.globalContainer.toDoItems removeObject:[self.globalContainer.toDoItems objectAtIndex:indexPath.row]];
        [self.globalContainer saveItemsToFile];
        [self.tableView reloadData];
    }
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


//
//// Override to support editing the table view.
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        // Delete the row from the data source
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    }   
//    else if (editingStyle == UITableViewCellEditingStyleInsert) {
//        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//    }   
//}





// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    XYZToDoItem *itemToMove = [self.globalContainer.toDoItems objectAtIndex:fromIndexPath.row];
    [self.globalContainer.toDoItems removeObjectAtIndex:fromIndexPath.row];
    [self.globalContainer.toDoItems insertObject:itemToMove atIndex:toIndexPath.row];
    [self.globalContainer saveItemsToFile];
}



// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}

//////////
//get rid of the red delete sign in editing mode
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableview shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}
////////

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
