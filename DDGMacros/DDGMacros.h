//
//	DDGMacros.h
//  DDG Library
//
//	Created by Andrew Donoho on 2009/05/20.
//	Copyright 2009-2012 Donoho Design Group, L.L.C. All rights reserved.
//

/*
 
 The below license is the new BSD license with the OSI recommended 
 personalizations.
 <http://www.opensource.org/licenses/bsd-license.php>
 
 Copyright (C) 2009-2012 Donoho Design Group, LLC. All Rights Reserved.
 
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

// Miscellaneous Constants
extern NSString *const kEmptyString;
extern NSString *const kOKButton;
extern NSString *const kNoButton;
extern NSString *const kYesButton;
extern NSString *const kCancelButton;
extern NSString *const kTrue;
extern NSString *const kFalse;
extern const NSTimeInterval kDefaultDuration;

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

void _DDGTrace(const char *name, int line);
#if (defined DEBUG && defined CLASS_DEBUG)
#define DDGTrace() (_DDGTrace(__PRETTY_FUNCTION__, __LINE__))
#else
#define DDGTrace()
#endif

//
// Log the description, function name and line number.
// void DDGDesc(id object);
//

void _DDGDesc(const char *name, int line, id object);
#if (defined DEBUG && defined CLASS_DEBUG)
#define DDGDesc(object) (_DDGDesc(__PRETTY_FUNCTION__, __LINE__, (object)))
#else
#define DDGDesc(object)
#endif

//
// DDGLog() is a parameter identical substitute for NSLog() which also 
//   logs the function name and line number.
// void DDGLog(NSString *format, ...);
//

void _DDGLog(const char *name, int line, NSString *format, ...);
#if (defined DEBUG && defined CLASS_DEBUG)
#define DDGLog(format, ...) (_DDGLog(__PRETTY_FUNCTION__, __LINE__, (format), ##__VA_ARGS__))
#else
#define DDGLog(format, ...)
#endif

void _logSubviews(const char *name, int line, UIView *parent);
#if (defined DEBUG && defined CLASS_DEBUG)
#define logSubviews(view) (_logSubviews(__PRETTY_FUNCTION__, __LINE__, (view)))
#else
#define logSubviews(view)
#endif


NSUInteger _countSubviews(const char *name, int line, UIView *parent);
#if (defined DEBUG && defined CLASS_DEBUG)
#define countSubviews(view) (_countSubviews(__PRETTY_FUNCTION__, __LINE__, (view)))
#else
#define countSubviews(view)
#endif


// Debugger trap. Set a breakpoint on the implementation.
void _DDGDebugger(const char *name, int line);
#if (defined DEBUG && defined CLASS_DEBUG)
#define DDGDebugger() (_DDGDebugger(__PRETTY_FUNCTION__, __LINE__))
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

