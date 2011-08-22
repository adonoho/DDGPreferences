//
//  DDGPreferences.m
//  DDG Library
//
//  Created by Andrew Donoho on 2010/02/09.
//  Copyright 2010-2011 Donoho Design Group, L.L.C. All rights reserved.
//

#import "DDGPreferences.h"

#import <objc/runtime.h>

//#define CLASS_DEBUG 1
#import "DDGMacros.h"

@interface DDGPreferences () 

@property(nonatomic, readonly) NSArray *settingsKeys;

- (void) observeProperties;
- (void) removeSelfObserver;

- (void) observeNotifications;

- (void) readSettingsDefaultValues;

@end

@implementation DDGPreferences

@dynamic preferencesExist;
@dynamic settingsKeys;

- (void) dealloc {
    
	DDGTrace();
	
    [self removeSelfObserver];
    
    [[NSNotificationCenter defaultCenter] removeObserver: self];
    
	[super dealloc];
    
} // -dealloc


- (BOOL) preferencesExist {
	
	DDGTrace();
	
	unsigned int     propertyCount = 0;
	objc_property_t *propertyList  = class_copyPropertyList([self class], &propertyCount);
	NSString        *className     = [NSString stringWithUTF8String: class_getName([self class])];
	NSUserDefaults  *defaults      = [NSUserDefaults standardUserDefaults];
	
	DDGDesc(defaults.dictionaryRepresentation);
	
    NSArray *settingsKeys = self.settingsKeys;
    
    BOOL exists = NO;
    
	// Loop through properties.
	for (unsigned int i = 0; i < propertyCount; i++) {
		
		objc_property_t property = propertyList[i];
		NSString       *key      = [NSString stringWithUTF8String: property_getName(property)];
		NSString       *prefKey  = [NSString stringWithFormat: @"%@_%@", className, key];
		
        if (settingsKeys && ([settingsKeys indexOfObject: key] != NSNotFound)) { continue; }
        
        if ([defaults objectForKey: prefKey]) {
            
            exists = YES;
            break;
        }
	}
	free(propertyList); propertyList = NULL;
    
    return exists;
	
} // -preferencesExist


- (id) init {
	
	DDGTrace();
	
	self = [super init];
	
	if (self) {
		
		[self observeProperties];
        [self observeNotifications];

        [self readSettingsDefaultValues];
		[self readPreferences];
    }
	return self;
	
} // -init


#pragma mark -
#pragma mark NSUserDefaults Methods


static NSString *const  kKey           = @"Key";
static NSString *const  kDefaultValue  = @"DefaultValue";
static NSString *const  kSettings      = @"Settings.bundle";
static NSString *const  kRoot          = @"Root.plist";
static NSString *const  kPrefSpecifier = @"PreferenceSpecifiers";

- (NSMutableDictionary *) defaultSettings {
	// Settings are always associated with this class, Preferences.
	// Each setting is named identically to a property.
	
	DDGTrace();
	
	NSString *path = nil;
	path = [[NSBundle mainBundle] bundlePath];
	path = [path stringByAppendingPathComponent: kSettings];
	path = [path stringByAppendingPathComponent: kRoot];
	
	NSDictionary  *settingsDict = [NSDictionary dictionaryWithContentsOfFile: path];
	
	if (settingsDict) {
		
		NSArray  *prefSpecifierArray = [settingsDict objectForKey: kPrefSpecifier];
		
		NSMutableDictionary  *items = [NSMutableDictionary dictionaryWithCapacity: [prefSpecifierArray count]];
		
		for (NSDictionary *pref in prefSpecifierArray) {
			
			NSString *key = [pref valueForKey: kKey];
			
			if (key) {
				
				[items setValue: [pref valueForKey: kDefaultValue] forKey: key];
			}
		}
		return items;
	}
	return nil;
	
} // -defaultSettings


- (NSArray *) settingsKeys {

	DDGTrace();
	
    return [[self defaultSettings] allKeys];
    	
} // -settingsKeys


