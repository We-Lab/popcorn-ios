//
//  PCSignInViewController.m
//  Popcorn
//
//  Created by giftbot on 2016. 11. 27..
//  Copyright © 2016년 giftbot. All rights reserved.
//

#import "PCSignInViewController.h"
#import "PCLoginNaviView.h"

@interface PCSignInViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *idTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwTextField;

@end

@implementation PCSignInViewController 

#pragma mark - Basic Method

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeNavigationView];
}

#pragma mark - makeCustomView
- (void)makeNavigationView {
    // 커스텀 네비게이션바 생성
    PCLoginNaviView *viewNavi = [[PCLoginNaviView alloc] initWithType:LoginNaviBarTypePreve ViewController:self target:self action:@selector(onTouchUpToNextPage:)];
    
    sLog([viewNavi class]);
    
    [self.navigationController setNavigationBarHidden:YES];
    [self preferredStatusBarStyle];
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

#pragma mark - Login Delegate Method
- (void)didSignInWithFacebook:(BOOL)isSuccess {
    
}

- (void)didSignInWithEmail:(BOOL)isSuccess {
    
}

- (IBAction)TappedSignInButton:(id)sender {
    
    [[PCLoginManager loginManager] signInWithID:_idTextField.text andPassword:_pwTextField.text];
}

#pragma mark - Segue Configure Method
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    return YES;
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

@end
