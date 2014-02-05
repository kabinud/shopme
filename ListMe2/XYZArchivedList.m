//
//  XYZArchivedList.m
//  Shopping Mate
//
//  Created by Marcin Kmieć on 24.01.2014.
//  Copyright (c) 2014 Marcin Kmieć. All rights reserved.
//

#import "XYZArchivedList.h"
#import "XYZToDoItem.h"

@implementation XYZArchivedList


- (id)initWithListAndSetTheRestAutomatically: (NSMutableArray *)incomingList{
    self = [super init];
    
    if (self) {
        
        _archivedList = [NSMutableArray new];
        for(int i = 0; i<incomingList.count; i++){
         //   if(((XYZToDoItem *)[incomingList objectAtIndex:i]).completed){
            [_archivedList addObject:[incomingList objectAtIndex:i]];
           // }
        }
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        //[formatter setDateFormat:@"yyyy-MM-dd 'at' HH:mm"];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *date = [NSDate date];
        NSString *stringFromDate = [formatter stringFromDate:date];
        
        _name = [stringFromDate mutableCopy];
        _finishedShoppingDate = date;
    
        
    }
    
    return self;
}

- (void) setTotalPaidAmount:(NSNumber *)totalPaid{
        NSNumberFormatter *currencyFormatter = [[NSNumberFormatter alloc] init];
        [currencyFormatter setLocale:[NSLocale currentLocale]];
        [currencyFormatter setMaximumFractionDigits:2];
        [currencyFormatter setMinimumFractionDigits:2];
        [currencyFormatter setAlwaysShowsDecimalSeparator:YES];
        [currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];

        self.totalPaidString = [currencyFormatter stringFromNumber:totalPaid];
    
}

#pragma mark NSCoding


- (void) encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:_archivedList forKey:@"ArchivedList"];
    [encoder encodeObject:_finishedShoppingDate forKey:@"FinishedShoppingDate"];
    [encoder encodeObject:_name forKey:@"Name"];
    [encoder encodeObject:_totalPaid forKey:@"TotalPaid"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if(self)
    {
        _archivedList = [[decoder decodeObjectForKey: @"ArchivedList"] mutableCopy];
        _finishedShoppingDate  = [[decoder decodeObjectForKey: @"FinishedShoppingDate"] copy];
        _name = [[decoder decodeObjectForKey: @"Name"] copy];
        _totalPaid = [[decoder decodeObjectForKey: @"TotalPaid"] copy];

    }
    return self;
}



@end
