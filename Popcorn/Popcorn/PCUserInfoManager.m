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
                                           aLog(@"%ld", statusCode);
                                           aLog(@"에러 발생. %@", error);
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
- (void)resumeUploadTaskWithRequest:(NSMutableURLRequest *)request andCompletionHandler:(UserInfoTaskHandler)completionHandler{
    [request setValue:[PCUserInformation sharedUserData].userToken forHTTPHeaderField:AuthorizationHeaderKey];
    
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
    
    [self resumeUploadTaskWithRequest:request andCompletionHandler:completionHandler];
}


- (void)changeUserFavoriteTags:(NSDictionary *)tags withCompletionHandler:(UserInfoTaskHandler)completionHandler {
    NSString *urlString = [memberURLString stringByAppendingString:@"user/"];
    
    _serializer = [AFJSONRequestSerializer serializer];
    NSMutableURLRequest *request = [_serializer requestWithMethod:@"PATCH"
                                                        URLString:urlString
                                                       parameters:tags
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


#pragma mark - Post Data , Like Movie / Rating / Comment
- (void)commonPostMethodRequestWithUrlString:(NSString *)urlString parameters:(NSDictionary *)params andCompletionHandler:(UserInfoTaskHandler)completionHandler {
    _serializer = [AFJSONRequestSerializer serializer];
    NSMutableURLRequest *request = [_serializer requestWithMethod:@"POST"
                                                 URLString:urlString
                                                parameters:params
                                                     error:nil];
    
    [self resumeDataTaskWithRequest:request andCompletionHandler:completionHandler];
}


- (void)saveMovieLike:(NSString *)movieID andCompletionHandler:(UserInfoTaskHandler)completionHandler {
    NSString *addString = [NSString stringWithFormat:@"%@/movie-like/", movieID];
    NSString *urlString = [movieURLString stringByAppendingString:addString];
    
    [self commonPostMethodRequestWithUrlString:urlString parameters:nil andCompletionHandler:completionHandler];
}


- (void)saveMovieRating:(CGFloat)ratingValue withMovieID:(NSString *)movieID andCompletionHandler:(UserInfoTaskHandler)completionHandler {
    NSString *addString = [NSString stringWithFormat:@"%@/comment/", movieID];
    NSString *urlString = [movieURLString stringByAppendingString:addString];
    
    NSString *ratingString = [NSString stringWithFormat:@"%.1f", ratingValue];
    NSDictionary *params = @{@"star":ratingString};
    
    [self commonPostMethodRequestWithUrlString:urlString parameters:params andCompletionHandler:completionHandler];
}


- (void)saveMovieRating:(CGFloat)ratingValue withComment:(NSString *)comment movieID:(NSString *)movieID andCompletionHandler:(UserInfoTaskHandler)completionHandler {
    NSString *addString = [NSString stringWithFormat:@"%@/comment/", movieID];
    NSString *urlString = [movieURLString stringByAppendingString:addString];
    
    NSString *ratingString = [NSString stringWithFormat:@"%.1f", ratingValue];
    NSDictionary *params = @{ @"star":ratingString,  @"content":comment };
    
    [self commonPostMethodRequestWithUrlString:urlString parameters:params andCompletionHandler:completionHandler];
}


#pragma mark - User Profile Comment / Famous Line / Like Data
- (void)commonGetMethodRequestWithUrlString:(NSString *)urlString andCompletionHandler:(LoadUserInfoTaskHandler)completionHandler {
    _serializer = [AFHTTPRequestSerializer serializer];
    NSMutableURLRequest *request = [_serializer requestWithMethod:@"GET"
                                                 URLString:urlString
                                                parameters:nil
                                                     error:nil];
    [self resumeLoadUserInfoDataTaskWithRequest:request andCompletionHandler:completionHandler];
}

- (void)requestUserCommentListWithCompletionHandler:(LoadUserInfoTaskHandler)completionHandler {
    NSString *urlString = [memberURLString stringByAppendingString:@"my-comments/"];
    [self commonGetMethodRequestWithUrlString:urlString andCompletionHandler:completionHandler];
}

- (void)requestUserFamousListWithCompletionHandler:(LoadUserInfoTaskHandler)completionHandler {
    NSString *urlString = [memberURLString stringByAppendingString:@"my-famous/"];
    [self commonGetMethodRequestWithUrlString:urlString andCompletionHandler:completionHandler];
}

- (void)requestUserLikeMovieListWithCompletionHandler:(LoadUserInfoTaskHandler)completionHandler {
    NSString *urlString = [memberURLString stringByAppendingString:@"my-like-movie/"];
    [self commonGetMethodRequestWithUrlString:urlString andCompletionHandler:completionHandler];
}


- (void)resumeLoadUserInfoDataTaskWithRequest:(NSMutableURLRequest *)request andCompletionHandler:(LoadUserInfoTaskHandler)completionHandler {
    [request setValue:[PCUserInformation sharedUserData].userToken forHTTPHeaderField:AuthorizationHeaderKey];
    
    _dataTask = [_sessionManager dataTaskWithRequest:request
                                   completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                                       BOOL result = YES;
                                       
                                       NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
                                       if (error) {
                                           result = NO;
                                           aLog(@"%ld", statusCode);
                                           aLog(@"에러 발생. %@", error);
                                       }
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           completionHandler(result, responseObject);
                                           [self stopActivityIndicatorViewAnimating];
                                       });
                                   }];
    [_dataTask resume];
    [self startActivityIndicatorViewAnimating];
}

@end
