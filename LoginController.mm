//
//  LoginController.m
//  EngageClient
//
//  Created by Eduardo Díaz on 6/2/14.
//  Copyright (c) 2014 EngageWall. All rights reserved.
//

#import "LoginController.h"
#import "EngageAppDelegate.h"
#import "Downloader.h"

@interface LoginController ()

@end


@implementation LoginController

bool started;

@synthesize displayArrayController;
@synthesize displayTable;

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        started = false;
    }
    return self;
}

-(IBAction)startApp:(id)sender;
{
    if(!started) {
    EngageAppDelegate *delegate = (EngageAppDelegate *)[NSApp delegate];
    started = true;
    
    NSArray * selected = [displayArrayController selectedObjects];
    
    if([selected count] > 0) {
        NSDictionary *selected = [[displayArrayController selectedObjects] firstObject];
        NSString * strNumber = [selected objectForKey:@"displayId"];
        int screenIndex = [strNumber intValue];
        [delegate startVideo:screenIndex];
    }
    }
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    NSArray *screenArray = [NSScreen screens];
    int i = 0;
    
    for(id screen in screenArray) {
        NSRect rect = [screen frame];
        
        int width = rect.size.width;
        int height = rect.size.height;
        
        NSString* displayName = @"";
        
        @try {
            displayName = [screen displayName];
        } @catch(NSException *ex) {
            NSLog(@"Error");
        }
        
        displayName = [displayName stringByAppendingString:[NSString stringWithFormat:@" %dx%d", width, height]];
        
        [displayArrayController addObject:[NSMutableDictionary
                                           dictionaryWithObjectsAndKeys:
                                           displayName, @"display",
                                           [NSString stringWithFormat:@"%d", i], @"displayId",
                                           nil]];
        i++;
        
    }
    
    
    EngageAppDelegate *delegate = (EngageAppDelegate *)[NSApp delegate];
    [delegate startDownload];
}


@end
