//
//  XYZFinishShoppingTableViewController.m
//  ListMe2
//
//  Created by Marcin Kmieć on 04.02.2014.
//  Copyright (c) 2014 BQDev. All rights reserved.
//

#import "XYZFinishShoppingTableViewController.h"
#import "XYZToDoItem.h"


@interface XYZFinishShoppingTableViewController () <UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UITextField *totalPaidField;

@property XYZGlobalContainer *globalContainer;

@end

@implementation XYZFinishShoppingTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.totalPaidField.delegate = self;
    
    self.globalContainer = [XYZGlobalContainer globalContainer];
    [self createCustomBackButton];
    //swipe gesture for custom back button
    self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
}
- (void)viewWillAppear:(BOOL)animated{
    [self.totalPaidField becomeFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    NSString *decimalSymbol = [formatter decimalSeparator];
    
    NSArray  *arrayOfString = [newString componentsSeparatedByString:decimalSymbol];
    
    if([arrayOfString count]>1){
        if ([[arrayOfString objectAtIndex:1] length] < 3 ){
                return YES;
        }
        else{
            return NO;
        }
    }

    return YES;
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
    return [self.globalContainer.toDoItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    XYZToDoItem *item = [self.globalContainer.toDoItems objectAtIndex:indexPath.row];
    
    UIFont *myFont = [ UIFont fontWithName: @"Helvetica" size: 15.0 ];
    cell.textLabel.font  = myFont;
    
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


#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"TakePictureSegue"]) {
        
        NSNumberFormatter * formatter = [NSNumberFormatter new];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        
        NSNumber * totalPaid = [formatter numberFromString:self.totalPaidField.text];
        
        [self.globalContainer.listToBeArchived setTotalPaidAmount:totalPaid];
        
    }
    
}



@end
