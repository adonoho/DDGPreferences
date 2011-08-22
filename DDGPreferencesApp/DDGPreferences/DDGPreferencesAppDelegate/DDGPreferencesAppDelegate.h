//
//  DDGPreferencesAppDelegate.h
//  DDGPreferences
//
//  Created by Andrew Donoho on 2011/08/20.
//  Copyright 2011 Donoho Design Group, L.L.C. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DDGPreferencesViewController;

@interface DDGPreferencesAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet DDGPreferencesViewController *viewController;

@end
