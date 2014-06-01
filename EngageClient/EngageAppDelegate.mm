//
//  EngageAppDelegate.m
//  EngageClient
//
//  Created by Eduardo Díaz on 5/31/14.
//  Copyright (c) 2014 EngageWall. All rights reserved.
//

#import "EngageAppDelegate.h"

@implementation EngageAppDelegate

@synthesize window;
@synthesize mainView;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    app = new EngageClientApp(mainView);
	timer = [NSTimer timerWithTimeInterval:(1.0f/60.0f)
                                    target:self
                                  selector:@selector(animationTimer:)
                                  userInfo:nil
                                   repeats:YES];
	[[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
	[[NSRunLoop currentRunLoop] addTimer:timer forMode:NSEventTrackingRunLoopMode];
}


- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication
{
	return YES;
}

- (void)animationTimer:(NSTimer *)timer
{
	if(!app->Update()) {
		[[NSApplication sharedApplication] stop:self];
	}
}


@end
