//
//  PCCommentViewController.m
//  Popcorn
//
//  Created by giftbot on 2016. 11. 29..
//  Copyright © 2016년 giftbot. All rights reserved.
//

#import "PCCommentViewController.h"
#import "PCCommentCustomCell.h"
#import <HCSStarRatingView.h>
#import "PCMovieDetailDataCenter.h"

@interface PCCommentViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *commentListTableView;
@property PCMovieDetailDataCenter *movieDataCenter;

@end

@implementation PCCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.movieDataCenter = [PCMovieDetailDataCenter sharedMovieDetailData];
    
    self.commentListTableView.rowHeight = UITableViewAutomaticDimension;
    self.commentListTableView.estimatedRowHeight = 200;
    
    self.navigationItem.leftBarButtonItem.accessibilityFrame = CGRectMake(0, 0, 30, 50);

}

#pragma mark - TableView Required
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.movieDataCenter.movieDetailBestCommentList.count == 0) {
        return 1;
    }else{
        return self.movieDataCenter.movieDetailBestCommentList.count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PCCommentCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommnetCell" forIndexPath:indexPath];
    
    HCSStarRatingView *starRatingView = [[HCSStarRatingView alloc] init];
    starRatingView.frame = CGRectMake(0, 0, 120, cell.commentStarRatingView.frame.size.height);
    starRatingView.maximumValue = 5;
    starRatingView.minimumValue = 0;
    starRatingView.backgroundColor = [UIColor clearColor];
    starRatingView.allowsHalfStars = YES;
    starRatingView.emptyStarImage = [UIImage imageNamed:@"EmptyStar"];
    starRatingView.filledStarImage = [UIImage imageNamed:@"FullStar"];
    starRatingView.userInteractionEnabled = NO;
    [cell.commentStarRatingView addSubview:starRatingView];
    
    cell.commentUserID.text = [self.movieDataCenter creatBestCommentUserID][indexPath.row];
    starRatingView.value = [[self.movieDataCenter creatBestCommentUserStar][indexPath.row] floatValue];
    cell.commentText.text = [self.movieDataCenter creatBestCommentUserText][indexPath.row];
    cell.commentLikeText.text = [NSString stringWithFormat:@"%@ 명이 좋아합니다.", [self.movieDataCenter creatBestCommentLikeCount][indexPath.row]];
    NSString *commentDate =[[self.movieDataCenter creatBestCommentWriteDate][indexPath.row] substringWithRange:NSMakeRange(0, 10)];
    cell.commentWriteDate.text = commentDate;

    return  cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    dLog(@" ");
}

@end
