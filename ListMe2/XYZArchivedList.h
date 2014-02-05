//
//  XYZArchivedList.h
//  Shopping Mate
//
//  Created by Marcin Kmieć on 24.01.2014.
//  Copyright (c) 2014 Marcin Kmieć. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYZArchivedList : NSObject <NSCoding>

@property NSMutableArray *archivedList;
@property NSDate *finishedShoppingDate;
@property NSMutableString *name;
@property NSNumber *totalPaid;
@property NSString *totalPaidString;
- (id)initWithListAndSetTheRestAutomatically: (NSMutableArray *)incomingList;
- (void)setTotalPaidAmount:(NSNumber *)totalPaidAmount;
@end
