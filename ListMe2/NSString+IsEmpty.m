//
//  NSString+IsEmpty.m
//  ListMe2
//
//  Created by Marcin Kmieć on 03.02.2014.
//  Copyright (c) 2014 BQDev. All rights reserved.
//

#import "NSString+IsEmpty.h"

@implementation NSString (IsEmpty)

- (BOOL)isStringEmpty {
    
    NSString *string = self;
    
    if([string length] == 0) { //string is empty or nil
        return YES;
    }
    
    if(![[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]) {
        //string is all whitespace
        return YES;
    }
    
    return NO;
}

@end
