//
//  DDGCloudPreferences.m
//  DDGPreferences
//
//  Created by Andrew Donoho on 2012/10/19.
//  Copyright (c) 2012-2014 Donoho Design Group, L.L.C. All rights reserved.
//

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

#if !__has_feature(objc_arc)
#  warning Please compile this class with ARC (-fobjc-arc).
#endif

#import "DDGPreferences.h"
#include "DDGProperties.h"

#import "DDGCloudPreferences.h"

#import <objc/runtime.h>

#define CLASS_DEBUG 1
#import "DDGMacros.h"

@interface DDGCloudPreferences ()

@property (getter = isDirty, nonatomic) BOOL dirty;
@property (strong, nonatomic) DDGPreferences *preferences;

@end

@implementation DDGCloudPreferences

- (void) dealloc {
    
	DDGTrace();
	
    [self removePreferencesObserver];
    
    [NSNotificationCenter.defaultCenter removeObserver: self];
    
} // -dealloc


- (DDGCloudPreferences *) initWithPreferences: (DDGPreferences *) preferences {
    
    self = [super init];
    
    if (self) {
        
        self.preferences = preferences;
        
        [self    readPreferences];
        [self observePreferences];

        [self readCloud]; // Depends upon -observePreferences being active.
        [self observeNotifications];
        
        DDGDesc(NSUbiquitousKeyValueStore.defaultStore.dictionaryRepresentation);
    }
    return self;
    
} // -initWithPreferences:


#pragma mark - KVO methods.


static void *ddgCloudPreferencesContext = &ddgCloudPreferencesContext;

- (void) observeValueForKeyPath: (NSString *) keyPath
					   ofObject: (id<NSObject>) object
						 change: (NSDictionary *) change
						context: (void *) context {

    if (context == ddgCloudPreferencesContext) {

        id<NSObject> value = [change valueForKey: NSKeyValueChangeNewKey];

        DDGLog(@"Object: %@, Key: %@, Value: %@.", NSStringFromClass(object.class), keyPath, value);

        if (value && [self.preferences isEqual: object]) {

            if ([keyPath isEqualToString: kDirtyKey]) {

                // When preferences become clean, write to the cloud.
                if (![(NSNumber *)value boolValue] && self.isDirty) {

                    [self writeCloud];
                }
            }
            else {

                id<NSObject> cloudValue = [self valueForKeyPath: keyPath];

                if (cloudValue && ![value isEqual: cloudValue]) {

                    [self setValue: value forKeyPath: keyPath];
                    
                    self.dirty = YES;
                }
            }
        }
    }

} // -observeValueForKeyPath:ofObject:change:context:


- (void) observePreferences {

	DDGTrace();

	unsigned int     propertyCount = 0;
	objc_property_t *propertyList  = class_copyPropertyList(self.class, &propertyCount);

	// Loop through properties.
	for (unsigned int i = 0; i < propertyCount; i++) {

        const char *propName = property_getName(propertyList[i]);

        if (supportedPropName(propName)) {

            NSString *name = [NSString.alloc initWithBytesNoCopy: (void *)propName
                                                          length: strlen( propName)
                                                        encoding: NSUTF8StringEncoding
                                                    freeWhenDone: NO];
            [self.preferences addObserver: self
                               forKeyPath: name
                                  options: NSKeyValueObservingOptionNew
                                  context: ddgCloudPreferencesContext];
        }
	}
	free(propertyList), propertyList = NULL;

    [self.preferences addObserver: self
                       forKeyPath: kDirtyKey
                          options: NSKeyValueObservingOptionNew
                          context: ddgCloudPreferencesContext];

} // -observePreferences


- (void) removePreferencesObserver {

	DDGTrace();

	unsigned int     propertyCount = 0;
	objc_property_t *propertyList  = class_copyPropertyList(self.class, &propertyCount);

	// Loop through properties.
	for (unsigned int i = 0; i < propertyCount; i++) {
		
        const char *propName = property_getName(propertyList[i]);

        if (supportedPropName(propName)) {

            NSString *name = [NSString.alloc initWithBytesNoCopy: (void *)propName
                                                          length: strlen( propName)
                                                        encoding: NSUTF8StringEncoding
                                                    freeWhenDone: NO];
            [self.preferences removeObserver: self
                                  forKeyPath: name
                                     context: ddgCloudPreferencesContext];
        }
	}
	free(propertyList), propertyList = NULL;

    [self.preferences removeObserver: self
                          forKeyPath: kDirtyKey
                             context: ddgCloudPreferencesContext];

} // -removePreferencesObserver


#pragma mark - Data synchronization methods.


