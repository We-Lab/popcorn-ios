//
//  PCRankingDetailViewController.m
//  Popcorn
//
//  Created by giftbot on 2016. 12. 7..
//  Copyright © 2016년 giftbot. All rights reserved.
//

#import "PCRankingDetailViewController.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import "PCRankingDetailTableViewCell.h"

@interface PCRankingDetailViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *rankingTableView;
@property (nonatomic) NSArray *movieRankingList;

@end


@implementation PCRankingDetailViewController

#pragma mark - Init
- (void)viewWillAppear:(BOOL)animated {
    NSString *titleString;
    switch (_rankingType) {
        case BoxOfficeRankingDetailList:
            titleString = @"박스오피스 랭킹";
            break;
        case RatingRankingDetailList:
            titleString = @"평점순 랭킹";
            break;
        case LikeRankingDetailList:
            titleString = @"좋아요순 랭킹";
            break;
    }
    self.navigationItem.title = titleString;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self requestRankingList];
}

- (void)requestRankingList {
    NetworkTaskHandler completionHandler = ^(BOOL isSuccess, NSArray *resultArray){
        if (isSuccess)
            [self didReceiveRankingList:resultArray];
        else
            alertLog(@"영화정보를 가져오는 데 실패하였습니다.");
    };
    
    [[PCMovieInfoManager movieManager] requestRankingList:_rankingType withCompletionHandler:completionHandler];
}

- (void)didReceiveRankingList:(NSArray *)rankingList {
    self.movieRankingList = rankingList;
    [self.rankingTableView reloadData];
}



#pragma mark - Configure TableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _movieRankingList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PCRankingDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RankingDetailCell" forIndexPath:indexPath];
    
    NSDictionary *movieData = _movieRankingList[indexPath.row];
    
    if (_rankingType == BoxOfficeRankingDetailList) {
        cell.movieTitleLabel.text = movieData[@"movie_title"];
        cell.movieRatingLabel.text = [NSString stringWithFormat:@"평점 %@점", movieData[@"movie"][@"star_average"]];
        cell.movieInfoLabel.text = movieData[@"release_date"];
        [cell.movieImageView sd_setImageWithURL:movieData[@"movie"][@"img_url"] placeholderImage:[UIImage imageNamed:@"test1.jpg"]];
    }
    else {
        cell.movieTitleLabel.text = movieData[@"title_kor"];
        cell.movieRatingLabel.text = [NSString stringWithFormat:@"평점 %@점 좋아요 %@개", movieData[@"star_average"], movieData[@"likes_count"]];
        cell.movieInfoLabel.text = [NSString stringWithFormat:@"%@", movieData[@"created_year"]];
        [cell.movieImageView sd_setImageWithURL:movieData[@"img_url"] placeholderImage:[UIImage imageNamed:@"test1.jpg"]];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
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
