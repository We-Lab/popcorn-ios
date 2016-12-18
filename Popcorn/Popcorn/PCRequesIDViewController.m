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

- (void)onTouchUpToNextPage:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dealloc {
    sLog(@" ");
}

@end
