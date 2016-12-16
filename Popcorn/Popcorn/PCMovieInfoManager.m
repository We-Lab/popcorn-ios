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


#pragma mark - Init
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


#pragma mark - Execute DataTask and CompletionHandler
- (void)resumeDataTaskWithRequest:(NSURLRequest *)request andCompletionHandler:(NetworkTaskHandler)completionHandler {
    _dataTask = [_sessionManager dataTaskWithRequest:request
                                   completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                                       BOOL result = NO;
                                       if (error || [responseObject firstObject] == nil) {
                                           aLog(@"에러 발생. %@", error);
                                       }
                                       else {
                                           result = YES;
                                       }
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                            completionHandler(result, responseObject);
                                        });
                                   }];
    [_dataTask resume];
}


#pragma mark - Configure Request
- (void)requestRankingList:(RankingListType)rankingType withCompletionHandler:(NetworkTaskHandler)completionHandler {
    NSString *urlString;
    
    switch (rankingType) {
        case BoxOfficeRankingDetailList:
//            urlString = [movieURLString stringByAppendingString:@"main/BoxOfficeRanking"];
            break;
        case RatingRankingDetailList:
//            urlString =
            break;
        case LikeRankingDetailList:
//            urlString =
            break;
    }
    NSURLRequest *request = [_serializer requestWithMethod:@"GET"
                                                 URLString:urlString
                                                parameters:nil
                                                     error:nil];
    
    [self resumeDataTaskWithRequest:request andCompletionHandler:completionHandler];
}

- (void)requestMovieList:(NSString *)inputText withCompletionHandler:(NetworkTaskHandler)completionHandler {
    NSCharacterSet *allowedCharacterSet = [NSCharacterSet URLQueryAllowedCharacterSet];
    NSString *urlString = [movieURLString stringByAppendingString:@"search/?keyword="];
    urlString = [[urlString stringByAppendingString:inputText] stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet];
    
    NSURLRequest *request = [_serializer requestWithMethod:@"GET"
                                                 URLString:urlString
                                                parameters:nil
                                                     error:nil];

    [self resumeDataTaskWithRequest:request andCompletionHandler:completionHandler];
}

- (void)requestBoxOfficeListwithCompletionHandler:(NetworkTaskHandler)completionHandler {
    NSString *urlString = [mainURLString stringByAppendingString:@"box-office/ios"];
    NSURLRequest *request = [_serializer requestWithMethod:@"GET"
                                                 URLString:urlString
                                                parameters:nil
                                                     error:nil];
    
    [self resumeDataTaskWithRequest:request andCompletionHandler:completionHandler];
}


- (void)requestMagazineListWithCompletionHandler:(NetworkTaskHandler)completionHandler {
    NSString *urlString = [mainURLString stringByAppendingString:@"magazines/"];
    NSURLRequest *request = [_serializer requestWithMethod:@"GET"
                                                 URLString:urlString
                                                parameters:nil
                                                     error:nil];
    
    [self resumeDataTaskWithRequest:request andCompletionHandler:completionHandler];
}

- (void)requestBestCommentWithCompletionHandler:(NetworkTaskHandler)completionHandler {
    NSString *urlString = [mainURLString stringByAppendingString:@"best-comment/"];
    NSURLRequest *request = [_serializer requestWithMethod:@"GET"
                                                 URLString:urlString
                                                parameters:nil
                                                     error:nil];
    
    [self resumeDataTaskWithRequest:request andCompletionHandler:completionHandler];
}

- (void)requestTodayRecommendMovieWithCompletionHandler:(NetworkTaskHandler)completionHandler {
    NSString *urlString = [mainURLString stringByAppendingString:@"movie-recommends/carousel/"];
    NSURLRequest *request = [_serializer requestWithMethod:@"GET"
                                                 URLString:urlString
                                                parameters:nil
                                                     error:nil];
    
    [self resumeDataTaskWithRequest:request andCompletionHandler:completionHandler];
}

- (void)requestMovieListWithTag:(NSArray *)tagArray andCompletionHandler:(NetworkTaskHandler)completionHandler {
//    NSString *urlString = [mainURLString stringByAppendingString:@"box_office/"];
//    NSURLRequest *request = [_serializer requestWithMethod:@"GET"
//                                                 URLString:urlString
//                                                parameters:nil
//                                                     error:nil];
    
//    [self resumeDataTaskWithRequest:request andCompletionHandler:completionHandler];
}

@end
