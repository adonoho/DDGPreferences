//
//  Preferences.m
//  DDGPreferences
//
//  Created by Andrew Donoho on 2011/08/20.
//  Copyright 2011 Donoho Design Group, L.L.C. All rights reserved.
//

/*
 
 The below license is the new BSD license with the OSI recommended 
 personalizations.
 <http://www.opensource.org/licenses/bsd-license.php>
 
 Copyright (C) 2010-2011 Donoho Design Group, LLC. All Rights Reserved.
 
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


#pragma mark - DDGPreferences protocol methods.


- (void) setDefaultPreferences {
    
    self.namePref = @"";
    self.enabledPref = NO;
    self.sliderPref  = 100.0f;
    self.rectPref = CGRectMake(10.0f, 20.0f, 40.0f, 80.0f);
    
} // -setDefaultPreferences

@end
