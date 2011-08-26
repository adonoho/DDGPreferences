//
//  DDGPreferencesViewController.m
//  DDGPreferences
//
//  Created by Andrew Donoho on 2011/08/20.
//  Copyright 2011 Donoho Design Group, L.L.C. All rights reserved.
//

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
