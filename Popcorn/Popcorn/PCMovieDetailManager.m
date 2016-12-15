//
//  PCMovieDetailManager.m
//  Popcorn
//
//  Created by chaving on 2016. 12. 14..
//  Copyright © 2016년 giftbot. All rights reserved.
//

#import "PCMovieDetailManager.h"

#import <AFNetworking.h>
#import "PCNetworkParamKey.h"
#import "PCMovieDetailDataCenter.h"

typedef void(^DataTaskHandler)(NSURLResponse *, id, NSError *);


@interface PCMovieDetailManager ()
@property (nonatomic) AFURLSessionManager *manager;
@property (nonatomic) NSURLSessionDataTask *dataTask;
@property DataTaskHandler completionHandler;
@end

@implementation PCMovieDetailManager

- (instancetype)init {
    self = [super init];
    if (self) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        _manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        [self createDataTaskHandler];
    }
    return self;
}



- (void)requestMovieDetailData {

    NSLog(@"Request");
    
    NSString *movieID = @"70";
    
    NSString *movieDetailDataURLString = [movieURLString stringByAppendingString:[NSString stringWithFormat:@"%@", movieID]];
    NSURL *movieDetailRequestURL = [NSURL URLWithString:movieDetailDataURLString];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setURL:movieDetailRequestURL];

    id taskHandler = ^(NSURLResponse *response, id responseObject, NSError *error){
        
        if (error) {
            NSLog(@"error : %@",error);
        }else if (responseObject) {
            
            [PCMovieDetailDataCenter sharedMovieDetailData].movieDetailDictionary = responseObject;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:movieDataRequestNotification
                                                                object:nil];
        });
    };
    
    self.dataTask = [_manager dataTaskWithRequest:request completionHandler:taskHandler];
    
    [_dataTask resume];
}

- (void)createDataTaskHandler {
    
    self.completionHandler = ^(NSURLResponse * _Nonnull response, id _Nullable responseObject, NSError * _Nullable error) {
        
        if (error) {
            dLog(@"error : %@", error);
        }
        else {
            
            if (responseObject) {
                dLog(@"success data : %@", responseObject);
            }
        }
    };
}

@end
