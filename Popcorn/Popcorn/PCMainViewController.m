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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self removeLoginViewControllers];
    
    // inititalView as Search
//    self.selectedIndex = 1;
}

- (void)removeLoginViewControllers {
    NSMutableArray *viewControllers = [[self.navigationController viewControllers] mutableCopy];
    NSMutableArray *prevControllers = [@[] mutableCopy];
    for (UIViewController *controller in viewControllers) {
        if (controller == self)
            continue;
        [prevControllers addObject:controller];
    }
    
    for (UIViewController *vc in prevControllers)
        [viewControllers removeObject:vc];
    
    [self.navigationController setViewControllers:viewControllers];
}



@end
