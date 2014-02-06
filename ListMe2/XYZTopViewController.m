//
//  XYZTopViewController.m
//  ListMe2
//
//  Created by Marcin Kmieć on 01.02.2014.
//  Copyright (c) 2014 BQDev. All rights reserved.
//

#import "XYZTopViewController.h"


@interface XYZTopViewController ()

@end

@implementation XYZTopViewController
- (IBAction)ShoppingHistoryButtonPressed:(id)sender {
    [self.delegate shoppingHistory];
}


- (IBAction)FinishShoppingButtonPressed:(id)sender {
    
    [self.delegate finishShopping];
    
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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)removeAllItemsButtonPressed:(id)sender {
    
    [self.delegate removeAllItemsFromMainTable];

}



- (IBAction)sendListByEmailButtonPressed:(id)sender {
    [self.delegate sendListByEmail];
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
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return tableView.rowHeight/2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return tableView.rowHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    static NSString *CellIdentifier = @"Header";
    UITableViewCell *headerView = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier;
    
    if(indexPath.row == 0){
        CellIdentifier = @"RemoveButton";
    }
    else if(indexPath.row == 1){
        CellIdentifier = @"EmailButton";
    }
    else if(indexPath.row == 2){
        CellIdentifier = @"ShoppingHistoryButton";
    }
    else if(indexPath.row == 3){
        CellIdentifier = @"FinishShoppingButton";
    }
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    return cell;
}


@end
