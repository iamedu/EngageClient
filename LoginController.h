//
//  LoginController.h
//  EngageClient
//
//  Created by Eduardo Díaz on 6/2/14.
//  Copyright (c) 2014 EngageWall. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface LoginController : NSWindowController

@property (strong) IBOutlet NSArrayController *displayArrayController;
@property (weak) IBOutlet NSTableView *displayTable;

-(IBAction)startApp:(id)sender;


@end
