//
//  StravaClient.m
//  Derailleur
//
//  Created by Justin Cohler on 9/9/20.
//  Copyright © 2020 Benwithjamin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StravaClient.h"
#import "BikeSession.h"
#import <AFHTTPSessionManager.h>

@implementation StravaClient

- (void) uploadSession:(BikeSession *)bikeSession :(NSString *)path
{
    
    NSFileManager *filemgr = [NSFileManager defaultManager];
    NSData *data =  [filemgr contentsAtPath:path ];
    
    NSDictionary *body = @{@"activity_type": @"ride",
                           @"data_type": @"tcx"
    };

    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:body options:0 error:nil];
    
    NSDictionary *headers = @{
        @"Authorization": @"Bearer f9d4fb69eaf8c09f3a94e0c5868a1cd590032b2e"
    };
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@"https://www.strava.com"]];

//    [manager POST:@"/api/v3/uploads" parameters:nil headers:headers progress:<#^(NSProgress * _Nonnull uploadProgress)uploadProgress#> success:<#^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)success#> failure:<#^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)failure#> POST:@"/uploads" parameters:body constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        [formData appendPartWithFileData:imageData name:@"file"
//                                fileName:@"file.tcx"
//                                mimeType:@"application/xhtml+xml"];
//
//        [formData appendPartWithHeaders:jsonHeaders body:jsonData];
//    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"responseObject = %@", responseObject);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"error = %@", error);
//    }]
//
    [manager POST:@"/api/v3/uploads" parameters:body headers:headers constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileURL:[NSURL fileURLWithPath:path] name:@"file" error:nil];
    } progress:nil success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSLog(@"Success: %@", responseObject);
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

@end

