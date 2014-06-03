//
//  Downloader.h
//  EngageClient
//
//  Created by Eduardo Díaz on 6/2/14.
//  Copyright (c) 2014 EngageWall. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Downloader : NSObject<NSURLDownloadDelegate>

@property (strong) NSString *downloadUrl;
@property (strong) NSString *filename;


- (id) initWithDownloadUrl:(NSString *)downloadUrl;

- (void)startDownloadingURL:sender;
- (void)download:(NSURLDownload *)download didFailWithError:(NSError *)error;
- (void)downloadDidFinish:(NSURLDownload *)download;

@end
