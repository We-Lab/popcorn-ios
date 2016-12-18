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
@property (weak, nonatomic) IBOutlet UIButton *SignUpWithEmailButton;

@end

@implementation PCInitialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES];
//    [_SignUpWithEmailButton sendActionsForControlEvents:UIControlEventTouchUpInside];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
#ifndef DEBUG
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"PCInitialViewController"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
#endif
}


#pragma mark -
- (void)dealloc {
    dLog(@" ");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
