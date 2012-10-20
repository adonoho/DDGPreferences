//
//  NSData+DDGValue.h
//  DDGPreferences
//
//  Created by Andrew Donoho on 2012/10/20.
//  Copyright (c) 2012 Donoho Design Group, L.L.C. All rights reserved.
//

/*
 
 As NSUbiquitousKeyValueStore does not store NSValues, I need NSData items for common
 structures. Hence, I extended NSData to cover all of the UIKit additions to NSValue.
 
 Based upon ideas and code described by Steffen Itterheim,
 <http://stackoverflow.com/users/201863/learncocos2d>, on Stack Overflow at:
 <http://stackoverflow.com/questions/8447380/how-to-convert-nsvalue-to-nsdata-and-back>.
 
 As with all Stack Overflow contributions, <http://stackoverflow.com/faq#editing>, Steffen's
 code is used under terms specified by the Creative Commons Attribution-ShareAlike 3.0
 Unported (CC BY-SA 3.0) license: <http://creativecommons.org/licenses/by-sa/3.0/>.
 
 */

#import <Foundation/Foundation.h>

@interface NSData (DDGValue)

+ (NSData *) dataWithValue: (NSValue *) value;
- (NSData *) initWithValue: (NSValue *) value;

+ (NSData *) dataWithCGAffineTransform: (CGAffineTransform) transform;
- (NSData *) initWithCGAffineTransform: (CGAffineTransform) transform;
- (CGAffineTransform) CGAffineTransformValue;

+ (NSData *) dataWithCGPoint: (CGPoint) point;
- (NSData *) initWithCGPoint: (CGPoint) point;
- (CGPoint)  CGPointValue;

+ (NSData *) dataWithCGRect: (CGRect) rect;
- (NSData *) initWithCGRect: (CGRect) rect;
- (CGRect)   CGRectValue;

+ (NSData *) dataWithCGSize: (CGSize) size;
- (NSData *) initWithCGSize: (CGSize) size;
- (CGSize)   CGSizeValue;

+ (NSData *) dataWithUIEdgeInsets: (UIEdgeInsets) insets;
- (NSData *) initWithUIEdgeInsets: (UIEdgeInsets) insets;
- (UIEdgeInsets) UIEdgeInsetsValue;

+ (NSData *) dataWithUIOffset: (UIOffset) offset;
- (NSData *) initWithUIOffset: (UIOffset) offset;
- (UIOffset) UIOffsetValue;

@end
