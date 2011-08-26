//
//  DDGPreferences.h
//  DDG Library
//
//  Created by Andrew Donoho on 2010/02/09.
//  Copyright 2010-2011 Donoho Design Group, L.L.C. All rights reserved.
//
//
// Properties must have one of the standard .plist types:
// container types: NSArray or NSDictionary 
// primitive types: NSString, NSData, NSDate or NSNumber or be convertible 
// into an NSNumber by -valueForKey: (i.e. a scalar value, BOOL, int or 
// CGFloat [these scalar types are limited by the .plist spec.]).
//
// There is no support for automatically converting structures to NSValues.
// You must manually convert them to NSData items. This can be done by 
// non-property based accessors. An example is implemented in the sample app.
//

#import <Foundation/Foundation.h>

@interface DDGPreferences : NSObject {
    
@private
	BOOL dirty_;
}
@property(nonatomic, assign, readonly) BOOL preferencesExist;

- (void)  readPreferences;
- (void) writePreferences;

@end
