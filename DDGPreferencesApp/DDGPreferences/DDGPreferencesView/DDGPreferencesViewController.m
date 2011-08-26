//
//  DDGPreferencesViewController.m
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

#import "DDGPreferencesViewController.h"

#define CLASS_DEBUG 1
#import "DDGMacros.h"

@interface DDGPreferencesViewController () {

@private
    Preferences *prefs_;
    
    UITextField *nameSettingField_;
    UISwitch *enabledSettingSwitch_;
    UISlider  *sliderSettingSlider_;

    UITextField *namePrefField_;
    UISwitch *enabledPrefSwitch_;
    UISlider  *sliderPrefSlider_;
    UILabel *rectPrefLabel_;
}
- (void) observeNotifications;

@end

@implementation DDGPreferencesViewController

@synthesize prefs = prefs_;
@synthesize nameSettingField = nameSettingField_;
@synthesize enabledSettingSwitch = enabledSettingSwitch_;
@synthesize sliderSettingSlider = sliderSettingSlider_;
@synthesize namePrefField = namePrefField_;
@synthesize enabledPrefSwitch = enabledPrefSwitch_;
@synthesize sliderPrefSlider = sliderPrefSlider_;
@synthesize rectPrefLabel = rectPrefLabel_;

- (void) dealloc {
    
    DDGTrace();
    
    NSNotificationCenter *nc = NSNotificationCenter.defaultCenter;

    [nc removeObserver: self];
    
    self.prefs = nil;
    
    self.nameSettingField = nil;
    self.enabledSettingSwitch = nil;
    self.sliderSettingSlider = nil;

    self.namePrefField = nil;
    self.enabledPrefSwitch = nil;
    self.sliderPrefSlider = nil;
    self.rectPrefLabel = nil;
    
    [super dealloc];

} // -dealloc


- (void) didReceiveMemoryWarning {
    
    DDGTrace();
    
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.

} // -didReceiveMemoryWarning


#pragma mark - UIViewController view lifecycle methods


- (void) viewDidLoad {
    
    DDGTrace();
    
    [super viewDidLoad];

    if (!self.prefs) { self.prefs = [[Preferences new] autorelease]; }
    
    self.nameSettingField.text = self.prefs.nameSetting;
    self.enabledSettingSwitch.on = self.prefs.isEnabledSetting;
    self.sliderSettingSlider.value = self.prefs.sliderSetting;
    
    self.namePrefField.text = self.prefs.namePref;
    self.enabledPrefSwitch.on = self.prefs.isEnabledPref;
    self.sliderPrefSlider.value = self.prefs.sliderPref;
    self.rectPrefLabel.text = NSStringFromCGRect(self.prefs.rectPref);
    
    [self observeNotifications];

} // -viewDidLoad


- (void) viewDidUnload {
    
    DDGTrace();
    
    [super viewDidUnload];

    self.nameSettingField = nil;
    self.enabledSettingSwitch = nil;
    self.sliderSettingSlider = nil;
    
    self.namePrefField = nil;
    self.enabledPrefSwitch = nil;
    self.sliderPrefSlider = nil;
    self.rectPrefLabel = nil;
    
} // -viewDidUnload


- (BOOL) shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation) interfaceOrientation {

    DDGTrace();
    
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
    
} // -shouldAutorotateToInterfaceOrientation:


#pragma mark - UITextFieldDelegate methods


- (BOOL) textFieldShouldReturn: (UITextField *) textField {
    
    DDGTrace();
    
    [self.nameSettingField resignFirstResponder];
    [self.namePrefField    resignFirstResponder];
    
    return NO;
    
} // -textFieldShouldReturn:


#pragma mark - UIApplication notification methods


#define kApplicationDidBecomeActive  (@selector(applicationDidBecomeActive:))
- (void) applicationDidBecomeActive: (NSNotification *) notification {

    DDGDesc(self);
    
    self.nameSettingField.text = self.prefs.nameSetting;
    self.enabledSettingSwitch.on = self.prefs.enabledSetting;
    self.sliderSettingSlider.value = self.prefs.sliderSetting;

} // -applicationDidBecomeActive:


#define kApplicationWillResignActive  (@selector(applicationWillResignActive:))
- (void) applicationWillResignActive: (NSNotification *) notification {
    
    DDGDesc(self);
    
    //
    // The below code causes, IMO, too many saves of the Preferences.
    // It is here for the purposes of pedagogy.
    //
    self.prefs.nameSetting = self.nameSettingField.text;
    self.prefs.enabledSetting = self.enabledSettingSwitch.on;
    self.prefs.sliderSetting = self.sliderSettingSlider.value;
    
    self.prefs.namePref = self.namePrefField.text;
    self.prefs.enabledPref = self.enabledPrefSwitch.on;
    self.prefs.sliderPref = self.sliderPrefSlider.value;
    
} // -applicationWillResignActive:


- (void) observeNotifications {
    
    DDGTrace();
    
    NSNotificationCenter *nc = NSNotificationCenter.defaultCenter;
    
    [nc removeObserver: self];

    [nc addObserver: self 
           selector:  kApplicationDidBecomeActive 
               name: UIApplicationDidBecomeActiveNotification 
             object: nil];
    
    [nc addObserver: self 
           selector:  kApplicationWillResignActive 
               name: UIApplicationWillResignActiveNotification
             object: nil];
    
} // -observeNotifications;

@end
