//
//  PCMainViewController.m
//  Popcorn
//
//  Created by giftbot on 2016. 11. 27..
//  Copyright © 2016년 giftbot. All rights reserved.
//

#import "PCMainViewController.h"

@interface PCMainViewController ()

@end

@implementation PCMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
//    if (![appDelegate.window.rootViewController isKindOfClass:[self class]]){
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        appDelegate.window.rootViewController = [storyboard instantiateInitialViewController];
//    }
    
//    UIWindow *window = (UIWindow *)[[[UIApplication sharedApplication] windows] firstObject];
//    if ( ![window.rootViewController isKindOfClass:[self class]] ) {
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        window.rootViewController = storyboard.instantiateInitialViewController;
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    dLog(@" ");
}

@end
