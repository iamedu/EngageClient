//
//  EngageAppDelegate.h
//  EngageClient
//
//  Created by Eduardo Díaz on 5/31/14.
//  Copyright (c) 2014 EngageWall. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <PolycodeView.h>
#import "LoginController.h"

#include "EngageClientApp.h"

#define MACRO_NAME(f) #f
#define MACRO_VALUE(f) MACRO_NAME(f)

@interface EngageAppDelegate : NSObject <NSApplicationDelegate> {
@private
    LoginController *login;
    EngageClientApp *app;
    NSTimer *timer;
    NSTimer *downloadTimer;
}
@property(nonatomic, strong) NSArray *tweets;
@property(nonatomic, strong) NSArray *instagrams;

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet PolycodeView *mainView;

-(void)startVideo:(int)screenIndex;
-(void)startDownload;


@end
