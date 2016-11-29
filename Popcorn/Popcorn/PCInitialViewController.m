//
//  ViewController.m
//  Popcorn
//
//  Created by giftbot on 2016. 11. 27..
//  Copyright © 2016년 giftbot. All rights reserved.
//

#import "PCInitialViewController.h"

@interface PCInitialViewController ()

@end

@implementation PCInitialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 네비게이션바 관련
    [self.navigationController setNavigationBarHidden:YES];
    [self preferredStatusBarStyle];
    self.edgesForExtendedLayout=UIRectEdgeTop;
    self.automaticallyAdjustsScrollViewInsets=NO;

}


- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didSignUpWithFaceBook:(BOOL)isSuccess {
    
}

@end
