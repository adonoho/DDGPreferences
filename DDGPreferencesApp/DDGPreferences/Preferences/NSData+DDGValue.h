//
//  NSData+DDGValue.h
//  DDGPreferences
//
//  Created by Andrew Donoho on 2012/10/20.
//  Copyright (c) 2012 Donoho Design Group, L.L.C. All rights reserved.
//

/*
 
 As NSUbiquitousKeyValueStore does not store NSValues, it only supports .plist
 compatible data types. Hence, I extended NSData to cover all of the UIKit
 additions to NSValue. I also incorporated a general mechanism to convert an
 arbitrary NSValue into an NSData. Those methods, +dataWithValue:/-initWithValue:,
 are based upon ideas described by Steffen Itterheim,
 <http://stackoverflow.com/users/201863/learncocos2d>, on Stack Overflow at:
 <http://stackoverflow.com/questions/8447380/how-to-convert-nsvalue-to-nsdata-and-back>.
 
 As with all Stack Overflow contributions, <http://stackoverflow.com/faq#editing>,
 Steffen's code is used under terms specified by the Creative Commons
 Attribution-ShareAlike 3.0 Unported (CC BY-SA 3.0) license:
 <http://creativecommons.org/licenses/by-sa/3.0/>.
 
 */

/*
 
 The below license is the new BSD license with the OSI recommended
 personalizations.
 <http://www.opensource.org/licenses/bsd-license.php>
 
 Copyright (C) 2010-2012 Donoho Design Group, LLC. All Rights Reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are
 met:
 
 * Redistributions of source code must retain the above copyright notice,
 this list of conditions and the following disclaimer.
 
 * Redistributions in binary form must reproduce the above copyright
 notice, this list of conditions and the following disclaimer in the
 documentation and/or other materials provided with the distribution.
 
 * Neither the name of Andrew W. Donoho nor Donoho Design Group, L.L.C.
 may be used to endorse or promote products derived from this software
 without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY DONOHO DESIGN GROUP, L.L.C. "AS IS" AND ANY
 EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
 CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 
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
