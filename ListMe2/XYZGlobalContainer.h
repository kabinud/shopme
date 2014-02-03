//
//  XYZGlobalContainer.h
//  hgjhg
//
//  Created by Marcin Kmieć on 24.01.2014.
//  Copyright (c) 2014 Sample Name. All rights reserved.
//

//Singleton for global data sharing
#import <Foundation/Foundation.h>

@interface XYZGlobalContainer : NSObject {
    NSMutableArray *lists;
}


@property (nonatomic, retain) NSMutableArray *lists;
@property NSMutableArray *toDoItems;

+ (id)globalContainer;
- (void)saveListsToFile;
- (void)readListsFromFile;
- (void)saveItemsToFile;
- (void)readItemsFromFile;


@end

