Almost every iOS application has individual user preferences. Some apps also
use Apple's Settings app, some don't. If you develop many different
applications, as I do in my development consulting practice, it is tedious to
code up a custom preferences class for each app. My class, DDGPreferences, is
an attempt to minimize the tedium by providing a very simple API to the
NSUserDefaults class for both settings and custom preferences. In addition to
DDGPreferences, I have included a set of standard logging macros, DDGMacros,
and an example single view iOS app tying all of the pieces together.

## The API

I like simple APIs. They are easy to use and easy to share. I wanted this API
to be no more than a list of properties. As in:

    
    @interface Preferences : DDGPreferences
    
    @property (nonatomic, copy)   NSString *nameSetting;
    @property (nonatomic, assign, getter=isEnabledSetting) BOOL enabledSetting;
    @property (nonatomic, assign) CGFloat sliderSetting;
    
    @property (nonatomic, copy)   NSString *namePref;
    @property (nonatomic, assign, getter=isEnabledPref) BOOL enabledPref;
    @property (nonatomic, assign) CGFloat sliderPref;
    @property (nonatomic, retain) NSData *rectPrefData;
    
    @end
    

Furthermore, the only difference between whether a property was visible in
Apple's settings app should be if a key matching its exact name was present in
the "Root.plist" in the "Settings.bundle". In other words, each setting has an
identifier/key which is identical to a property name. This post is not a
tutorial on how to build an app that uses Apple's Settings application. That
said the example app has only made minor changes to the fields created when
you add a Settings.bundle to your app. (In particular, I changed the
Key/Identifier from using under bars, _, as word separators to using standard
Cocoa camel case.) In other words, I believe a beginner should be able to
follow the logic of using this class without too much difficulty.

### How do you use DDGPreferences?

Using DDGPreferences is simple. Make your Preferences class a subclass of
DDGPreferences and then instantiate it. Really, that is all you have to do.
Your preferences are limited to those supported by Apple's .plist files. This
is not as restrictive as it might seem. Later, I'll show you how to convert an
arbitrary NSCoding compliant class to a preference.

If you have default preference values which are different from the state of a
freshly initialized object, then you must implement the DDGPreferences
protocol's single method, -setDefaultPreferences. The example application has
this method.

What about synchronizing changes between Apple's Settings app and yours while
the app is in the background? When your app returns to the foreground, I
recommend you read/write the Settings managed values in response to
the UIApplicationDidBecomeActiveNotification,
UIApplicationWillResignActiveNotification notification pair. The example app
shows one way to do this. All other coordination with the Settings app is
handled by DDGPreferences.

### The DDGPreferences app:

I've included an app showing how to use DDGPreferences. It is a single view
iPhone app with an array of identical controls for both Apple's Settings app
and the DDGPreferences app. You can change the preferences for the settings in
both apps and they transfer bi-directionally. A simple CGRect is also
initialized and stored. It is then displayed in a UILabel. How to store a
complex structure, such as a CGRect, is described below. Traditionally, your
preferences are stored with your application singleton. In this example, for
pedagogical simplicity, I store them in the root view controller.

### Saving complex classes:

This is an advanced technique and, if you can, I recommend that you avoid
using it. Any NSCoding compliant class can be stored, with care, in
DDGPreferences. As DDGPreferences uses the properties to determine what needs
to be persisted, you cannot just define a @property for your class that is not
one of those supported by Apple's .plist format; you need to define an NSData
typed instance variable to hold an archived instance of your class/structure.
In the example, rectPrefData is that field. To access this data as your
preferred class, you need to define "old school" Objective-C v1 style
accessors. In the example, these are -rectPref/-setRectPref:. Somewhat
obviously, these accessors will use rectPrefData to store the value. A example
implementation of these methods is:

    
    - (CGRect) rectPref {
    
        return [[NSKeyedUnarchiver unarchiveObjectWithData:
                 self.rectPrefData] CGRectValue];
    
    } // -rectPref
    
    - (void) setRectPref: (CGRect) rect {
    
        self.rectPrefData = [NSKeyedArchiver archivedDataWithRootObject:
                             [NSValue valueWithCGRect: rect]];
    } // -setRectPref:
    

They work by taking your NSCoding compliant class and archiving it using the
NSKeyedArchiver/NSKeyedUnarchiver classes. The above methods, for pedagogical
purposes, are not key-value coding compliant.

### Licensing:

DDGPreferences is covered under a public attribution required version of the
new BSD license. Why do I require that you acknowledge me publicly in your
app? Similarly to many other developers, I make my code available under an
open source license as an advertisement for my development consulting
services. Hence, I need to be able to easily point to applications that use my
code. While it is not necessary, I would appreciate it if you also sent me an
email saying in which apps you use DDGPreferences.

From my experience making other code available under an open source license,
some folks will write asking to be relieved of my public recognition
requirement. Unless the requestor is willing to compensate me to change the
licensing terms, I will always decline to change my agreement. I have put some
time and care into crafting this class, app and this blog post. That time
deserves compensation. I have chosen to be compensated by using this class as
a marketing mechanism. I apologize if this does not align with your open
source values. I have a family to feed and a mortgage to service. I sell
coding services and code to provide for all of us. I hope you understand.

### Where to get the code:

This code is available from GitHub at this URL:
<[https://github.com/adonoho/DDGPreferences][1]>. I will be tracking comments
at both GitHub and this post on my personal blog, <[http://blog.DDG.com/][2]>.
I, of course, encourage you to send in bug fixes and make suggestions to
improve DDGPreferences for all of us.

   [1]: https://github.com/adonoho/DDGPreferences
   [2]: http://blog.DDG.com/

I hope you find DDGPreferences useful.

In a future post for advanced programmers, I will describe how DDGPreferences
functions.

