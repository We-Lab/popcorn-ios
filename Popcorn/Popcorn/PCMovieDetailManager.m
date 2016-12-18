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

static NSString *movieID = @"70";

@interface PCMovieDetailManager ()
@property (nonatomic) AFURLSessionManager *manager;
@property (nonatomic) NSURLSessionDataTask *dataTask;

@end

@implementation PCMovieDetailManager

- (instancetype)init {
    self = [super init];
    if (self) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        _manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    }
    return self;
}

#pragma mark - MovieDetail Request
- (NSURLSessionDataTask *)requestMovieDetailData:(DataTaskHandler)handler {
    
    NSString *movieDetailDataURLString = [movieURLString stringByAppendingString:[NSString stringWithFormat:@"%@", movieID]];
    NSURL *movieDetailRequestURL = [NSURL URLWithString:movieDetailDataURLString];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setURL:movieDetailRequestURL];

    return [_manager dataTaskWithRequest:request completionHandler:handler];
}

#pragma mark - MovieDetail BEST Commnet Request
- (NSURLSessionDataTask *)requestMovieDetailBestCommentData:(DataTaskHandler)handler {
    
    NSString *movieDetailDataURLString = [movieURLString stringByAppendingString:[NSString stringWithFormat:@"%@/comment/top", movieID]];
    NSURL *movieDetailRequestURL = [NSURL URLWithString:movieDetailDataURLString];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setURL:movieDetailRequestURL];
    
    return [_manager dataTaskWithRequest:request completionHandler:handler];
}

#pragma mark - MovieDetail BEST FamousLine Request
- (NSURLSessionDataTask *)requestMovieDetailBestFamousLineData:(DataTaskHandler)handler {
    
    NSString *movieDetailDataURLString = [movieURLString stringByAppendingString:[NSString stringWithFormat:@"%@/famous/top", movieID]];
    NSURL *movieDetailRequestURL = [NSURL URLWithString:movieDetailDataURLString];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setURL:movieDetailRequestURL];
    
    return [_manager dataTaskWithRequest:request completionHandler:handler];
}

#pragma mark - MovieDetail Commnet Request
- (NSURLSessionDataTask *)requestMovieDetailCommentData:(DataTaskHandler)handler {
    
    NSString *movieDetailDataURLString = [movieURLString stringByAppendingString:[NSString stringWithFormat:@"%@/comment", movieID]];
    NSURL *movieDetailRequestURL = [NSURL URLWithString:movieDetailDataURLString];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setURL:movieDetailRequestURL];
    
    return [_manager dataTaskWithRequest:request completionHandler:handler];
}

#pragma mark - MovieDetail FamousLine Request
- (NSURLSessionDataTask *)requestMovieDetailFamousLineData:(DataTaskHandler)handler {
    
    NSString *movieDetailDataURLString = [movieURLString stringByAppendingString:[NSString stringWithFormat:@"%@/famous", movieID]];
    NSURL *movieDetailRequestURL = [NSURL URLWithString:movieDetailDataURLString];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setURL:movieDetailRequestURL];
    
    return [_manager dataTaskWithRequest:request completionHandler:handler];
}


@end