- (void) readSettingsDefaultValues {
	
	DDGTrace();
	
	NSMutableDictionary *items = [self defaultSettings];
	
	if (items.count) {
		
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString       *selfName = [NSString stringWithUTF8String: class_getName([self class])];
        
        [defaults registerDefaults: items];
        
        for (NSString *key in items.allKeys) {
            
            NSString *prefKey = [NSString stringWithFormat: @"%@_%@", selfName, key];
            
            if (![defaults objectForKey: prefKey]) {
                
                id value = [items valueForKey: key];
                
                [self     setValue:  value forKey: key];
                [defaults setObject: value forKey: prefKey];
            }
        }
	}
	
} // -readSettingsDefaultValues


- (void) readSettings {
	
	DDGTrace();
	
	NSArray *keys = [self settingsKeys];
	
	if (keys.count) {
		
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString       *selfName = [NSString stringWithUTF8String: class_getName([self class])];
        
        for (NSString *key in keys) {
            
            NSString *prefKey = [NSString stringWithFormat: @"%@_%@", selfName, key];

            id value = [defaults objectForKey: key];
            id pref  = [defaults objectForKey: prefKey];
            
            if (pref && ![value isEqual: pref]) {
                
                DDGDesc(key);
                DDGDesc(value);
                DDGDesc(pref);
                DDGDesc(self);

                // Settings overwrite the preferences.
                [self     setValue:  value forKey: key];
                [defaults setObject: value forKey: prefKey];
            }
        }
	}
	
} // -readSettings


- (void) writeSettings {
	
	DDGTrace();
	
	NSArray *keys = [self settingsKeys];
	
	if (keys.count) {
		
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString       *selfName = [NSString stringWithUTF8String: class_getName([self class])];
        
        DDGDesc(self);

        for (NSString *key in keys) {
            
            NSString *prefKey = [NSString stringWithFormat: @"%@_%@", selfName, key];

            id value = [defaults objectForKey: key];
            id pref  = [defaults objectForKey: prefKey];
            
            if (![value isEqual: pref]) {
            
                [defaults setObject: pref forKey: key];
            }
        }
	}
	
} // -writeSettings


#pragma mark - Property Reading/Writing Methods


- (void) setNilValueForKey: (NSString *) key {
    
    DDGDesc(key);
    
} // -setNilValueForKey:


- (void) readProperties {
	
	DDGTrace();
	
	unsigned int     propertyCount = 0;
	objc_property_t *propertyList  = class_copyPropertyList([self class], &propertyCount);
	NSString        *className     = [NSString stringWithUTF8String: class_getName([self class])];
	NSUserDefaults  *defaults      = [NSUserDefaults standardUserDefaults];
	
	DDGDesc(defaults.dictionaryRepresentation);
	
	// Loop through properties.
	for (unsigned int i = 0; i < propertyCount; i++) {
		
		objc_property_t property = propertyList[i];
		NSString       *key      = [NSString stringWithUTF8String: property_getName(property)];
		NSString       *prefKey  = [NSString stringWithFormat: @"%@_%@", className, key];
		
        id value = [self     valueForKey:  key];
        id pref  = [defaults objectForKey: prefKey];
        
        if (pref && ![value isEqual: pref]) {
            
            [self setValue: pref forKey: key];
        }
	}
	free(propertyList); propertyList = NULL;
	
} // -readProperties


- (void) readPreferences {
	
	DDGTrace();
	
	// Allow the settings to overwrite the properties.
	[self readSettings];

	[self readProperties];
	
} // readPreferences


- (void) writeProperties {
	
	DDGTrace();
	
	unsigned int     propertyCount = 0;
	objc_property_t *propertyList  = class_copyPropertyList([self class], &propertyCount);
	NSString        *className     = [NSString stringWithUTF8String: class_getName([self class])];
	NSUserDefaults  *defaults      = [NSUserDefaults standardUserDefaults];
	
	DDGDesc(defaults.dictionaryRepresentation);
	
	// Loop through properties.
	for (unsigned int i = 0; i < propertyCount; i++) {
		
		objc_property_t property = propertyList[i];
		NSString       *key      = [NSString stringWithUTF8String: property_getName(property)];
		NSString       *prefKey  = [NSString stringWithFormat: @"%@_%@", className, key];
		
        id value = [self     valueForKey:  key];
        id pref  = [defaults objectForKey: prefKey];
        
        if (![value isEqual: pref]) {
            
            [defaults setObject: value forKey: prefKey];
        }
	}
	dirty_ = NO;
    
	free(propertyList); propertyList = NULL;
	
} // -writeProperties


