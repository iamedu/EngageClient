//
//  Downloader.m
//  EngageClient
//
//  Created by Eduardo Díaz on 6/2/14.
//  Copyright (c) 2014 EngageWall. All rights reserved.
//

#import "Downloader.h"

@implementation Downloader

- (id) initWithDownloadUrl:(NSString *)downloadUrl_
{
    self = [super init];
    if (self)
    {
        self.downloadUrl = downloadUrl_;
    }
    return self;
}

- (void)startDownloadingURL:sender
{
    NSLog(@"Starting download %@", self.downloadUrl);
    // Create the request.
    NSURLRequest *theRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:self.downloadUrl]
                                                cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                timeoutInterval:30.0];
    
    
    NSError *error;
    NSString * path = [NSHomeDirectory() stringByAppendingString:@"/.engage/download"];
    [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
    
    path = [NSHomeDirectory() stringByAppendingString:@"/.engage/resources"];
    [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
        
    // Create the download with the request and start loading the data.
    NSURLDownload  *theDownload = [[NSURLDownload alloc] initWithRequest:theRequest delegate:self];
    if (!theDownload) {
        NSLog(@"Cannot download file");
    }
}


- (void)download:(NSURLDownload *)download decideDestinationWithSuggestedFilename:(NSString *)filename_
{
    NSString *destinationFilename;
    NSString *homeDirectory = NSHomeDirectory();
    
    self.filename = filename_;
    
    
    destinationFilename = [[homeDirectory stringByAppendingPathComponent:@".engage/download"]
                           stringByAppendingPathComponent:self.filename];
    
    [download setDestination:destinationFilename allowOverwrite:YES];
}


- (void)download:(NSURLDownload *)download didFailWithError:(NSError *)error
{
    // Dispose of any references to the download object
    // that your app might keep.
    

    
    // Inform the user.
    NSLog(@"Download failed! Error - %@ %@",
          [error debugDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
    
}



- (void)downloadDidFinish:(NSURLDownload *)download
{
    
    NSString *homeDirectory = NSHomeDirectory();
    NSString *originalPath = [[homeDirectory stringByAppendingPathComponent:@".engage/download"]
                                    stringByAppendingPathComponent:self.filename];
    
    
    NSFileManager * manager = [NSFileManager defaultManager];
    NSError *error;
    
    if([self.filename hasSuffix:@".jpeg"] || [self.filename hasSuffix:@".jpg"]) {
        
        NSImage * image = [[NSImage alloc] initWithContentsOfFile:originalPath];
        [image lockFocus];
        NSBitmapImageRep *bitmapRep = [[NSBitmapImageRep alloc] initWithFocusedViewRect:NSMakeRect(0, 0, image.size.width, image.size.height)];
        [image unlockFocus];
        NSData * pngRep = [bitmapRep representationUsingType:NSPNGFileType properties:Nil];
        
        
        self.filename = [self.filename stringByReplacingOccurrencesOfString:@".jpeg" withString:@".png"];
        self.filename = [self.filename stringByReplacingOccurrencesOfString:@".jpg" withString:@".png"];
        
        
        
        [manager removeItemAtPath:originalPath error:&error];
        originalPath = [[homeDirectory stringByAppendingPathComponent:@".engage/download"]
                        stringByAppendingPathComponent:self.filename];
        
        if(![pngRep writeToFile:originalPath
                     options:NSDataWritingAtomic
                    error:&error]) {
            NSLog(@"CANNOT DO THIS %@", error);
        }
        
        
        
    }
    
    
    NSString *targetPath = [[homeDirectory stringByAppendingPathComponent:@".engage/resources"]
                            stringByAppendingPathComponent:self.filename];

    [manager removeItemAtPath:targetPath error:&error];
    [manager moveItemAtPath:originalPath toPath:targetPath error:&error];
    [manager removeItemAtPath:originalPath error:&error];
        
    NSLog(@"%@",@"downloadDidFinish");
    
}

@end
