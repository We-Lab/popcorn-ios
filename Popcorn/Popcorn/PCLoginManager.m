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

typedef void(^DataTaskHandler)(NSURLResponse *, id, NSError *);

@interface PCLoginManager ()
@property (nonatomic) AFURLSessionManager *manager;
@property (nonatomic) NSURLSessionDataTask *dataTask;
@property DataTaskHandler completionHandler;
@end


@implementation PCLoginManager

- (instancetype)init {
    self = [super init];
    if (self) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        _manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        [self createDataTaskHandler];
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
    NSString *urlString = [baseURLString stringByAppendingString:@"registration/"];
    
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    NSURLRequest *request = [serializer requestWithMethod:@"POST"
                                                URLString:urlString
                                               parameters:form
                                                    error:nil];
    
    self.dataTask = [_manager dataTaskWithRequest:request completionHandler:_completionHandler];
    [_dataTask resume];
}

#pragma mark - Sign In
- (void)signInWithFacebookID:(NSString *)facebookID andToken:(NSString *)token {
    BOOL isSuccess = YES;
    // 페이스북으로 로그인 시도 후 결과 저장
    [self.delegate didSignInWithFacebook:isSuccess];
}

- (void)signInWithID:(NSString *)loginID andPassword:(NSString *)password {
    NSString *urlString = [baseURLString stringByAppendingString:@"login/"];
    NSDictionary *parameters = @{SignInIDKey:loginID,
                                 SignInPasswordKey:password};
    
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    NSURLRequest *request = [serializer requestWithMethod:@"POST"
                                                URLString:urlString
                                               parameters:parameters
                                                    error:nil];
    
    self.dataTask = [_manager dataTaskWithRequest:request completionHandler:_completionHandler];
    [_dataTask resume];
}

- (void)createDataTaskHandler {
    __weak PCLoginManager *weakSelf = self;
    self.completionHandler = ^(NSURLResponse * _Nonnull response, id _Nullable responseObject, NSError * _Nullable error) {
        NSString *token = nil;
        
        if (error) {
            dLog(@"error : %@", error);
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
            }
        });
    };
}

- (void)requestNewPassword {
    BOOL isSuccess = YES;
    // 서버에 패스워드 이메일로 전송 요청 후 결과 isSuccess에 저장
    [self.delegate didSendPasswordToID:isSuccess];
}

- (void)dealloc {
    dLog(@" ");
}

@end