- (void) writePreferences {
    
	DDGTrace();
	
    [self writeProperties];
    
    [self writeSettings];

	[[NSUserDefaults standardUserDefaults] synchronize];

} // -writePreferences


#pragma mark - Self Observing KVO Methods


- (void) observeValueForKeyPath: (NSString *) keyPath 
					   ofObject: (id) object 
						 change: (NSDictionary *) change 
						context: (void *) context {
    
	DDGTrace();
	
	if ([change valueForKey: NSKeyValueChangeNewKey]) {
        
		dirty_ = YES;
	}
	
} // -observeValueForKeyPath:ofObject:change:context:


- (void) observeProperties {
	
	DDGTrace();
	
	unsigned int     propertyCount = 0;
	objc_property_t *propertyList  = class_copyPropertyList([self class], &propertyCount);
	
	// Loop through properties.
	for (unsigned int i = 0; i < propertyCount; i++) {
		
        NSString *name = [NSString stringWithUTF8String: property_getName(propertyList[i])];
        
		[self addObserver: self 
               forKeyPath: name
                  options: NSKeyValueObservingOptionNew 
                  context: nil];
	}
	free(propertyList), propertyList = NULL;
	
} // -observeProperties


- (void) removeSelfObserver {
	
	DDGTrace();
	
	unsigned int     propertyCount = 0;
	objc_property_t *propertyList  = class_copyPropertyList([self class], &propertyCount);
	
	// Loop through properties.
	for (unsigned int i = 0; i < propertyCount; i++) {
		
        NSString *name = [NSString stringWithUTF8String: 
                          property_getName(propertyList[i])];
        
		[self removeObserver: self forKeyPath: name];
	}
	free(propertyList), propertyList = NULL;
	
} // -removeSelfObserver


#pragma mark - UIApplication Notifications


#define kApplicationWillTerminate  (@selector(applicationWillTerminate:))
- (void) applicationWillTerminate: (NSNotification *) notification {
	
	DDGTrace();
	
	if (dirty_) {
		
		[self writePreferences];
	}
	
} // -applicationWillTerminate:


#define kApplicationDidEnterBackground  (@selector(applicationDidEnterBackground:))
- (void) applicationDidEnterBackground: (NSNotification *) notification {
	
	if (dirty_) {
		
		[self writePreferences];
	}
	DDGDesc([[NSUserDefaults standardUserDefaults] dictionaryRepresentation]);
    	
} // -applicationDidEnterBackground:


#define kApplicationWillEnterForeground  (@selector(applicationWillEnterForeground:))
- (void) applicationWillEnterForeground: (NSNotification *) notification {
	
	[[NSUserDefaults standardUserDefaults] synchronize];

	DDGDesc([[NSUserDefaults standardUserDefaults] dictionaryRepresentation]);
    
    [self readSettings];
	
} // -applicationWillEnterForeground:


- (void) observeNotifications {
    
    DDGTrace();
    
    NSNotificationCenter *nc = NSNotificationCenter.defaultCenter;
    
    [nc removeObserver: self];
    
    [nc addObserver: self 
           selector:  kApplicationWillTerminate 
               name: UIApplicationWillTerminateNotification 
             object: nil];
    
    [nc addObserver: self 
           selector:  kApplicationDidEnterBackground 
               name: UIApplicationDidEnterBackgroundNotification 
             object: nil];
    
    [nc addObserver: self 
           selector:  kApplicationWillEnterForeground
               name: UIApplicationWillEnterForegroundNotification 
             object: nil];
    
} // -observeNotifications;

@end
