//
//  WITInstanceIdFetcher.m
//  WITTuto
//
//  Created by Aric Lasry on 10/8/14.
//  Copyright (c) 2014 Aric Lasry. All rights reserved.
//

#import "WITInstanceIdFetcher.h"
#import <Wit/Wit.h>

@implementation WITInstanceIdFetcher {
    NSMutableData *InstanceIdData;
    NSURLConnection *conn;
}

-(void)get {
    
    InstanceIdData = [[NSMutableData alloc] init];
    NSString *url = [[NSString alloc] initWithFormat:@"https://gist.githubusercontent.com/ar7hur/5fd63af5bb7b78e8c322/raw/token"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    request.HTTPMethod = @"GET";
    conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [InstanceIdData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSString *instanceId = [[NSString alloc] initWithData:InstanceIdData encoding:NSUTF8StringEncoding];
    NSLog(@"instance id finished loading: %@", instanceId);
    [Wit sharedInstance].accessToken = instanceId;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"WITVadTracker error: %@", error);
}

-(void) dealloc {
    NSLog(@"Clean WITInstanceIdFetcher");
}


@end
