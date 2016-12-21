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
#import "PCUserInformation.h"

@interface PCMovieInfoManager ()

@property (nonatomic) AFURLSessionManager *sessionManager;
@property (nonatomic) AFHTTPRequestSerializer *serializer;
@property (nonatomic) NSURLSessionDataTask *dataTask;

@property (nonatomic) UIActivityIndicatorView *activityIndicatorView;

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
        
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    }
    return self;
}


#pragma mark - Execute DataTask and CompletionHandler
- (void)resumeDataTaskWithRequest:(NSURLRequest *)request andCompletionHandler:(NetworkTaskHandler)completionHandler {
    _dataTask = [_sessionManager dataTaskWithRequest:request
                                   completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                                       BOOL result = NO;
                                       if (error) {
                                           aLog(@"에러 발생. %@", error);
                                       }
                                       else {
                                           result = YES;
                                       }
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           completionHandler(result, responseObject);
                                           self.activityIndicatorView.hidden = YES;
                                           [self.activityIndicatorView stopAnimating];
                                        });
                                   }];
    [_dataTask resume];
    
    // UIActivityView
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIViewController *currentVC = [window rootViewController];
    
    self.activityIndicatorView.center = currentVC.view.center;
    self.activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [currentVC.view addSubview:_activityIndicatorView];

    self.activityIndicatorView.hidden = NO;
    [self.activityIndicatorView startAnimating];
}


#pragma mark - Pass Request Form (Common Method)
- (void)passRequestFormWithMethod:(NSString *)method URLString:(NSString *)urlString andHandler:(NetworkTaskHandler)completionHandler {
    NSURLRequest *request = [_serializer requestWithMethod:method
                                                 URLString:urlString
                                                parameters:nil
                                                     error:nil];
    
    [self resumeDataTaskWithRequest:request andCompletionHandler:completionHandler];
}



#pragma mark - Configure Request
- (void)requestMagazineListWithCompletionHandler:(NetworkTaskHandler)completionHandler {
    NSString *urlString = [mainURLString stringByAppendingString:@"magazines/"];
    [self passRequestFormWithMethod:@"GET" URLString:urlString andHandler:completionHandler];
}


- (void)requestBestCommentWithCompletionHandler:(NetworkTaskHandler)completionHandler {
    NSString *urlString = [mainURLString stringByAppendingString:@"best-comment/"];
    [self passRequestFormWithMethod:@"GET" URLString:urlString andHandler:completionHandler];
}

- (void)requestTodayRecommendMovieWithCompletionHandler:(NetworkTaskHandler)completionHandler {
    NSString *urlString = [mainURLString stringByAppendingString:@"movie-recommends/carousel/"];
    [self passRequestFormWithMethod:@"GET" URLString:urlString andHandler:completionHandler];
}

- (void)requestBoxOfficeListwithCompletionHandler:(NetworkTaskHandler)completionHandler {
    [self requestRankingList:BoxOfficeRankingDetailList withCompletionHandler:completionHandler];
}

- (void)requestRankingList:(RankingListType)rankingType withCompletionHandler:(NetworkTaskHandler)completionHandler {
    NSString *urlString;
    
    switch (rankingType) {
        case BoxOfficeRankingDetailList:
            urlString = [mainURLString stringByAppendingString:@"box-office/ios/"];
            break;
        case RatingRankingDetailList:
            urlString = [movieURLString stringByAppendingString:@"star-rank/"];
            break;
        case LikeRankingDetailList:
            urlString = [movieURLString stringByAppendingString:@"like-rank/"];
            break;
    }
    
    [self passRequestFormWithMethod:@"GET" URLString:urlString andHandler:completionHandler];
}


- (void)requestMovieList:(NSString *)inputText withCompletionHandler:(NetworkTaskHandler)completionHandler {
    NSCharacterSet *allowedCharacterSet = [NSCharacterSet URLQueryAllowedCharacterSet];
    NSString *urlString = [movieURLString stringByAppendingString:@"search/?keyword="];
    urlString = [[urlString stringByAppendingString:inputText] stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet];
    
    [self passRequestFormWithMethod:@"GET" URLString:urlString andHandler:completionHandler];
}

- (void)requestMovieByUserFavoriteWithCompletionHandler:(NetworkTaskHandler)completionHandler {
    NSString *urlString = [mainURLString stringByAppendingString:@"movie-recommends/favorites/ios/"];
    NSMutableURLRequest *request = [_serializer requestWithMethod:@"GET"
                                                        URLString:urlString
                                                       parameters:nil
                                                            error:nil];
    [request setValue:[PCUserInformation sharedUserData].userToken forHTTPHeaderField:@"Authorization"];
    
    [self resumeDataTaskWithRequest:request andCompletionHandler:completionHandler];
}

@end
