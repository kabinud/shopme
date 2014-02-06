//
//  XYZGlobalContainer.h
//  hgjhg
//
//  Created by Marcin Kmieć on 24.01.2014.
//  Copyright (c) 2014 Sample Name. All rights reserved.
//

//Singleton for global data sharing
#import <Foundation/Foundation.h>
#import "XYZArchivedList.h"

@interface XYZGlobalContainer : NSObject

@property (nonatomic, retain) NSMutableArray *lists;
@property NSMutableArray *toDoItems;
@property NSMutableArray *historicalItems;
@property XYZArchivedList *listToBeArchived;

+ (id)globalContainer;
- (void)saveListsToFile;
- (void)readListsFromFile;
- (void)saveItemsToFile;
- (void)readItemsFromFile;
- (void)saveHistoricalItemsToFile;
- (void)readHistoricalItemsFromFile;
- (void)updateBadge;
- (void)writeImage: (UIImage *)image;
- (UIImage *)readImageFromFile: (NSString *)uniqueFileName;

@end


