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
@synthesize tweets;
@synthesize instagrams;

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
    downloadTimer = [NSTimer scheduledTimerWithTimeInterval:30.0f
                                                     target:self
                                                   selector:@selector(downloadDefinitions:)
                                                   userInfo:nil
                                                    repeats:YES];
    
    [self downloadDefinitions:downloadTimer];
    
    [[NSRunLoop currentRunLoop] addTimer:downloadTimer forMode:NSDefaultRunLoopMode];
	[[NSRunLoop currentRunLoop] addTimer:downloadTimer forMode:NSEventTrackingRunLoopMode];
}


- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication
{
	return YES;
}

- (void)testing:(NSTimer *)t
{
    NSThread *th = [[NSThread alloc] initWithTarget:self selector:@selector(doDownloadDefinitions:) object:t];
    [th start];
}

- (void)downloadDefinitions:(NSTimer *)timer
{
    NSArray *resources = [NSArray arrayWithObjects:@"http://uxtweet.herokuapp.com/api/v1/twitter/list-approved-tweets",
                          @"http://uxtweet.herokuapp.com/api/v1/twitter/list-not-approved-ids",
                          @"http://uxtweet.herokuapp.com/api/v1/instagram/list-approved-instagrams",
                          @"http://uxtweet.herokuapp.com/api/v1/instagram/list-not-approved-links", nil];
    
    for(id resource in resources) {
        Downloader *downloader = [[Downloader alloc] initWithDownloadUrl:resource];
        [downloader startDownloadingURL:self];
    }
    
    NSData *tweetString = [NSData dataWithContentsOfFile:
                           [@"~/.engage/resources/list-approved-tweets.json" stringByExpandingTildeInPath]];
    
    NSData *instagramString = [NSData dataWithContentsOfFile:
                               [@"~/.engage/resources/list-approved-instagrams.json" stringByExpandingTildeInPath]];
    
    NSError *jsonParsingError;
    
    if(tweetString) {
        tweets = [NSJSONSerialization JSONObjectWithData:tweetString
                                                 options:0 error: &jsonParsingError];
        
    }
    if(instagramString) {
        instagrams = [NSJSONSerialization JSONObjectWithData:instagramString
                                                     options:0 error: &jsonParsingError];
    }

    [self downloadResources];
}


- (void)downloadResources
{
    NSLog(@"Downloading resources");
    
    if(tweets) {
        for(id tweet in tweets) {
            NSString* picture = [tweet objectForKey:@"picture_url"];
            NSString* slug = [@"http://uxtweet.herokuapp.com/api/v1/twitter/picture/" stringByAppendingString:[tweet objectForKey:@"slug"]];
            if (![[NSNull null] isEqual:picture]) {
                picture = [@"http://uxtweet.herokuapp.com/api/v1/twitter/twit-picture/"
                           stringByAppendingString:[tweet objectForKey:@"twitter_id"]];
                picture = [picture stringByAppendingString:@".jpg"];
                Downloader *downloader = [[Downloader alloc] initWithDownloadUrl:picture];
                [downloader startDownloadingURL:self];
            }
            
            Downloader *slugDownloader = [[Downloader alloc] initWithDownloadUrl:slug];
            [slugDownloader startDownloadingURL:self];
            
        }
    }

    if(instagrams) {
        for(id instagram in instagrams) {
            NSString* profileUrl = [instagram objectForKey:@"profile_url"];
            NSString* standardResolution = [instagram objectForKey:@"standard_resolution"];
            
            Downloader *downloader1 = [[Downloader alloc] initWithDownloadUrl:profileUrl];
            [downloader1 startDownloadingURL:self];
            
            Downloader *downloader2 = [[Downloader alloc] initWithDownloadUrl:standardResolution];
            [downloader2 startDownloadingURL:self];

        }
    }
    
}

- (void)animationTimer:(NSTimer *)timer
{
    NSUInteger randomNetwork = arc4random() % 2;
    if(instagrams && randomNetwork == 1) {
        NSUInteger randomIndex = arc4random() % [instagrams count];
        app->updateScene(INSTAGRAM, [instagrams objectAtIndex:randomIndex]);
    } else if(tweets && randomNetwork == 0) {
        NSUInteger randomIndex = arc4random() % [tweets count];
        app->updateScene(TWITTER, [tweets objectAtIndex:randomIndex]);
    }
	if(!app->Update()) {
		[[NSApplication sharedApplication] stop:self];
	}
}


@end