- (void) setNilValueForKey: (NSString *) key {
    
    DDGDesc(key);
    
} // -setNilValueForKey:


- (void) readPreferences {

    unsigned int     propertyCount = 0;
	objc_property_t *propertyList  = class_copyPropertyList(self.class, &propertyCount);

	// Loop through properties.
	for (unsigned int i = 0; i < propertyCount; i++) {

        const char *propName = property_getName(propertyList[i]);

        if (supportedPropName(propName)) {

            NSString *name = [NSString.alloc initWithBytesNoCopy: (void *)propName
                                                          length: strlen( propName)
                                                        encoding: NSUTF8StringEncoding
                                                    freeWhenDone: NO];
            [self setValue: [self.preferences valueForKey: name] forKey: name];
        }
	}
	free(propertyList), propertyList = NULL;

    self.dirty = NO;

} // -readPreferences


- (void) readCloud {

    NSUbiquitousKeyValueStore *keyStore = NSUbiquitousKeyValueStore.defaultStore;

    [keyStore synchronize];

    unsigned int     propertyCount = 0;
	objc_property_t *propertyList  = class_copyPropertyList(self.class, &propertyCount);
	const char      *className     = class_getName(self.class);

	// Loop through properties.
	for (unsigned int i = 0; i < propertyCount; i++) {
		
        const char *propName = property_getName(propertyList[i]);

        if (supportedPropName(propName)) {

            NSString *cloudName = [NSString stringWithFormat: @"%s_%s", className, propName];
            NSString *name = [NSString.alloc initWithBytesNoCopy: (void *)propName
                                                          length: strlen( propName)
                                                        encoding: NSUTF8StringEncoding
                                                    freeWhenDone: NO];
            id value = [keyStore objectForKey: cloudName];

            if (value) {

                // Due to KVO observation, these values will be set in ourself too.
                [self.preferences setValue: value forKey: name];
            }
        }
	}
	free(propertyList), propertyList = NULL;

    self.dirty = NO;

} // -readCloud


- (void) writeCloud {

    NSUbiquitousKeyValueStore *keyStore = NSUbiquitousKeyValueStore.defaultStore;
    unsigned int     propertyCount = 0;
    objc_property_t *propertyList  = class_copyPropertyList(self.class, &propertyCount);
    const char      *className     = class_getName(self.class);

    // Loop through properties.
    for (unsigned int i = 0; i < propertyCount; i++) {

        const char *propName = property_getName(propertyList[i]);

        if (supportedPropName(propName)) {

            NSString *cloudName = [NSString stringWithFormat: @"%s_%s", className, propName];
            NSString *name = [NSString.alloc initWithBytesNoCopy: (void *)propName
                                                          length: strlen( propName)
                                                        encoding: NSUTF8StringEncoding
                                                    freeWhenDone: NO];
            id      value = [self      valueForKey: name];
            id cloudValue = [keyStore objectForKey: cloudName];

            if (![value isEqual: cloudValue]) {

                [keyStore setObject: value forKey: cloudName];
            }
        }
    }
    free(propertyList), propertyList = NULL;

    [keyStore synchronize];

    self.dirty = NO;

} // -writeCloud


#pragma mark - UIApplication and iCloud notification methods.


#define kCloudKeyValueStoreDidChangeExternally  (@selector(cloudKeyValueStoreDidChangeExternally:))
- (void) cloudKeyValueStoreDidChangeExternally: (NSNotification *) notification {
	
    [self readCloud];

    DDGDesc(NSUbiquitousKeyValueStore.defaultStore.dictionaryRepresentation);

} // -cloudKeyValueStoreDidChangeExternally:


#define kApplicationWillEnterForeground  (@selector(applicationWillEnterForeground:))
- (void) applicationWillEnterForeground: (NSNotification *) notification {
	
    [self readCloud];
	
    DDGDesc(NSUbiquitousKeyValueStore.defaultStore.dictionaryRepresentation);

} // -applicationWillEnterForeground:


- (void) observeNotifications {
    
    DDGTrace();
    
    NSNotificationCenter *nc = NSNotificationCenter.defaultCenter;
    
    [nc removeObserver: self];
    
    [nc addObserver: self
           selector:       kCloudKeyValueStoreDidChangeExternally
               name: NSUbiquitousKeyValueStoreDidChangeExternallyNotification
             object: NSUbiquitousKeyValueStore.defaultStore];
    
    [nc addObserver: self
           selector:  kApplicationWillEnterForeground
               name: UIApplicationWillEnterForegroundNotification
             object: nil];
    
} // -observeNotifications;

@end
