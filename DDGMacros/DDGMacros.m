//
//  DDGMacros.m
//  DDG Library
//
//  Created by Andrew Donoho on 2009/05/23.
//  Copyright 2009-2014 Donoho Design Group, L.L.C. All rights reserved.
//

/*
 
 The below license is the new BSD license with the OSI recommended 
 personalizations.
 <http://www.opensource.org/licenses/bsd-license.php>
 
 Copyright (C) 2009-2014 Donoho Design Group, LLC. All Rights Reserved.
 
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

#import "DDGMacros.h"

#ifdef TESTFLIGHT
// Use the TestFlight folks' logging system.

#import "TestFlight.h"

#define NSLog  TFLog
#define NSLogv TFLogv

#endif

// Miscellaneous Constants
NSString *const kEmptyString  = @"";
NSString *const kOKButton     = @"OK";
NSString *const kNoButton     = @"No";
NSString *const kYesButton    = @"Yes";
NSString *const kCancelButton = @"Cancel";
NSString *const kTrue         = @"true";
NSString *const kFalse        = @"false";
const NSTimeInterval kDefaultDuration = 0.25;

@implementation DDGMacros

#define kLog  (@selector(log:))
+ (void) log: (NSNotification *) notification {

    NSLog(@"Notification Name: %@;\n\tObject: %@;\n\tUserInfo: %@.",
          notification.name, notification.object, notification.userInfo);

} // +log:


+ (void) logAllNotifications {

    NSNotificationCenter *nc = NSNotificationCenter.defaultCenter;

    [nc removeObserver: self];

    [nc addObserver: self selector: kLog name: nil object: nil];

} // +logAllNotifications

@end


void _DDGTrace(const char *name, int line) {
	
	NSLog(@"%s (%d)", name, line);
	
} // void _DDGTrace()


void _DDGDesc(const char *name, int line, id object) {
	
	if (object) {
		
        NSLog(@"%s (%d)\nDescription: %@", name, line, object);
	} 
	else { NSLog(@"%s (%d)", name, line); }
	
} // _DDGDesc()


//
// _DDGLog allows us to catch log statements and insert other useful runtime information.
// Use the DDGLog() macro instead of this function. It allows per line and function logging.
//
void _DDGLog(const char *name, int line, NSString *format, ...) {
	
	if (format) {
		
		NSMutableString *logString = [NSMutableString stringWithFormat: @"%s (%d) \n\t", name, line];
		
		// Make a new format string.
		[logString appendString: format];
		format = logString;
		
		va_list argp;
		va_start(argp, format);
        
		NSLogv(format, argp);
		
		va_end(argp);
	} 
	else {
		
		NSLog(@"%s (%d)", name, line);
	}
	
} // _DDGLog()


void _DDGDebugger(const char *name, int line) {
	
	NSLog(@"%s (%d)", name, line);
	
} // _DDGDebugger()


uint8_t htoc(char h) {
	
	switch (h) {
			
		case '0': return 0x0;
		case '1': return 0x1;
		case '2': return 0x2;
		case '3': return 0x3;
		case '4': return 0x4;
		case '5': return 0x5;
		case '6': return 0x6;
		case '7': return 0x7;
		case '8': return 0x8;
		case '9': return 0x9;
		case 'a': return 0xa;
		case 'b': return 0xb;
		case 'c': return 0xc;
		case 'd': return 0xd;
		case 'e': return 0xe;
		case 'f': return 0xf;
		case 'A': return 0xa;
		case 'B': return 0xb;
		case 'C': return 0xc;
		case 'D': return 0xd;
		case 'E': return 0xe;
		case 'F': return 0xf;
		default:  return 0xff;
	}
	
} // htoc


char ctoh(uint8_t c) {
	
	switch (c) {
			
		case 0x0: return '0';
		case 0x1: return '1';
		case 0x2: return '2';
		case 0x3: return '3';
		case 0x4: return '4';
		case 0x5: return '5';
		case 0x6: return '6';
		case 0x7: return '7';
		case 0x8: return '8';
		case 0x9: return '9';
		case 0xa: return 'a';
		case 0xb: return 'b';
		case 0xc: return 'c';
		case 0xd: return 'd';
		case 0xe: return 'e';
		case 0xf: return 'f';
		default:  return 0xff;
	}
	
} // ctoh


//@implementation Macros
//
//@end
