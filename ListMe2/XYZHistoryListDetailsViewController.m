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
#import "XYZOberViewController.h"
#import <MessageUI/MFMailComposeViewController.h>

@interface XYZHistoryListDetailsViewController () <UIActionSheetDelegate, MFMailComposeViewControllerDelegate>

@property XYZGlobalContainer *globalContainer;
@property UIImage *receiptImage;
@property XYZArchivedList *list;

@end

@implementation XYZHistoryListDetailsViewController

- (IBAction)sendEmailButtonPressed:(id)sender {
    
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
        controller.mailComposeDelegate = self;
        [controller setSubject:@"My shopping list"];
        
        NSMutableString *messageBody = [NSMutableString new];
        [messageBody appendString:@"My shopping list:\n\n "];
        for(XYZToDoItem *item in self.list.archivedList) {
            [messageBody appendString:@"- "];
            [messageBody appendString:item.itemName];
            [messageBody appendString:@"\n"];
        }
        
        [controller setMessageBody:messageBody isHTML:NO];
        
        if(self.list.imageName != nil){
            NSString *filename = self.list.imageName;
            
            NSString  *filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
            filePath = [filePath stringByAppendingFormat:@"/%@",filename];
            filePath = [filePath stringByAppendingString:@".jpg"];
            
            NSData *fileData = [NSData dataWithContentsOfFile:filePath];
            
            NSString *mimeType = @"image/jpeg";
            
            filename = [self.list.name stringByAppendingString:@" "];
            filename = [filename stringByAppendingString:self.list.totalPaidString];
            filename = [filename stringByAppendingString:@".jpg"];
            
            
            
            // Add attachment
            [controller addAttachmentData:fileData mimeType:mimeType fileName:filename];
        }
        
        if (controller){
            //bring top panel up and when done proceed to present view controller, which overall looks cool
       
            [self presentViewController:controller animated:YES completion:NULL];
           
            
            
            
        }
    }
    else {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error" message:@"Unable to send e-mail" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }

    
}

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error;
{
    if (result == MFMailComposeResultSent) {
        // NSLog(@"It's away!");
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)removeThisListButtonPressed:(id)sender {
    
    UIActionSheet *popupQuery;
    
    popupQuery = [[UIActionSheet alloc] initWithTitle:@"Do you want to delete this list?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete list"
                                    otherButtonTitles: nil];
    
    popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    popupQuery.tag = 0;
    [popupQuery showInView:self.view];
    
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if(actionSheet.tag == 0){
        if (buttonIndex == 0)
        {
            
            [self.globalContainer deleteImage:self.list.imageName];
            [self.globalContainer.lists removeObjectAtIndex:self.listIndex];
            [self.globalContainer saveListsToFile];
            
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        }
        else if (buttonIndex == 1)
        {
         
        }
    }
    else if (actionSheet.tag == 1){
        if (buttonIndex == 0)
        {
            for(XYZToDoItem *item in self.list.archivedList){
                item.completed = NO;
                item.toBeDeleted = NO;
                [self.globalContainer.toDoItems addObject:item];
                [self.globalContainer saveItemsToFile];
            }
            
            UINavigationController *nav = (UINavigationController*) self.view.window.rootViewController;
            UIViewController *root = [nav.viewControllers objectAtIndex:0];
            [root performSelector:@selector(returnToRoot)];
            
        }
        else if (buttonIndex == 1)
        {
            
        }
    }
    
}


- (IBAction)addAllItemsToMainListButtonPressed:(id)sender {
    UIActionSheet *popupQuery;
    
    popupQuery = [[UIActionSheet alloc] initWithTitle:@"Do you want to add all these items to your current shopping list?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Add"
                                    otherButtonTitles: nil];
    
    popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    popupQuery.tag = 1;
    [popupQuery showInView:self.view];
    
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
    
    UIFont *myFont = [ UIFont fontWithName: @"Helvetica" size: 15.0 ];
    cell.textLabel.font  = myFont;
    cell.textLabel.textColor = [UIColor blackColor];
    
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
