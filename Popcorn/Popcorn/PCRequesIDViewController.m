//
//  PCRequesIDViewController.m
//  Popcorn
//
//  Created by chaving on 2016. 11. 29..
//  Copyright © 2016년 giftbot. All rights reserved.
//

#import "PCRequesIDViewController.h"
#import "PCLoginNaviView.h"

@interface PCRequesIDViewController ()

@end

@implementation PCRequesIDViewController

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
}

// 스테이터스 바 스타일 메소드
- (UIStatusBarStyle)preferredStatusBarStyle {
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
