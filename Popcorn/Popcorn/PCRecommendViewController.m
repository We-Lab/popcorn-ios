//
//  PCRecommendViewController.m
//  Popcorn
//
//  Created by giftbot on 2016. 11. 27..
//  Copyright © 2016년 giftbot. All rights reserved.
//

#import "PCRecommendViewController.h"

@interface PCRecommendViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *recommendTableView;
@property (weak, nonatomic) IBOutlet UIButton *toTagViewButton;
@end

@implementation PCRecommendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_toTagViewButton sendActionsForControlEvents:UIControlEventTouchUpInside];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
#ifndef DEBUG
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:NSStringFromClass([self class])];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
#endif
}


#pragma mark - Configure TableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning should be change
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecommendCell" forIndexPath:indexPath];
    cell.textLabel.text = @"테스트";
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] init];
    headerView.bounds = CGRectMake(0, 0, tableView.frame.size.width, tableView.sectionHeaderHeight);
    headerView.backgroundColor = [UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:0.5];
    
    UILabel *headerLabel = [[UILabel alloc] init];
    headerLabel.frame = CGRectMake(0, 0, headerView.frame.size.width, headerView.frame.size.height);
    headerLabel.text = @"취향에 맞는 태그를 선택해보세요";
    headerLabel.font = [UIFont boldSystemFontOfSize:14.8f];
    headerLabel.textAlignment = NSTextAlignmentCenter;
    headerLabel.textColor = [UIColor colorWithRed:0.65 green:0.65 blue:0.65 alpha:1.0];
    [headerView addSubview:headerLabel];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 5;
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
