//
//  MoKoAppDelegate.m
//  MoKo
//
//  Created by 谭 颢 on 11-7-3.
//  Copyright 2011 天府学院. All rights reserved.
//

#import "MoKoAppDelegate.h"

@implementation MoKoAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    
    NSDateFormatter * dateFormatter = [[[NSDateFormatter alloc] init]autorelease];
    [dateFormatter setAMSymbol:@"AM"];
    [dateFormatter setPMSymbol:@"PM"];
    [dateFormatter setDateFormat:@"dd/MM/yyyy hh:mmaaa"];
    NSDate *date = [NSDate date];
    NSString * s = [dateFormatter stringFromDate:date];
    NSLog(@"%@",s);
    
    
    
	[self.window setCollectionBehavior:NSWindowCollectionBehaviorCanJoinAllSpaces];
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)theApplication hasVisibleWindows:(BOOL)flag{	
	if (!flag) {
		[window makeKeyAndOrderFront:self];
	}
	return YES;
}

@end
