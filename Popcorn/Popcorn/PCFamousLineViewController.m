//
//  PCFamousLineViewController.m
//  Popcorn
//
//  Created by giftbot on 2016. 11. 29..
//  Copyright © 2016년 giftbot. All rights reserved.
//

#import "PCFamousLineViewController.h"
#import "PCFamousLineCustomCell.h"
#import "PCMovieDetailDataCenter.h"

@interface PCFamousLineViewController ()
@property (weak, nonatomic) IBOutlet UITableView *famousLineListTableView;
@property PCMovieDetailDataCenter *movieDataCenter;
@end

@implementation PCFamousLineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.movieDataCenter = [PCMovieDetailDataCenter sharedMovieDetailData];
    
    self.navigationController.navigationBar.translucent = YES;
    self.famousLineListTableView.rowHeight = UITableViewAutomaticDimension;
    self.famousLineListTableView.estimatedRowHeight = 200;
}


#pragma mark - TableView Required
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.movieDataCenter.movieDetailFamousLineList.count == 0) {
        return 1;
    }else{
        return self.movieDataCenter.movieDetailFamousLineList.count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PCFamousLineCustomCell *famousLineCell = [tableView dequeueReusableCellWithIdentifier:@"FamousLineCell" forIndexPath:indexPath];

    famousLineCell.famousLineUserID.text = [self.movieDataCenter creatFamousLineUserID][indexPath.row];
    famousLineCell.famousLineMovieName.text = [NSString stringWithFormat:@"%@ | %@",[self.movieDataCenter creatBestFamousLineActorName][indexPath.row],[self.movieDataCenter creatBestFamousLineMovieName][indexPath.row]];
    famousLineCell.famousLineText.text = [self.movieDataCenter creatFamousLineUserText][indexPath.row];
    famousLineCell.famousLineLikeText.text = [NSString stringWithFormat:@"%@ 명이 좋아합니다.", [self.movieDataCenter creatFamousLineLikeCount][indexPath.row]];
    NSString *commentDate =[[self.movieDataCenter creatFamousLineWriteDate][indexPath.row] substringWithRange:NSMakeRange(0, 10)];
    famousLineCell.famousLineWriteDate.text = commentDate;
    
    return  famousLineCell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    dLog(@" ");
}

@end
