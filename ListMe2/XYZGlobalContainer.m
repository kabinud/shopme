//
//  XYZGlobalContainer.m
//  hgjhg
//
//  Created by Marcin Kmieć on 24.01.2014.
//  Copyright (c) 2014 Sample Name. All rights reserved.
//

#import "XYZGlobalContainer.h"
#import "XYZToDoItem.h"

@implementation XYZGlobalContainer


@synthesize lists;
@synthesize toDoItems;
@synthesize historicalItems;

+ (id)globalContainer {
    static XYZGlobalContainer *sharedGlobalContainer = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedGlobalContainer = [[self alloc] init];
    });
    return sharedGlobalContainer;
}

- (id)init {
    if (self = [super init]) {
        lists = [NSMutableArray new];
    }
    return self;
}

- (void)saveItemsToFile{
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *finalPath = [documentsDirectory stringByAppendingPathComponent:@"toDoItemsGlobal.plist"];
    [NSKeyedArchiver archiveRootObject:toDoItems toFile:finalPath];
}

- (void)readItemsFromFile{
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *finalPath = [documentsDirectory stringByAppendingPathComponent:@"toDoItemsGlobal.plist"];
    NSMutableArray* arr = [NSKeyedUnarchiver unarchiveObjectWithFile:finalPath];
    if(arr!=nil){
        self.toDoItems = arr;
    }
    else{
        self.toDoItems = [NSMutableArray new];
    }
}

- (void)saveHistoricalItemsToFile{
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *finalPath = [documentsDirectory stringByAppendingPathComponent:@"historicalItemsGlobal.plist"];
    [NSKeyedArchiver archiveRootObject:historicalItems toFile:finalPath];
}

- (void)readHistoricalItemsFromFile{
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *finalPath = [documentsDirectory stringByAppendingPathComponent:@"historicalItemsGlobal.plist"];
    NSMutableArray* arr = [NSKeyedUnarchiver unarchiveObjectWithFile:finalPath];
    if(arr!=nil){
        self.historicalItems = arr;
    }
    else{
        self.historicalItems = [NSMutableArray new];
    }
}

- (void)saveListsToFile{
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *finalPath = [documentsDirectory stringByAppendingPathComponent:@"globalData.plist"];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [NSKeyedArchiver archiveRootObject:lists toFile:finalPath ];
        dispatch_async(dispatch_get_main_queue(), ^{
            //call to execute at the thread exit
        });
    });
    
    //BOOL result = [NSKeyedArchiver archiveRootObject:lists toFile:finalPath ];
    
//    if(result==NO){
//        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error" message:@"Unable to save the list" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alert show];
//    }
}

- (void)readListsFromFile{
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *finalPath = [documentsDirectory stringByAppendingPathComponent:@"globalData.plist"];
    NSMutableArray* arr = [NSKeyedUnarchiver unarchiveObjectWithFile:finalPath];
    if(arr!=nil){
        self.lists = arr;
    }
    else{
        self.lists = [NSMutableArray new];
    }
}


- (BOOL)isNotFirstExampleItem: (NSString *)string{
    if([string isEqualToString:@"Swipe right to mark as completed"] || [string isEqualToString:@"Swipe left to undo"]){
        return NO;
    }
    return YES;
}

-(int)howManyPendingItems{
    int count = 0;
    for(XYZToDoItem *item in self.toDoItems){
        if(item.completed == NO && [self isNotFirstExampleItem:item.itemName]){
            count++;
        }
    }
    return count;
}

- (void) updateBadge{
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = [self howManyPendingItems];
    
}


@end
