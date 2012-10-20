//
//  NSData+DDGValue.m
//  DDGPreferences
//
//  Created by Andrew Donoho on 2012/10/20.
//  Copyright (c) 2012 Donoho Design Group, L.L.C. All rights reserved.
//

/*
 
 Based upon ideas and code described by Steffen Itterheim, <http://stackoverflow.com/users/201863/learncocos2d>,
 on Stack Overflow at: <http://stackoverflow.com/questions/8447380/how-to-convert-nsvalue-to-nsdata-and-back>.
 
 As with all Stack Overflow contributions, Steffen's code is used under terms specified by the Creative Commons 
 Attribution-ShareAlike 3.0 Unported (CC BY-SA 3.0) license: <http://creativecommons.org/licenses/by-sa/3.0/>.
 
 */

#if !__has_feature(objc_arc)
#  error Please compile this class with ARC (-fobjc-arc).
#endif

#import "NSData+DDGValue.h"

@implementation NSData (DDGValue)

+ (NSData *) dataWithValue: (NSValue *) value {
    
    return [self.alloc initWithValue: value];

} // -dataWithValue:


- (NSData *) initWithValue: (NSValue *) value {
    
    NSUInteger size = 0;
    
    NSGetSizeAndAlignment(value.objCType, &size, NULL);
    
    void *valueData = malloc(size);
    
    [value getValue: valueData];

    return (self = [self initWithBytesNoCopy: valueData length: size freeWhenDone: YES]);
    
} // -initWithValue:

@end
