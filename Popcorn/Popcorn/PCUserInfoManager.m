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
@property (nonatomic) AFHTTPRequestSerializer *serializer;
@property (nonatomic) NSURLSessionDataTask *dataTask;
@property (nonatomic) NSURLSessionUploadTask *uploadTask;
@property (nonatomic) UIActivityIndicatorView *activityIndicatorView;

@end


//static NSString *const UserFavoriteGenreKey


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
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    }
    return self;
}



#pragma mark - Execute DataTask and CompletionHandler
- (void)resumeDataTaskWithRequest:(NSMutableURLRequest *)request andCompletionHandler:(UserInfoTaskHandler)completionHandler{
    
    [request setValue:[PCUserInformation sharedUserData].userToken forHTTPHeaderField:AuthorizationHeaderKey];
    
    _dataTask = [_sessionManager dataTaskWithRequest:request
                                   completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                                       BOOL result = YES;
                                       
                                       NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
                                       if (error) {
                                           result = NO;
                                           if (statusCode == 406) {
                                               sLog(@"이미 코멘트 등록");
                                           }
                                           else {
                                               aLog(@"에러 발생. %@", error);
                                           }
                                       }
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           completionHandler(result);
                                           [self stopActivityIndicatorViewAnimating];
                                       });
                                   }];
    [_dataTask resume];
    [self startActivityIndicatorViewAnimating];
}


#pragma mark - Execute UploadTask and CompletionHandler
- (void)resumeUploadTaskWithRequest:(NSURLRequest *)request andCompletionHandler:(UserInfoTaskHandler)completionHandler{
    _uploadTask = [_sessionManager uploadTaskWithStreamedRequest:request
                                                        progress:^(NSProgress * _Nonnull uploadProgress) {
                                                        }
                                               completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                                                   BOOL result = YES;
                                                   if (error) {
                                                       result = NO;
                                                       aLog(@"에러 발생. %@", error);
                                                   }
                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                       completionHandler(result);
                                                       [self stopActivityIndicatorViewAnimating];
                                                   });
                                               }];
    [_uploadTask resume];
    [self startActivityIndicatorViewAnimating];
    
}

- (void)startActivityIndicatorViewAnimating {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIViewController *currentVC = [window rootViewController];
    
    self.activityIndicatorView.center = currentVC.view.center;
    self.activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [currentVC.view addSubview:_activityIndicatorView];
    
    self.activityIndicatorView.hidden = NO;
    [self.activityIndicatorView startAnimating];
}

- (void)stopActivityIndicatorViewAnimating {
    self.activityIndicatorView.hidden = YES;
    [self.activityIndicatorView stopAnimating];
}


#pragma mark - Related With User Profile
- (void)changeUserProfile:(NSString *)userProfileKey withNewData:(NSString *)newData andCompletionHandler:(UserInfoTaskHandler)completionHandler {
    NSString *urlString = [memberURLString stringByAppendingString:@"user/"];
    NSDictionary *params = @{userProfileKey:newData};
    
    _serializer = [AFHTTPRequestSerializer serializer];
    NSMutableURLRequest *request = [_serializer requestWithMethod:@"PATCH"
                                                 URLString:urlString
                                                parameters:params
                                                     error:nil];
    
    [self resumeDataTaskWithRequest:request andCompletionHandler:completionHandler];
}


- (void)changeUserProfileImage:(UIImage *)profileImage withCompletionHandler:(UserInfoTaskHandler)completionHandler {
    NSString *urlString = [memberURLString stringByAppendingString:@"user/"];
    NSData *testImageData = UIImageJPEGRepresentation(profileImage, 0.2);
    
    _serializer = [AFHTTPRequestSerializer serializer];
    NSMutableURLRequest *request = [_serializer multipartFormRequestWithMethod:@"PATCH"
                                                                     URLString:urlString
                                                                    parameters:nil
                                                     constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                                                         [formData appendPartWithFileData:testImageData
                                                                                     name:@"profile_img"
                                                                                 fileName:@"profile_image.jpg"
                                                                                 mimeType:@"image/jpg"];
                                                     }
                                                                         error:nil
                                    ];
    
    [request setValue:[PCUserInformation sharedUserData].userToken forHTTPHeaderField:AuthorizationHeaderKey];
    [self resumeUploadTaskWithRequest:request andCompletionHandler:completionHandler];
}


- (void)changeUserFavoriteTags:(NSDictionary *)tags withCompletionHandler:(UserInfoTaskHandler)completionHandler {
    NSString *urlString = [memberURLString stringByAppendingString:@"user/"];
    NSDictionary *params = @{PCUserProfileFavoriteGenreKey:@[@1,@3,@5],
                             PCUserProfileFavoriteGradeKey:@[@1,@2,@3],
                             PCUserProfileFavoriteCountryKey:@[@1,@2,@4],
                             };
    
    _serializer = [AFJSONRequestSerializer serializer];
    NSMutableURLRequest *request = [_serializer requestWithMethod:@"PATCH"
                                                        URLString:urlString
                                                       parameters:params
                                                            error:nil];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [self resumeDataTaskWithRequest:request andCompletionHandler:completionHandler];
}


- (void)deleteAllFavoriteTagsWithCompletionHandler:(UserInfoTaskHandler)completionHandler {
    NSString *urlString = [memberURLString stringByAppendingString:@"delete-favorite/"];
    
    _serializer = [AFHTTPRequestSerializer serializer];
    NSMutableURLRequest *request = [_serializer requestWithMethod:@"POST"
                                                 URLString:urlString
                                                parameters:nil
                                                     error:nil];
    [self resumeDataTaskWithRequest:request andCompletionHandler:completionHandler];
}


#pragma mark - Related With Movie
- (void)saveMovieRating:(CGFloat)ratingValue withMovieID:(NSString *)movieID andCompletionHandler:(UserInfoTaskHandler)completionHandler {
    NSString *addString = [NSString stringWithFormat:@"%@/comment/", movieID];
    NSString *urlString = [movieURLString stringByAppendingString:addString];
    
    NSString *ratingString = [NSString stringWithFormat:@"%.1f", ratingValue];
    NSDictionary *params = @{@"star":ratingString};
    
    _serializer = [AFJSONRequestSerializer serializer];
    NSMutableURLRequest *request = [_serializer requestWithMethod:@"POST"
                                                 URLString:urlString
                                                parameters:params
                                                     error:nil];
    [self resumeDataTaskWithRequest:request andCompletionHandler:completionHandler];
}

@end
