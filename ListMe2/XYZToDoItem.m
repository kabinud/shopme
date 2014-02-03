//
//  XYZToDoItem.m
//  TableDataBase
//
//  Created by Marcin Kmieć on 15.01.2014.
//  Copyright (c) 2014 Marcin Kmieć. All rights reserved.
//

#import "XYZToDoItem.h"

@implementation XYZToDoItem

#pragma mark NSCoding

- (id)initWithName: (NSString *)name completed: (BOOL)isCompleted toBeDeleted: (BOOL)delete{
    self = [super init];
    
    if (self) {

        _itemName = name;
        _completed = isCompleted;
        _toBeDeleted = delete;
    }
    
    return self;
}

- (id)init{
    self = [super init];
    
    if (self) {
        _toBeDeleted = NO;
    }
    return self;
}

- (void) encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:_itemName forKey:@"ItemName"];
    [encoder encodeBool:_completed forKey:@"Completed"];
    [encoder encodeBool:_toBeDeleted forKey:@"ToBeDeleted"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    NSString *itemName = [decoder decodeObjectForKey:@"ItemName"];
    BOOL isCompleted  = [decoder decodeBoolForKey:@"Completed"];
    BOOL delete  = [decoder decodeBoolForKey:@"ToBeDeleted"];
    return [self initWithName:itemName completed:isCompleted toBeDeleted:delete];
}

@end
