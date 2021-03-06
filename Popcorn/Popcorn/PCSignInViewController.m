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

#import "PCMainTabBarController.h"
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

#pragma mark - Init
- (void)viewDidLoad {
    [super viewDidLoad];
    
#ifdef DEBUG
    [self initTestSetting];
#endif
    self.loginManager = [[PCLoginManager alloc] init];
    self.loginManager.delegate = self;
    [self makeNavigationView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboardWhenTouchOutSideOfTextField)];
    [self.view addGestureRecognizer:tap];
    
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
    self.idTextField.text = @"giftbott";
    self.pwTextField.text = @"giftbott1";
    self.isValidID = YES;
    self.isValidPW = YES;
}



#pragma mark - makeCustomView
- (void)makeNavigationView {
    [self.navigationController setNavigationBarHidden:YES];
    
    PCLoginNaviView *viewNavi = [[PCLoginNaviView alloc] initWithType:LoginNaviBarTypePreve andViewController:self];
    [viewNavi.prevButton addTarget:self action:@selector(onTouchUpToNextPage:) forControlEvents:UIControlEventTouchUpInside];
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
        PCMainTabBarController *mainView = [storyboard instantiateInitialViewController];
        [self.navigationController showViewController:mainView sender:self];
        
        [[PCUserInformation sharedUserData] hasUserSignedIn:token];
    }
    else {
        alertLog(@"유저정보가 올바르지 않습니다.");
    }
}

- (void)didReceiveUserInformation:(NSDictionary *)userInformation {
    if (userInformation) {
        [[PCUserInformation sharedUserData] setUserInformationFromServer:userInformation];
    }
    else {
        alertLog(@"서버에서 유저정보를 가져오지 못했습니다.");
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



- (void)hideKeyboardWhenTouchOutSideOfTextField {
    [_idTextField endEditing:YES];
    [_pwTextField endEditing:YES];
}


#pragma mark -
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    dLog(@" ");
}

@end
