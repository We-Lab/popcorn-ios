//
//  PCSignInViewController.m
//  Popcorn
//
//  Created by giftbot on 2016. 11. 27..
//  Copyright © 2016년 giftbot. All rights reserved.
//

#import "PCSignInViewController.h"

#import "PCMainViewController.h"
#import "PCLoginNaviView.h"
#import "PCUserInformation.h"
#import "PCUserInfoValidation.h"
#import "KeychainItemWrapper.h"

@interface PCSignInViewController () <UITextFieldDelegate>

@property (nonatomic) IBOutlet UITextField *idTextField;
@property (nonatomic) IBOutlet UITextField *pwTextField;

@end

@implementation PCSignInViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    
#ifdef DEBUG
    [self initTestSetting];
#endif
    [PCLoginManager loginManager].delegate = self;
    [self makeNavigationView];
}

- (void)initTestSetting {
    _idTextField.text = @"testuser";
    _pwTextField.text = @"testuser1";
}

#pragma mark - makeCustomView
- (void)makeNavigationView {
    // 커스텀 네비게이션바 생성
    PCLoginNaviView *viewNavi = [[PCLoginNaviView alloc] initWithType:LoginNaviBarTypePreve ViewController:self target:self action:@selector(onTouchUpToNextPage:)];
    
    sLog([viewNavi class]);
    
    [self.navigationController setNavigationBarHidden:YES];
    
    [self preferredStatusBarStyle];
//    self.preferredStatusBarStyle = UIStatusBarStyleLightContent;
    self.edgesForExtendedLayout=UIRectEdgeTop;
    self.automaticallyAdjustsScrollViewInsets=NO;
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
- (IBAction)TappedSignInButton:(id)sender {
    BOOL isValidID = [PCUserInfoValidation isValidID:_idTextField.text];
    BOOL isValidPW = [PCUserInfoValidation isValidPW:_pwTextField.text];
    
    if (!isValidID) {
        alertLog(@"아이디가 양식에 맞지 않습니다.");
    }
    else if (!isValidPW) {
        alertLog(@"비밀번호가 양식에 맞지 않습니다.");
    }
    
    [[PCLoginManager loginManager] signInWithID:_idTextField.text andPassword:_pwTextField.text];
}

#pragma mark - Login Delegate Method
- (void)didSignInWithFacebook:(BOOL)isSuccess {
    
}

- (void)didSignInWithID:(NSString *)token {
    if (token) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        PCMainViewController *mainView = [storyboard instantiateInitialViewController];
        [self.navigationController pushViewController:mainView animated:YES];
        
        // 키체인에 토큰값 저장
        KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"popcornKey" accessGroup:nil];
        [keychainItem setObject:token forKey:(id)kSecAttrAccount];
        [[PCUserInformation userInfo] setUserTokenFromKeyChain];
    }
    else {
        alertLog(@"유저정보가 올바르지 않습니다.");
    }
}


#pragma mark - TextField Delegate Configure
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if( [textField isEqual:_idTextField] ){
        [_idTextField endEditing:YES];
        [_pwTextField becomeFirstResponder];
    }
    else {
        [_pwTextField endEditing:YES];
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
