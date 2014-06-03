//
//  EngageAppDelegate.m
//  EngageClient
//
//  Created by Eduardo Díaz on 5/31/14.
//  Copyright (c) 2014 EngageWall. All rights reserved.
//

#import "EngageAppDelegate.h"
#import "Downloader.h"

@implementation EngageAppDelegate

@synthesize window;
@synthesize mainView;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [PolycodeView class];
    login = [[LoginController alloc] initWithWindowNibName:@"LoginController"];
    [login showWindow:self];
}

-(void)startVideo:(int)screenIndex
{
    app = new EngageClientApp(mainView, screenIndex);
	timer = [NSTimer timerWithTimeInterval:(1.0f/60.0f)
                                    target:self
                                  selector:@selector(animationTimer:)
                                  userInfo:nil
                                   repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
	[[NSRunLoop currentRunLoop] addTimer:timer forMode:NSEventTrackingRunLoopMode];
}

-(void)startDownload
{
    downloadTimer = [NSTimer scheduledTimerWithTimeInterval:60.0f
                                                     target:self
                                                   selector:@selector(downloadResources:)
                                                   userInfo:nil
                                                    repeats:YES];
    
    [self downloadResources:downloadTimer];
    
    [[NSRunLoop currentRunLoop] addTimer:downloadTimer forMode:NSDefaultRunLoopMode];
	[[NSRunLoop currentRunLoop] addTimer:downloadTimer forMode:NSEventTrackingRunLoopMode];
    

}


- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication
{
	return YES;
}

- (void)downloadResources:(NSTimer *)timer
{
    NSArray *resources = [NSArray arrayWithObjects:@"http://uxtweet.herokuapp.com/api/v1/twitter/list-approved-tweets",
                                                   @"http://uxtweet.herokuapp.com/api/v1/twitter/list-not-approved-ids",
                                                   @"http://uxtweet.herokuapp.com/api/v1/instagram/list-approved-instagrams",
                                                   @"http://uxtweet.herokuapp.com/api/v1/instagram/list-not-approved-links", nil];
    
    for(id resource in resources) {
        Downloader *downloader = [[Downloader alloc] initWithDownloadUrl:resource];
        [downloader startDownloadingURL:self];
    }
    
	NSLog(@"Started downloads");
}

- (void)animationTimer:(NSTimer *)timer
{
	if(!app->Update()) {
		[[NSApplication sharedApplication] stop:self];
	}
}


@end
