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
#import "NSString+IsEmpty.h"

@interface XYZTopEditTableViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *pencilAddButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;


@end

@implementation
XYZTopEditTableViewController

- (IBAction)pencilButtonPressed:(id)sender {
    [self addData: self.editField.text];
    self.editField.text = nil;
    [self updateHistoricalItemsArrayForTableViewDuringEditing:@""];
    [self.tableView reloadData];
}


- (void)updateHistoricalItemsArrayForTableViewDuringEditing:(NSString *) searchedString
{
    [self.historicalItemsToShow removeAllObjects];
    [self sortHistoricalItems];
    
    if([searchedString isEqualToString:@""]){
        for(XYZToDoItem *item in self.globalContainer.historicalItems){
            [self.historicalItemsToShow addObject:item];
        }
    }
    else{
        for(XYZToDoItem *item in self.globalContainer.historicalItems){
            if ([item.itemName rangeOfString:searchedString options:NSCaseInsensitiveSearch].location != NSNotFound){
                [self.historicalItemsToShow addObject:item];
            }
        }
    }

}

- (IBAction)editingChanged:(id)sender {
    [self updateHistoricalItemsArrayForTableViewDuringEditing:self.editField.text];
    [self.tableView reloadData];
}

- (IBAction)editingDidBegin:(id)sender {
    [self updateHistoricalItemsArrayForTableViewDuringEditing:@""];
    [self.tableView reloadData];
}




-(void)sortHistoricalItems
{
    NSSortDescriptor *descriptorAlphabet = [[NSSortDescriptor alloc] initWithKey:@"itemName" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)];
    
    [self.globalContainer.historicalItems sortUsingDescriptors:[NSArray arrayWithObjects:descriptorAlphabet, nil]];
    
    NSLog(@"Sorting");
}

- (void)addHistoricalItem:(XYZToDoItem *)itemToAdd{
    BOOL itemAlreadyInHistory = NO;
    
    for(XYZToDoItem *item in self.globalContainer.historicalItems){
        if([item.itemName isEqualToString:itemToAdd.itemName]){
            itemAlreadyInHistory = YES;
            break;
        }
    }
    
    if(!itemAlreadyInHistory){
        [self.globalContainer.historicalItems insertObject:itemToAdd atIndex:0];
        [self.globalContainer saveHistoricalItemsToFile];
    }
    NSLog(@"His added");
}



- (void)addData: (NSString *) text {
    if(![self.editField.text isStringEmpty]){
    
        XYZToDoItem *toDoItem = [XYZToDoItem new];
        toDoItem.itemName = self.editField.text;
        toDoItem.completed = NO;
        
        [self.globalContainer.toDoItems insertObject:toDoItem atIndex:0];
        [self.globalContainer saveItemsToFile];
        
        [self addHistoricalItem:toDoItem];
        
        if(self.itemAdded == NO){
            self.itemAdded = YES;
        }
        [self.globalContainer updateBadge];
    }
    //if data empty go back to main view
    else{
        [self dismissViewControllerAnimated:NO completion:^{}];
    }
    
    
  
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if(textField == self.editField){
        [self addData: textField.text];
        textField.text = nil;
        [self updateHistoricalItemsArrayForTableViewDuringEditing:@""];
        [self.tableView reloadData];
    }
    return YES;
}



- (IBAction)backButtonPressed:(id)sender {
    [self addData: self.editField.text];
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
    self.historicalItemsToShow = [NSMutableArray new];
    self.itemAdded = NO;

    if(self.editFieldAutoResponderAllowed){
        [self.editField becomeFirstResponder];
    }
    
    self.editField.delegate = self;

    
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) {
        self.pencilAddButton.tintColor = [UIColor magentaColor];
        self.doneButton.tintColor = [UIColor blackColor];
    }
    else {
        self.pencilAddButton.tintColor = [UIColor whiteColor];
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if(section == 0 ){
        if(self.itemAdded){
            return 1;
        }
        else{
            return 0;
        }
    }
    else{
        return [self.historicalItemsToShow count];
    }
}

- (void)checkButtonTapped:(id)sender event:(id)event
{
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint: currentTouchPosition];
    
    if (indexPath != nil)
    {
        [self.globalContainer.historicalItems removeObject:[self.globalContainer.historicalItems objectAtIndex:indexPath.row]];
        [self.globalContainer saveHistoricalItemsToFile];
        [self updateHistoricalItemsArrayForTableViewDuringEditing:self.editField.text];
        [self.tableView reloadData];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if([indexPath section] == 0 ){
        
        NSString *CellIdentifier = @"CellSubtitled";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
        
        XYZToDoItem *item = [self.globalContainer.toDoItems objectAtIndex:indexPath.row];
        
        cell.textLabel.text = item.itemName;
        cell.detailTextLabel.text = @"added";
//        
//        UIFont *myFont = [ UIFont fontWithName: @"Helvetica" size: 14.0 ];
//        cell.textLabel.font  = myFont;
    }
    else{
        
        NSString *CellIdentifier = @"Cell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
        
        XYZToDoItem *item = [self.historicalItemsToShow objectAtIndex:indexPath.row];
        
        cell.textLabel.text = item.itemName;
        
        UIFont *myFont = [ UIFont fontWithName: @"Helvetica" size: 14.0 ];
        cell.textLabel.font  = myFont;
        cell.textLabel.textColor = [UIColor grayColor];
        
        UIImage *image = [UIImage imageNamed:@"clear-button-114.png"];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        CGRect frame = CGRectMake(0.0, 0.0, 42.0, 42.0);
        button.frame = frame;
        [button setBackgroundImage:image forState:UIControlStateNormal];
        [button addTarget:self action:@selector(checkButtonTapped:event:)  forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor = [UIColor clearColor];
        cell.accessoryView = button;
    }

    
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
