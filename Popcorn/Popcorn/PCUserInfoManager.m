//
//  PCUserInteractionManager.m
//  Popcorn
//
//  Created by giftbot on 2016. 12. 19..
//  Copyright © 2016년 giftbot. All rights reserved.
//

#import "PCUserInfoManager.h"

#import <AFNetworking.h>

#import "PCNetworkParamKey.h"
#import "PCUserInformation.h"

@interface PCUserInfoManager ()

@property (nonatomic) AFURLSessionManager *sessionManager;
//@property (nonatomic) AFHTTPRequestSerializer *serializer;
@property (nonatomic) AFJSONRequestSerializer *serializer;
@property (nonatomic) NSURLSessionDataTask *dataTask;

@property (nonatomic) UIActivityIndicatorView *activityIndicatorView;

@end

@implementation PCUserInfoManager

+ (instancetype)userInfoManager {
    static PCUserInfoManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[PCUserInfoManager alloc] init];
    });
    
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        _sessionManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        _serializer = [AFJSONRequestSerializer serializer];
        
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    }
    return self;
}



#pragma mark - Execute DataTask and CompletionHandler
- (void)resumeDataTaskWithRequest:(NSURLRequest *)request andCompletionHandler:(UserInfoTaskHandler)completionHandler{
    _dataTask = [_sessionManager dataTaskWithRequest:request
                                   completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                                       BOOL result = YES;
                                       if (error) {
                                           result = NO;
                                           aLog(@"에러 발생. %@", error);
                                       }
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           if (result)
                                               completionHandler();
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
- (void)passRequestFormWithMethod:(NSString *)method urlString:(NSString *)urlString parameters:(NSDictionary *)params andCompletionHandler:(UserInfoTaskHandler)completionHandler{
    NSMutableURLRequest *request = [_serializer requestWithMethod:method
                                                 URLString:urlString
                                                parameters:params
                                                     error:nil];
    
    [request setValue:[PCUserInformation sharedUserData].userToken forHTTPHeaderField:@"Authorization"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [self resumeDataTaskWithRequest:request andCompletionHandler:completionHandler];
}


#pragma mark - Related With User Profile
- (void)changeUserProfile:(NSString *)userProfileKey withCompletionHandler:(UserInfoTaskHandler)completionHandler {
    NSString *urlString = [memberURLString stringByAppendingString:@"user/"];
#warning 이부분 수정필요
    NSDictionary *params = nil;
    [self passRequestFormWithMethod:@"PATCH" urlString:urlString parameters:params andCompletionHandler:completionHandler];
    
}

- (void)changeUserFavoriteTags:(NSDictionary *)tags withCompletionHandler:(UserInfoTaskHandler)completionHandler {
    NSString *urlString = [memberURLString stringByAppendingString:@"user/"];
    [self passRequestFormWithMethod:@"PATCH" urlString:urlString parameters:tags andCompletionHandler:completionHandler];
}


#pragma mark - Related With Movie
- (void)saveMovieRating:(NSString *)movieID {
    
}

@end
