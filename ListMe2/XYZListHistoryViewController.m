//
//  XYZListHistoryViewController.m
//  ListMe2
//
//  Created by Marcin Kmieć on 06.02.2014.
//  Copyright (c) 2014 BQDev. All rights reserved.
//

#import "XYZListHistoryViewController.h"
#import "XYZOberViewController.h"
#import "XYZGlobalContainer.h"
#import "XYZArchivedList.h"
#import "XYZHistoryListDetailsViewController.h"


@interface XYZListHistoryViewController ()

@property XYZGlobalContainer *globalContainer;

@end

@implementation XYZListHistoryViewController


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"ShowListDetailsSegue"]) {
        XYZHistoryListDetailsViewController *destinationController = (XYZHistoryListDetailsViewController *)segue.destinationViewController;
        
        destinationController.listIndex = [self.tableView indexPathForSelectedRow].row;
      
    }
}


- (IBAction)goBackButtonPressed:(id)sender {
    UINavigationController *nav = (UINavigationController*) self.view.window.rootViewController;
    UIViewController *root = [nav.viewControllers objectAtIndex:0];
    [root performSelector:@selector(returnToRoot)];
    
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)setNavigationBarTitleIcon{
    UIImage *temp = [UIImage imageNamed:@"cartSmall.png"];
    
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, temp.size.width, temp.size.height)];
    [view setBackgroundColor:[UIColor colorWithPatternImage:temp]];
    
    self.navigationItem.titleView = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.globalContainer = [XYZGlobalContainer globalContainer];
    
    [self setNavigationBarTitleIcon];
    
    //removes toolbar border
    self.navigationController.toolbar.clipsToBounds = YES;

}

- (void)viewWillAppear:(BOOL)animated{
    [self.tableView reloadData];
    
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.globalContainer.lists count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    XYZArchivedList *list = [self.globalContainer.lists objectAtIndex:indexPath.row];
    
    cell.textLabel.text = list.name;
    cell.detailTextLabel.text = list.totalPaidString;
    
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
