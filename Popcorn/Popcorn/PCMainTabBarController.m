//
//  PCMainViewController.m
//  Popcorn
//
//  Created by giftbot on 2016. 11. 27..
//  Copyright © 2016년 giftbot. All rights reserved.
//

#import "PCMainTabBarController.h"

@interface PCMainTabBarController ()

@end

@implementation PCMainTabBarController

#pragma mark - Init
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self removeLoginViewControllers];
    
//    initial View
//    self.selectedIndex = 1;
    
//    [[UITabBar appearance] setShadowImage:[UIImage new]];
//    [self.tabBar setValue:@(YES) forKeyPath:@"_hidesShadow"];
//    self.navigationController.toolbar.clipsToBounds = YES;
}


#pragma mark - removeLoginViewControllers
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




#pragma mark - 
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    sLog(@" ");
}


@end
