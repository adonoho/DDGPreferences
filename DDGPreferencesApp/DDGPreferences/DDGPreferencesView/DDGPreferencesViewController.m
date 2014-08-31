//
//  DDGPreferencesViewController.m
//  DDGPreferences
//
//  Created by Andrew Donoho on 2011/08/20.
//  Copyright 2011-2012 Donoho Design Group, L.L.C. All rights reserved.
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
#  error Please compile this class with ARC (-fobjc-arc).
#endif

#import "Preferences.h"

#import "DDGPreferencesViewController.h"

#import "CloudPreferences.h"

#define CLASS_DEBUG 1
#import "DDGMacros.h"

@interface DDGPreferencesViewController ()

@property (strong, nonatomic) CloudPreferences *cloudPrefs;

- (void) observeNotifications;

@end

@implementation DDGPreferencesViewController

- (void) dealloc {
    
    DDGTrace();
    
    [NSNotificationCenter.defaultCenter removeObserver: self];
    
} // -dealloc


- (void) didReceiveMemoryWarning {
    
    DDGTrace();
    
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.

} // -didReceiveMemoryWarning


#pragma mark - UIViewController view lifecycle methods


- (void) refreshUI {
    
    self.nameSettingField.text = self.prefs.nameSetting;
    [self.enabledSettingSwitch setOn:    self.prefs.isEnabledSetting animated: YES];
    [self.sliderSettingSlider  setValue: self.prefs.sliderSetting    animated: YES];
    
    self.namePrefField.text = self.prefs.namePref;
    [self.enabledPrefSwitch setOn:    self.prefs.isEnabledPref animated: YES];
    [self.sliderPrefSlider  setValue: self.prefs.sliderPref    animated: YES];
    self.rectPrefLabel.text = NSStringFromCGRect(self.prefs.rectPref);
    
} // -refreshUI


- (void) refreshPrefs {
    
    self.prefs.nameSetting = self.nameSettingField.text;
    self.prefs.enabledSetting = self.enabledSettingSwitch.on;
    self.prefs.sliderSetting = self.sliderSettingSlider.value;
    
    self.prefs.namePref = self.namePrefField.text;
    self.prefs.enabledPref = self.enabledPrefSwitch.on;
    self.prefs.sliderPref = self.sliderPrefSlider.value;
    
} // -refreshPrefs


- (void) viewDidLoad {
    
    DDGTrace();
    
    [super viewDidLoad];

    if (!self.prefs) {
        
        self.prefs = Preferences.new;
        self.cloudPrefs = [CloudPreferences.alloc initWithPreferences: self.prefs];
    }
    [self observeNotifications];

} // -viewDidLoad


- (void) viewWillAppear: (BOOL) animated {

    [super viewWillAppear: animated];
    
    [self refreshUI];

} // -viewWillAppear:


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


#pragma mark - IBAction methods


- (IBAction) pushToCloud: (UIButton *) sender {
    
    DDGDesc(self);
    
    [self refreshPrefs];
    
    [self.prefs writePreferences];
    
} // -pushToCloud:


- (IBAction) randomRect: (UIButton *) sender {
    
    CGRect rect = CGRectZero;
    
    rect.origin = CGPointMake(arc4random_uniform(320), arc4random_uniform(320));
    rect.size   = CGSizeMake( arc4random_uniform(320), arc4random_uniform(320));
    
    rect = CGRectIntersection(self.view.bounds, rect);
    
    self.prefs.rectPref = rect;
    self.rectPrefLabel.text = NSStringFromCGRect(rect);

} // -randomRect:


#pragma mark - UIApplication notification methods


#define kCloudKeyValueStoreDidChangeExternally  (@selector(cloudKeyValueStoreDidChangeExternally:))
- (void) cloudKeyValueStoreDidChangeExternally: (NSNotification *) notification {

	DDGTrace();
    
    // Ensure all listeners for this notification are done before refreshing the UI.
    dispatch_async(dispatch_get_main_queue(), ^{ [self refreshUI]; });
    
} // -cloudKeyValueStoreDidChangeExternally:


#define kApplicationDidBecomeActive  (@selector(applicationDidBecomeActive:))
- (void) applicationDidBecomeActive: (NSNotification *) notification {

    DDGDesc(self);
    
    dispatch_async(dispatch_get_main_queue(), ^{ [self refreshUI]; });

} // -applicationDidBecomeActive:


#define kApplicationWillResignActive  (@selector(applicationWillResignActive:))
- (void) applicationWillResignActive: (NSNotification *) notification {
    
    DDGDesc(self);
    
    [self refreshPrefs];
    
} // -applicationWillResignActive:


- (void) observeNotifications {
    
    DDGTrace();
    
    NSNotificationCenter *nc = NSNotificationCenter.defaultCenter;
    
    [nc removeObserver: self];

    [nc addObserver: self
           selector:       kCloudKeyValueStoreDidChangeExternally
               name: NSUbiquitousKeyValueStoreDidChangeExternallyNotification
             object: NSUbiquitousKeyValueStore.defaultStore];
    
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
