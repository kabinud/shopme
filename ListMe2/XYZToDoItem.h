//
//  XYZToDoItem.h
//  TableDataBase
//
//  Created by Marcin Kmieć on 15.01.2014.
//  Copyright (c) 2014 Marcin Kmieć. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYZToDoItem : NSObject <NSCoding>
@property NSString *itemName;
@property BOOL completed;
@property BOOL toBeDeleted;
@end
