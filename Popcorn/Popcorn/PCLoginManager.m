//
//  PCLoginManager.m
//  Popcorn
//
//  Created by giftbot on 2016. 11. 28..
//  Copyright © 2016년 giftbot. All rights reserved.
//

#import "PCLoginManager.h"

#import <AFNetworking.h>
#import "PCNetworkParamKey.h"


@interface PCLoginManager ()

@property (nonatomic) NSURLSessionDataTask *dataTask;
@property (nonatomic) AFHTTPRequestSerializer *serializer;
@property (nonatomic) AFHTTPSessionManager *manager;
@property (nonatomic) UIActivityIndicatorView *activityIndicatorView;

@end

@implementation PCLoginManager

- (instancetype)init {
    self = [super init];
    if (self) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        _manager = [[AFHTTPSessionManager manager] initWithSessionConfiguration:configuration];
        _serializer = [AFHTTPRequestSerializer serializer];
        
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    }
    return self;
}

#pragma mark - Sign Up
- (void)signUpWithFacebook {
    BOOL isSuccess = YES;
    // 페이스북으로 회원가입 시도 후 결과 저장
    [self.delegate didSignUpWithFacebook:isSuccess];
}

- (void)signUpWithID:(NSDictionary *)form {
    NSString *urlString = [memberURLString stringByAppendingString:@"registration/"];
    NSURLRequest *request = [_serializer requestWithMethod:@"POST"
                                                URLString:urlString
                                               parameters:form
                                                    error:nil];
    
    PCLoginManager *weakSelf = self;
    self.dataTask = [_manager dataTaskWithRequest:request
                                completionHandler:^(NSURLResponse * _Nonnull response, NSDictionary * _Nullable responseObject, NSError * _Nullable error) {
                                    
                                    NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
                                    dLog(@"status code : %ld", statusCode);
                                    
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        if ([weakSelf.delegate respondsToSelector:@selector(didSignUpWithID:andResponseObject:)]) {
                                            if (statusCode == PCSignUpFailed) {
                                                [weakSelf.delegate didSignUpWithID:statusCode andResponseObject:responseObject];
                                            }
                                            else {
                                                [weakSelf.delegate didSignUpWithID:statusCode andResponseObject:nil];
                                                [self stopActivityIndicatorAnimating];
                                            }
                                        }
                                    });
                                }];
    [_dataTask resume];
    [self startActivityIndicatorAnimating];
}



#pragma mark - Sign In
- (void)signInWithFacebookID:(NSString *)facebookID andToken:(NSString *)token {
    BOOL isSuccess = YES;
    // 페이스북으로 로그인 시도 후 결과 저장
    [self.delegate didSignInWithFacebook:isSuccess];
}

- (void)signInWithID:(NSString *)loginID andPassword:(NSString *)password {
    NSString *urlString = [memberURLString stringByAppendingString:@"login/"];
    NSDictionary *parameters = @{SignInIDKey:loginID,
                                 SignInPasswordKey:password};
    
    NSURLRequest *request = [_serializer requestWithMethod:@"POST"
                                                 URLString:urlString
                                                parameters:parameters
                                                     error:nil];
    
    PCLoginManager *weakSelf = self;
    self.dataTask = [_manager dataTaskWithRequest:request
                                completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                                    NSString *token = nil;
                                    if (error) {
                                        dLog(@"Error Domain : %@", error.domain);
                                        dLog(@"Error UserInfo : %@", error.userInfo);
                                    }
                                    else {
                                        token = responseObject[TokenKey];
                                        if (token) {
                                            dLog(@"success token : %@", token);
                                        }
                                    }
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        if ([weakSelf.delegate respondsToSelector:@selector(didSignInWithID:)]) {
                                            [weakSelf.delegate didSignInWithID:token];
                                            [weakSelf requestUserInformation:token];
                                        }
                                    });
    }];
    [self startActivityIndicatorAnimating];
    [_dataTask resume];
}

- (void)requestUserInformation:(NSString *)token {
    NSString *urlString = [memberURLString stringByAppendingString:@"user/"];
    
    NSMutableURLRequest *request = [_serializer requestWithMethod:@"GET"
                                                        URLString:urlString
                                                       parameters:nil
                                                            error:nil];
    NSString *tokenValue = [NSString stringWithFormat:@"Token %@", token];
    [request setValue:tokenValue forHTTPHeaderField:@"Authorization"];
    
    PCLoginManager *weakSelf = self;
    self.dataTask = [_manager dataTaskWithRequest:request
                                completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                                    NSDictionary *userInformation;
                                    if (error) {
                                        dLog(@"Error Domain : %@", error.domain);
                                        dLog(@"Error UserInfo : %@", error.userInfo);
                                    }
                                    else {
                                        userInformation = responseObject;
                                        if (userInformation) {
                                            dLog(@"success");
                                        }
                                    }
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        if ([weakSelf.delegate respondsToSelector:@selector(didReceiveUserInformation:)]) {
                                            [weakSelf.delegate didReceiveUserInformation:userInformation];
                                            [weakSelf stopActivityIndicatorAnimating];
                                        }
                                    });
    }];
    [_dataTask resume];
}
                                        

- (void)startActivityIndicatorAnimating {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIViewController *currentVC = [window rootViewController];
    
    self.activityIndicatorView.center = currentVC.view.center;
    self.activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    [currentVC.view addSubview:_activityIndicatorView];
    
    self.activityIndicatorView.hidden = NO;
    [self.activityIndicatorView startAnimating];
}

- (void)stopActivityIndicatorAnimating {
    self.activityIndicatorView.hidden = YES;
    [self.activityIndicatorView stopAnimating];
}

- (void)requestNewPassword {
    BOOL isSuccess = YES;
    // 서버에 패스워드 이메일로 전송 요청 후 결과 isSuccess에 저장
    [self.delegate didSendPasswordToID:isSuccess];
}


#pragma mark -
- (void)dealloc {
    dLog(@" ");
}

@end


