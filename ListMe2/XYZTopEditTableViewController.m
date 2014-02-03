//
//  XYZTopEditTableViewController.m
//  ListMe2
//
//  Created by Marcin Kmieć on 02.02.2014.
//  Copyright (c) 2014 BQDev. All rights reserved.
//

#import "XYZTopEditTableViewController.h"
#import "XYZGlobalContainer.h"
#import "XYZToDoItem.h"

@interface XYZTopEditTableViewController ()
@property (weak, nonatomic) IBOutlet UITextField *editField;


@end

@implementation
XYZTopEditTableViewController

- (BOOL)firstUseItemsRemoved{
    for(XYZToDoItem *item in self.globalContainer.toDoItems){
        if([item.itemName isEqualToString:@"Swipe right to mark as completed"]
           || [item.itemName isEqualToString:@"Swipe left to undo"]){
            return NO;
        }
    }
    return YES;
}

- (IBAction)editingDidEnd:(id)sender {
}
- (IBAction)didEndOnExit:(id)sender {
    if(self.editField.text.length>0){
        
        NSLog(@"didendoneit");
        
        XYZToDoItem *toDoItem = [XYZToDoItem new];
        toDoItem.itemName = self.editField.text;
        toDoItem.completed = NO;
        
        [self.globalContainer.toDoItems insertObject:toDoItem atIndex:0];
        [self.globalContainer saveItemsToFile];
        
         NSLog(@"Count = %d", [self.globalContainer.toDoItems count]);
        
//        NSManagedObjectContext *context = [self managedObjectContext];
//        
//        
//        if(![self isThisItemInHistoryItems:self.textField.text]){
//            HistoricalItem *historicalItem = [NSEntityDescription
//                                              insertNewObjectForEntityForName:@"HistoricalItem"
//                                              inManagedObjectContext:context];
//            historicalItem.name = self.textField.text;
//        }
//        
//        NSError *error;
//        if (![context save:&error]) {
//            NSLog(@"Could not save data: %@", [error localizedDescription]);
//        }
//        
//        
//        [self updateHistoricalItemsArrayForTableView];
        
    }
    
    if([self firstUseItemsRemoved] && [self.globalContainer.toDoItems count] > 0){
        [UIApplication sharedApplication].applicationIconBadgeNumber=[self.globalContainer.toDoItems count];
    }
    else{
        [UIApplication sharedApplication].applicationIconBadgeNumber=0;
    }
    
       [self dismissViewControllerAnimated:NO completion:^{}];
    
}


- (IBAction)backButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:NO completion:^{}];
}


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
  
 
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.globalContainer = [XYZGlobalContainer globalContainer];

    if(self.editFieldAutoResponderAllowed){
        [self.editField becomeFirstResponder];
    }
    
    if(self.globalContainer.toDoItems == nil)
    {
        self.globalContainer.toDoItems = [NSMutableArray new];
    }


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
