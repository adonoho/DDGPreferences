//
//  Preferences.m
//  DDGPreferences
//
//  Created by Andrew Donoho on 2011/08/20.
//  Copyright 2011 Donoho Design Group, L.L.C. All rights reserved.
//

#import "Preferences.h"

@interface Preferences () {

@private
    NSString *nameSetting_;
    BOOL   enabledSetting_;
    CGFloat sliderSetting_;

    NSString *namePref_;
    BOOL   enabledPref_;
    CGFloat sliderPref_;
    NSData   *rectPrefData_;
}
@end

@implementation Preferences

@synthesize nameSetting = nameSetting_;
@synthesize enabledSetting = enabledSetting_;
@synthesize sliderSetting = sliderSetting_;

@synthesize namePref = namePref_;
@synthesize enabledPref = enabledPref_;
@synthesize sliderPref = sliderPref_;
@synthesize rectPrefData = rectPrefData_;

- (void) dealloc {
    
    self.nameSetting = nil;
    self.namePref = nil;
    self.rectPrefData = nil;
    
    [super dealloc];
    
} // -dealloc


- (Preferences *) init {
    
    self = [super init];
    
    if (self) {
        
        if (!self.preferencesExist) {
            
            self.rectPref = CGRectMake(10.0f, 20.0f, 40.0f, 80.0f);
        }
    }
    return self;
    
} // -init


- (NSString *) description {
    
    return [NSString stringWithFormat:
            @"\n\tnameSetting: %@\n\tenabledSetting: %@\n\tsliderSetting: %f\n\tnamePref: %@\n\tenabledPref: %@\n\tsliderPref: %f\n\trectDataPref: %@",
            self.nameSetting, self.enabledSetting ? @"Yes" : @"No", self.sliderSetting,
            self.namePref,    self.enabledPref    ? @"Yes" : @"No", self.sliderPref, self.rectPrefData];
    
} // -description


- (CGRect) rectPref {
    
    return [[NSKeyedUnarchiver unarchiveObjectWithData: self.rectPrefData] CGRectValue];
    
} // -rectPref


- (void) setRectPref: (CGRect) rect {

    self.rectPrefData = [NSKeyedArchiver archivedDataWithRootObject: 
                         [NSValue valueWithCGRect: rect]];

} // -setRectPref:

@end
