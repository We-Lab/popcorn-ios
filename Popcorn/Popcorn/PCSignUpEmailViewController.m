//
//  PCSignUpViewController.m
//  Popcorn
//
//  Created by giftbot on 2016. 11. 27..
//  Copyright © 2016년 giftbot. All rights reserved.
//

#import "PCSignUpEmailViewController.h"
#import "PCLoginNaviView.h"

@interface PCSignUpEmailViewController ()
@end

@implementation PCSignUpEmailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 커스텀 네비게이션바 생성
    PCLoginNaviView *viewNavi = [[PCLoginNaviView alloc] initWithType:LoginNaviBarTypePreve ViewController:self target:self action:@selector(onTouchUpToNextPage:)];
    
    // 네비게이션 바 숨김
    [self.navigationController setNavigationBarHidden:YES];
    
    // 스테이터스 바 스타일
    [self preferredStatusBarStyle];
    self.edgesForExtendedLayout=UIRectEdgeTop;
    self.automaticallyAdjustsScrollViewInsets=NO;
}

// 스테이터스 바 스타일 메소드
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

// 네비게이션 Pop
- (void)onTouchUpToNextPage:(UIButton *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Verify UserInfo
- (BOOL) isValidEmail:(NSString *)checkString {
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:checkString];
}

- (BOOL)isValidNickName {
    BOOL isValid = YES;
    //2자 이상 8자 이내,  영문/숫자/한글만 가능
    
    return isValid;
}

- (NSUInteger)isValidPassword {
    // 가능 여부 및 보안레벨 반환하기
    return 0;
}

- (BOOL)isValidBirthday {
    BOOL isValid = YES;
    //8살 이상 120살 이하
    
    return isValid;
}


#pragma mark - LoginManager Delegate
- (void)didSignUpWithEmail:(PCSignUpResult)result {
    
}

@end
