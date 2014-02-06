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
    NSString *finalPath = [documentsDirectory stringByAppendingPathComponent:@"historicalLists.plist"];
    [NSKeyedArchiver archiveRootObject:lists toFile:finalPath ];
}

- (void)readListsFromFile{
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *finalPath = [documentsDirectory stringByAppendingPathComponent:@"historicalLists.plist"];
    NSMutableArray* arr = [NSKeyedUnarchiver unarchiveObjectWithFile:finalPath];
    if(arr!=nil){
        self.lists = arr;
    }
    else{
        self.lists = [NSMutableArray new];
    }
}

- (void)writeImage: (UIImage *)image{

    NSString *uniqueFileName = self.listToBeArchived.imageName;
    
    NSString  *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    jpgPath = [jpgPath stringByAppendingFormat:@"/%@",uniqueFileName];
    jpgPath = [jpgPath stringByAppendingString:@".jpg"];
    

    
    //save it on a thread
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       //saving image
        BOOL result = [UIImageJPEGRepresentation(image, 0.5) writeToFile:jpgPath atomically:YES];
       //on thread exit
        dispatch_async(dispatch_get_main_queue(), ^{
           
            if(result == NO){
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error" message:@"Unable to save the photo" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
        });
    });
    
// Print documents directory to see if file has saved
    
//    NSError *error;
//    NSFileManager *fileMgr = [NSFileManager defaultManager];
//
//    NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
//
//    NSLog(@"Documents directory: %@", [fileMgr contentsOfDirectoryAtPath:documentsDirectory error:&error]);
}


- (UIImage *)readImageFromFile: (NSString *)uniqueFileName{
    
    NSString  *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    jpgPath = [jpgPath stringByAppendingFormat:@"/%@",uniqueFileName];
    jpgPath = [jpgPath stringByAppendingString:@".jpg"];
    
    NSData *imgData = [NSData dataWithContentsOfFile:jpgPath];
    UIImage *image= [UIImage imageWithData:imgData];
    
    return image;
    
}

- (BOOL) deleteImage: (NSString *)uniqueFileName{
    
    NSString  *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    jpgPath = [jpgPath stringByAppendingFormat:@"/%@",uniqueFileName];
    jpgPath = [jpgPath stringByAppendingString:@".jpg"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL result = [fileManager removeItemAtPath:jpgPath error:NULL];
    
    return result;
    
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
