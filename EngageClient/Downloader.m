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
    // Create the request.
    NSURLRequest *theRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:self.downloadUrl]
                                                cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                timeoutInterval:60.0];
    
    
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
    NSString *targetPath = [[homeDirectory stringByAppendingPathComponent:@".engage/resources"]
                                    stringByAppendingPathComponent:self.filename];
    
    
    NSFileManager * manager = [NSFileManager defaultManager];
    NSError *error;
    
    [manager moveItemAtPath:originalPath toPath:targetPath error:&error];
        
    NSLog(@"%@",@"downloadDidFinish");
    
}

@end
