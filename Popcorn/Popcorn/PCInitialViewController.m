//
//  ViewController.m
//  Popcorn
//
//  Created by giftbot on 2016. 11. 27..
//  Copyright © 2016년 giftbot. All rights reserved.
//

#import "PCInitialViewController.h"
#import "PCMainViewController.h"

@interface PCInitialViewController ()

@end

@implementation PCInitialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self makeNavigationView];
}

- (void)makeNavigationView{

    // 네비게이션바 관련
    [self.navigationController setNavigationBarHidden:YES];
    [self preferredStatusBarStyle];

}


- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)didSignUpWithFaceBook:(BOOL)isSuccess {
    
}

- (void)dealloc {
    dLog(@" ");
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:@"guestSegue"]) {
    }
    return YES;
}

@end
