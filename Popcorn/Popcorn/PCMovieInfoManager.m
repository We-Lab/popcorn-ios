//
//  MovieInfoManager.m
//  Popcorn
//
//  Created by giftbot on 2016. 11. 29..
//  Copyright © 2016년 giftbot. All rights reserved.
//

#import "PCMovieInfoManager.h"

#import <AFNetworking.h>
#import "PCNetworkParamKey.h"

@interface PCMovieInfoManager ()
@property (nonatomic) AFURLSessionManager *sessionManager;
@property (nonatomic) AFHTTPRequestSerializer *serializer;
@property (nonatomic) NSURLSessionDataTask *dataTask;
@end

@implementation PCMovieInfoManager

+ (instancetype)movieManager {
    static PCMovieInfoManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[PCMovieInfoManager alloc] init];
    });
    
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        _sessionManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        _serializer = [AFHTTPRequestSerializer serializer];
    }
    return self;
}

+ (NSDictionary *)requestMovieDetail:(NSString *)movieID {
    return nil;
}

+ (NSDictionary *)requestActorDetail:(NSString *)actorID {
    return nil;
}

+ (NSDictionary *)requestAllComments:(NSString *)movieID {
    return nil;
}

+ (NSDictionary *)requestAllFamousLines:(NSString *)movieID {
    return nil;
}

- (void)requestMovieList:(NSString *)inputText withCompletionHandler:(void (^)(BOOL isSuccess, NSArray *movieListData))completionHandler {
    NSCharacterSet *allowedCharacterSet = [NSCharacterSet URLQueryAllowedCharacterSet];
    NSString *urlString = [movieURLString stringByAppendingString:@"search/?keyword="];
    urlString = [[urlString stringByAppendingString:inputText] stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet];
    
    NSURLRequest *request = [_serializer requestWithMethod:@"GET"
                                                 URLString:urlString
                                                parameters:nil
                                                     error:nil];

    _dataTask = [_sessionManager dataTaskWithRequest:request
                                   completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                                       if (error) {
                                           aLog(@"에러 발생. %@", error);
                                           completionHandler(NO, responseObject);
                                       }
                                       else {
                                           completionHandler(YES, responseObject);
                                       }
                                   }];
    [_dataTask resume];
}


@end
