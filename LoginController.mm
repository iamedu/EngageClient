//
//  LoginController.m
//  EngageClient
//
//  Created by Eduardo Díaz on 6/2/14.
//  Copyright (c) 2014 EngageWall. All rights reserved.
//

#import "LoginController.h"
#import "EngageAppDelegate.h"

@interface LoginController ()

@end

@implementation LoginController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    return self;
}

-(IBAction)startApp:(id)sender;
{
    EngageAppDelegate *delegate = [NSApp delegate];
    [delegate startVideo];
}

- (void)windowDidLoad
{
    [super windowDidLoad];
}

@end
