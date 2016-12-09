//
//  PCRankingDetailViewController.m
//  Popcorn
//
//  Created by giftbot on 2016. 12. 7..
//  Copyright © 2016년 giftbot. All rights reserved.
//

#import "PCRankingDetailViewController.h"
#import "PCMovieInfoManager.h"

@interface PCRankingDetailViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *rankingTableView;
@property (nonatomic) NSArray *movieRankingList;
@end


@implementation PCRankingDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MovieNetworkingHandler completionHandler = ^(BOOL isSuccess, NSArray *movieListData){
        if (isSuccess)
            [self didReceiveRankingList:movieListData];
        else
            alertLog(@"영화정보를 가져오는 데 실패하였습니다.");
    };
    
    [[PCMovieInfoManager movieManager] requestRankingList:BoxOfficeRankingDetailList withCompletionHandler:completionHandler];
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationItem.title = self.titleString;
}

- (void)didReceiveRankingList:(NSArray *)rankingList {
    sLog(rankingList);
    self.movieRankingList = rankingList;
    [self.rankingTableView reloadData];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _movieRankingList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 120;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RankingDetailCell" forIndexPath:indexPath];
    
//    cell.textLabel.text = _movieRankingList[indexPath.row][@"movie_title"];
//    cell.imageView.image = _movieRankingList[0][@"photo1"];
    
    return cell;
}

- (void)dealloc {
    dLog(@" ");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
