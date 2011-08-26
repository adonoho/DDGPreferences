//
//	DDGMacros.h
//  DDG Library
//
//	Created by Andrew Donoho on 2009/05/20.
//	Copyright 2009-2011 Donoho Design Group, L.L.C.. All rights reserved.
//

// Miscellaneous Constants
extern NSString *const kEmptyString;
extern NSString *const kOKButton;
extern NSString *const kNoButton;
extern NSString *const kCancelButton;
extern NSString *const kTrue;
extern NSString *const kFalse;

//
// Use the below line in your project settings to turn on DEBUG.
// GCC_PREPROCESSOR_DEFINITIONS == DEBUG=1
//
// And put the following in whichever class you need to log:
// #define CLASS_DEBUG 1
// #import "DDGMacros.h"
//

//
// Log the function name and line number using DDGTrace().
// void DDGTrace(void);
//

#if (defined DEBUG && defined CLASS_DEBUG)
#define DDGTrace() (DDGTrace_(__PRETTY_FUNCTION__, __LINE__))
void DDGTrace_(const char *name, int line);
#else
#define DDGTrace()
#endif

//
// Log the description, function name and line number.
// void DDGDesc(id object);
//

#if (defined DEBUG && defined CLASS_DEBUG)
#define DDGDesc(object) (DDGDesc_(__PRETTY_FUNCTION__, __LINE__, (object)))
void DDGDesc_(const char *name, int line, id object);
#else
#define DDGDesc(object)
#endif

//
// DDGLog() is a parameter identical substitute for NSLog() which also 
//   logs the function name and line number.
// void DDGLog(NSString *format, ...);
//

#if (defined DEBUG && defined CLASS_DEBUG)
#define DDGLog(format, ...) (DDGLog_(__PRETTY_FUNCTION__, __LINE__, (format), ##__VA_ARGS__))
void DDGLog_(const char *name, int line, NSString *format, ...);
#else
#define DDGLog(format, ...)
#endif

#if (defined DEBUG && defined CLASS_DEBUG)
#define logSubviews(view) (logSubviews_(__PRETTY_FUNCTION__, __LINE__, (view)))
void logSubviews_(const char *name, int line, UIView *parent);
#else
#define logSubviews(view)
#endif


#if (defined DEBUG && defined CLASS_DEBUG)
#define countSubviews(view) (countSubviews_(__PRETTY_FUNCTION__, __LINE__, (view)))
NSUInteger countSubviews_(const char *name, int line, UIView *parent);
#else
#define countSubviews(view)
#endif


// Debugger trap. Set a breakpoint on the implementation.
#if (defined DEBUG && defined CLASS_DEBUG)
#define DDGDebugger() (DDGDebugger_(__PRETTY_FUNCTION__, __LINE__))
void DDGDebugger_(const char *name, int line);
#else
#define DDGDebugger()
#endif

// Graphics Support Routines.
static inline CGFloat degreesToRadians(double x) { return (CGFloat) ((M_PI * x)/180.0); }
static inline CGFloat radiansToDegrees(double x) { return (CGFloat)((180.0 * x)/M_PI);  }

// NSRange Support Routines.
static inline NSRange makeEmptyRange(void) { return NSMakeRange(0, 0); }
static inline BOOL isRangeEmpty(NSRange r) { return (r.length == 0); }

// Hex to char conversion routines.
uint8_t htoc(char    h);
char    ctoh(uint8_t c);

//
//  UKHelperMacros.h
//
//  Created by Uli Kusterer on 09.08.07.
//  Copyright 2007 M. Uli Kusterer. All rights reserved.
//	
//	Use, modify and distribute freely, as long as you mark modified versions as
//	having been modified. I don't like getting bug reports for code I did not
//	write.
//
//	The following macro is for specifying property (ivar) names to KVC or KVO methods.
//	These methods generally take strings, but strings don't get checked for typos
//	by the compiler. If you write PROPERTY(fremen) instead of PROPERTY(frame),
//	the compiler will immediately complain that it doesn't know the selector
//	'fremen', and thus point out the typo. For this to work, you need to make
//	sure the warning -Wunknown-selector is on.
//
//	The code that checks here is (theoretically) slower than just using a string
//	literal, so what we do is we only do the checking in debug builds. In
//	release builds, we use the identifier-stringification-operator "#" to turn
//	the given property name into an ObjC string literal.

#if DEBUG
#define PROPERTY(propName)	NSStringFromSelector(@selector(propName))
#else
#define PROPERTY(propName)	@#propName
#endif

