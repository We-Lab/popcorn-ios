//
//  PCSignInViewController.m
//  Popcorn
//
//  Created by giftbot on 2016. 11. 27..
//  Copyright © 2016년 giftbot. All rights reserved.
//

#import "PCSignInViewController.h"

@interface PCSignInViewController ()

@end

@implementation PCSignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 네비게이션 바 숨김
    [self.navigationController setNavigationBarHidden:YES];
    
    // 스테이터스 바 스타일
    [self preferredStatusBarStyle];
//    self.preferredStatusBarStyle = UIStatusBarStyleLightContent;
    self.edgesForExtendedLayout=UIRectEdgeTop;
    self.automaticallyAdjustsScrollViewInsets=NO;
}

// 스테이터스 바 스타일 메소드
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didSignInWithFacebook:(BOOL)isSuccess {
    
}

- (void)didSignInWithEmail:(BOOL)isSuccess {
    
}

@end
