//
//  XYZHistoryListDetailsViewController.m
//  ListMe2
//
//  Created by Marcin Kmieć on 06.02.2014.
//  Copyright (c) 2014 BQDev. All rights reserved.
//

#import "XYZHistoryListDetailsViewController.h"
#import "XYZImageFullScreenViewController.h"
#import "XYZToDoItem.h"
#import "XYZGlobalContainer.h"

@interface XYZHistoryListDetailsViewController ()

@property XYZGlobalContainer *globalContainer;
@property UIImage *receiptImage;
@property XYZArchivedList *list;

@end

@implementation XYZHistoryListDetailsViewController
- (IBAction)showImageLargeButtonPressed:(id)sender {
    
    [self performSegueWithIdentifier: @"ImageLargeSegue" sender: self];
  
        
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"ImageLargeSegue"]) {
        XYZImageFullScreenViewController *destinationController = (XYZImageFullScreenViewController *)segue.destinationViewController;
        
        destinationController.imageToShow= self.receiptImage;
    }
}

- (void)createCustomBackButton{
    UIImage *temp=nil;
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0)
    {
        temp = [UIImage imageNamed:@"backButton.png"];
    }
    else
    {
        temp = [[UIImage imageNamed:@"backButton.png"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
    }
    
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithImage:temp style:UIBarButtonItemStyleBordered target:self action:@selector(popBack)];
    
    
    self.navigationItem.leftBarButtonItem = backButtonItem;
    //    self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
}

-(void) popBack {
    [self.navigationController popViewControllerAnimated:YES];
}




- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.globalContainer = [XYZGlobalContainer globalContainer];
    self.list = [self.globalContainer.lists objectAtIndex:self.listIndex];

    [self createCustomBackButton];
    //swipe gesture for custom back button
    self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
    
    
    self.receiptImage = [self.globalContainer readImageFromFile:self.list.imageName];
   
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
    return [self.list.archivedList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = ((XYZToDoItem* )([self.list.archivedList objectAtIndex:indexPath.row])).itemName;
    
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
