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
        
        destinationController.imageToShow = self.receiptImage;
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
    self.list = [self.globalContainer.lists objectAtIndex:self.listIndex];

    [self createCustomBackButton];
    //swipe gesture for custom back button
    self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
    
    if(self.list.imageName != nil){
        self.receiptImage = [self.globalContainer readImageFromFile:self.list.imageName];
    }
    
    [self setNavigationBarTitleIcon];
    
    //removes toolbar border
    self.navigationController.toolbar.clipsToBounds = YES;
   
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
    if(self.list.imageName == nil){
        return 1;
    }
    else{
        return 2;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.list.imageName == nil){
        return [self.list.archivedList count];
    }
    else{
        if(section == 0){
            return 1;
        }
        else{
            return [self.list.archivedList count];
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if(self.list.imageName == nil){
        static NSString *CellIdentifier = @"Cell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        cell.textLabel.text = ((XYZToDoItem* )([self.list.archivedList objectAtIndex:indexPath.row])).itemName;
    }
    else{
        if(indexPath.section == 0){
          
            static NSString *CellIdentifier = @"CellImage";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            
            UIImageView *imageView = (UIImageView *)[cell viewWithTag:1];
            imageView.image = self.receiptImage;
            
        }
        else{
            static NSString *CellIdentifier = @"Cell";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            
            cell.textLabel.text = ((XYZToDoItem* )([self.list.archivedList objectAtIndex:indexPath.row])).itemName;
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
     return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.list.imageName == nil){
        return [self.tableView rowHeight];
    }
    else{
        if(indexPath.section == 0){
            return 200;
        }
        else{
            return [self.tableView rowHeight];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.list.imageName != nil){
        if(indexPath.section == 0 && indexPath.row == 0){
             [self performSegueWithIdentifier: @"ImageLargeSegue" sender: self];
        }
    }
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
