//
//  PCRequesPWViewController.m
//  Popcorn
//
//  Created by giftbot on 2016. 11. 28..
//  Copyright © 2016년 giftbot. All rights reserved.
//

#import "PCRequesPWViewController.h"
#import "PCLoginNaviView.h"

@interface PCRequesPWViewController ()

@end

@implementation PCRequesPWViewController

#pragma mark - Init
- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeNavigationView];
}


#pragma mark - Make Custom NavigationBar
- (void)makeNavigationView {
    [self.navigationController setNavigationBarHidden:YES];
    
    PCLoginNaviView *viewNavi = [[PCLoginNaviView alloc] initWithType:LoginNaviBarTypePreve andViewController:self];
    [viewNavi.prevButton addTarget:self action:@selector(onTouchUpToNextPage:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)onTouchUpToNextPage:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didSendPasswordToEmail:(BOOL)isSuccess {
    
}


#pragma mark -
- (void)dealloc {
    dLog(@" ");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
