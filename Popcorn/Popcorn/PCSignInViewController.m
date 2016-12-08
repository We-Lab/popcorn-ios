//
//  PCSignInViewController.m
//  Popcorn
//
//  Created by giftbot on 2016. 11. 27..
//  Copyright © 2016년 giftbot. All rights reserved.
//

#import "PCSignInViewController.h"

#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>

#import "PCMainViewController.h"
#import "PCLoginNaviView.h"
#import "PCUserInformation.h"
#import "PCUserInfoValidation.h"

@interface PCSignInViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *signInButton;
@property (weak, nonatomic) IBOutlet UITextField *idTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwTextField;

@property (nonatomic) PCLoginManager *loginManager;
@property (nonatomic) BOOL isValidID;
@property (nonatomic) BOOL isValidPW;

@end

@implementation PCSignInViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    
#ifdef DEBUG
    [self initTestSetting];
#endif
    self.loginManager = [[PCLoginManager alloc] init];
    self.loginManager.delegate = self;
    [self makeNavigationView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
#ifndef DEBUG
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"PCSignInViewController"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
#endif
}

- (void)initTestSetting {
    self.idTextField.text = @"testuser";
    self.pwTextField.text = @"testuser1";
    self.isValidID = YES;
    self.isValidPW = YES;
}

#pragma mark - makeCustomView
- (void)makeNavigationView {
    // 커스텀 네비게이션바 생성
    PCLoginNaviView *viewNavi = [[PCLoginNaviView alloc] initWithType:LoginNaviBarTypePreve ViewController:self target:self action:@selector(onTouchUpToNextPage:)];
    
    sLog([viewNavi class]);
    [self.navigationController setNavigationBarHidden:YES];
}

// 스테이터스 바 스타일 메소드
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

// 네비게이션 Pop
- (void)onTouchUpToNextPage:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Try Login
- (IBAction)requestSignIn:(UIButton *)button {
    if (_isValidID && _isValidPW) {
//        [FBSDKAppEvents logEvent:@"requestSuccessSignIn"];
        [self.loginManager signInWithID:_idTextField.text andPassword:_pwTextField.text];
    }
    else {
//        [FBSDKAppEvents logEvent:@"requestFailureSignIn"];
    }
}

- (IBAction)requestSignInWithFacebook:(UIButton *)button {
    FBSDKLoginManager *fbLoginManager = [[FBSDKLoginManager alloc] init];
    [fbLoginManager logInWithReadPermissions:@[@"public_profile", @"email", @"user_friends", @"user_birthday", @"user_location"]
                          fromViewController:self
                                     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                                         if (error) {
                                             [FBSDKAppEvents logEvent:@"requestFailureSignInWithFacebook"];
                                             aLog(@"error : %@", error);
                                             [PCCommonUtility alertControllerWithOnlyTitle:@"로그인에 실패하였습니다."];
                                         }
                                         if (result.isCancelled) {
                                             [FBSDKAppEvents logEvent:@"requestCancelSignInWithFacebook"];
                                             sLog(@"로그인 취소");
                                         }
                                         else {
                                             [FBSDKAppEvents logEvent:@"requestSuccessSignInWithFacebook"];
                                             sLog(@"로그인 성공");
                                             
//                                             NSString *token = [result token].tokenString;
//                                             [_loginManager signInWithFacebookID:userID withToken:token];
                                         }
                                     }];
}


-(void)fetchUserInfo {
    sLog([FBSDKAccessToken currentAccessToken].tokenString);
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                  initWithGraphPath:@"/me"
                                  parameters:@{ @"fields": @"id,name,email,birthday,gender,location,picture",}
                                  HTTPMethod:@"GET"];
    
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        if (error) {
            //
        }
        else {
        }
    }];
}


#pragma mark - Login Delegate Method
- (void)didSignInWithFacebook:(BOOL)isSuccess {
    
}

- (void)didSignInWithID:(NSString *)token {
    if (token) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        PCMainViewController *mainView = [storyboard instantiateInitialViewController];
        [self.navigationController pushViewController:mainView animated:YES];
        
        [[PCUserInformation userInfo] hasUserSignedIn:token];
    }
    else {
        alertLog(@"유저정보가 올바르지 않습니다.");
    }
}


#pragma mark - TextField Delegate Configure
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if( [textField isEqual:_idTextField] ){
        [_idTextField endEditing:YES];
        
        if (_pwTextField.text.length == 0)
            [_pwTextField becomeFirstResponder];
    }
    else if ( [textField isEqual:_pwTextField] ) {
        [_pwTextField endEditing:YES];
    }
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *text;
    if (range.length == 0) {
        text = [textField.text stringByAppendingString:string];
    }
    else if (range.length == 1) {
        text = [textField.text substringToIndex:range.location];
    }
    else {
        return YES;
    }
    
    NSInteger textLength = text.length;
    if (textField == _idTextField) {
        self.isValidID = NO;
        if (textLength >= 4 && textLength <= 10) {
            self.isValidID = [PCUserInfoValidation isValidID:text];
        }
    }
    else if (textField == _pwTextField) {
        self.isValidPW = NO;
        if (textLength >= 6) {
            self.isValidPW = [PCUserInfoValidation isValidPW:text];
        }
    }
    
    if (_isValidID && _isValidPW) {
        // 로그인 버튼 활성화
    }
    else {
        // 로그인 버튼 비활성화
    }

    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    dLog(@" ");
}

@end
