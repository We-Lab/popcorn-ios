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
@property (nonatomic) NSDictionary *rankingDictionaryList;
@property (nonatomic) NSArray *rankingArrayList;

@property (nonatomic) UIActivityIndicatorView *activityIndicator;

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
        if (isSuccess) {
            if (_rankingType == BoxOfficeRankingDetailList) {
                [self didReceiveRankingArrayList:resultArray];
            }
            else {
                [self didReceiveRankingDictionaryList:(NSDictionary *)resultArray];
            }
        }
        else {
            alertLog(@"영화정보를 가져오는 데 실패하였습니다.");
        }
    };
    
    [[PCMovieInfoManager movieManager] requestRankingList:_rankingType withCompletionHandler:completionHandler];
}

- (void)didReceiveRankingDictionaryList:(NSDictionary *)rankingList {
    self.rankingDictionaryList = rankingList;
    [self.rankingTableView reloadData];
}

- (void)didReceiveRankingArrayList:(NSArray *)rankingList {
    self.rankingArrayList = rankingList;
    [self.rankingTableView reloadData];
}

#pragma mark - Configure TableView
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PCRankingDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RankingDetailCell" forIndexPath:indexPath];
    
    NSDictionary *movieData;
    
    if (_rankingType == BoxOfficeRankingDetailList) {
        movieData = _rankingArrayList[indexPath.row];
        cell.movieTitleLabel.text = movieData[@"movie_title"];
        cell.movieInfoLabel.text = [NSString stringWithFormat:@"개봉일 %@", movieData[@"release_date"]];
        movieData = movieData[@"movie"];
    }
    else {
        movieData = _rankingDictionaryList[@"results"][indexPath.row];
        cell.movieTitleLabel.text = movieData[@"title_kor"];
        cell.movieInfoLabel.text = [NSString stringWithFormat:@"%@", movieData[@"created_year"]];
    }
    
    [cell.movieImageView sd_setImageWithURL:movieData[@"img_url"] placeholderImage:[UIImage imageNamed:@"MoviePlaceholder"]];
    
    // 평점 텍스트 중간에 별 이미지 삽입
    NSTextAttachment *attachmentStarImage = [[NSTextAttachment alloc] init];
    UIImage *starImage = [UIImage imageNamed:@"FullStar"];
    attachmentStarImage.image = [PCCommonUtility resizeImage:starImage scaledToSize:CGSizeMake(10, 10) andAlpha:1.0];
    
    // 텍스트 조합
    NSMutableAttributedString *leftString= [[NSMutableAttributedString alloc] initWithString:@"평점 "];
    NSAttributedString *starImageString = [NSAttributedString attributedStringWithAttachment:attachmentStarImage];
    
    NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
    [fmt setPositiveFormat:@"0.#"];
    NSAttributedString *rightString = [[NSAttributedString alloc] initWithString:[fmt stringFromNumber:movieData[@"star_average"]]];
    [leftString appendAttributedString:starImageString];
    [leftString appendAttributedString:rightString];
    
    if (_rankingType == LikeRankingDetailList) {
        NSTextAttachment *attachmentLikeImage = [[NSTextAttachment alloc] init];
        UIImage *likeImage = [UIImage imageNamed:@"Heart"];
        attachmentLikeImage.image = [PCCommonUtility resizeImage:likeImage scaledToSize:CGSizeMake(11, 11) andAlpha:1.0];
        
        NSAttributedString *addString= [[NSAttributedString alloc] initWithString:@"  좋아요 "];
        NSAttributedString *likeImageString = [NSAttributedString attributedStringWithAttachment:attachmentLikeImage];
        NSString *likeAverageString = [NSString stringWithFormat:@" %@", movieData[@"likes_count"]];
        NSAttributedString *addLikeNumString = [[NSAttributedString alloc] initWithString:likeAverageString];
        
        [leftString appendAttributedString:addString];
        [leftString appendAttributedString:likeImageString];
        [leftString appendAttributedString:addLikeNumString];
    }
    
    cell.movieRatingLabel.attributedText = leftString;
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_rankingType == BoxOfficeRankingDetailList)
        return _rankingArrayList.count;
    else
        return [_rankingDictionaryList[@"results"] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
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
