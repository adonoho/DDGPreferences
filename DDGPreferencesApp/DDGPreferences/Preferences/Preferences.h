//
//  Preferences.h
//  DDGPreferences
//
//  Created by Andrew Donoho on 2011/08/20.
//  Copyright 2011 Donoho Design Group, L.L.C. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDGPreferences.h"

@interface Preferences : DDGPreferences 

@property (nonatomic, copy)   NSString *nameSetting;
@property (nonatomic, assign, getter=isEnabledSetting) BOOL enabledSetting;
@property (nonatomic, assign) CGFloat sliderSetting;

@property (nonatomic, copy)   NSString *namePref;
@property (nonatomic, assign, getter=isEnabledPref) BOOL enabledPref;
@property (nonatomic, assign) CGFloat sliderPref;
@property (nonatomic, retain) NSData *rectPrefData;

// Non-property accessors: Used to save structures in the preferences .plist.
- (CGRect)  rectPref;
- (void) setRectPref: (CGRect) rect;

@end
