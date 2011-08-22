//
//  DDGPreferencesViewController.h
//  DDGPreferences
//
//  Created by Andrew Donoho on 2011/08/20.
//  Copyright 2011 Donoho Design Group, L.L.C. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Preferences;

@interface DDGPreferencesViewController : UIViewController <UITextFieldDelegate>

@property(nonatomic, retain) Preferences *prefs;

@property (nonatomic, retain) IBOutlet UITextField *nameSettingField;
@property (nonatomic, retain) IBOutlet UISwitch *enabledSettingSwitch;
@property (nonatomic, retain) IBOutlet UISlider *sliderSettingSlider;

@property (nonatomic, retain) IBOutlet UITextField *namePrefField;
@property (nonatomic, retain) IBOutlet UISwitch *enabledPrefSwitch;
@property (nonatomic, retain) IBOutlet UISlider *sliderPrefSlider;
@property (nonatomic, retain) IBOutlet UILabel *rectPrefLabel;

@end
