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

@interface PCCommentViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *commentListTableView;

@end

@implementation PCCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setCustomViewStatus];
    
    self.commentListTableView.rowHeight = UITableViewAutomaticDimension;
    self.commentListTableView.estimatedRowHeight = 200;

}

#pragma mark - Make Custem View
- (void)setCustomViewStatus{
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:29.f/255.f green:140.f/255.f blue:249.f/255.f alpha:1];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
}

#pragma mark - TableView Required
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PCCommentCustomCell *commentCell = [tableView dequeueReusableCellWithIdentifier:@"CommnetCell" forIndexPath:indexPath];
    
    if (!commentCell) {
        
        commentCell = [[PCCommentCustomCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CommnetCell"];
    }
    
    if (indexPath.row == 2) {
        commentCell.commentText.text = @"우아아아아아아아아아아앙아아아아아아아아아아아앙아아아아아아아아아아아앙아아아아아아아아아아아앙아아아아아아아아아아아앙아END";
    }
    
    HCSStarRatingView *starRatingView = [[HCSStarRatingView alloc] init];
    starRatingView.frame = CGRectMake(0, 0, 120, commentCell.commentStarRatingView.frame.size.height);
    starRatingView.maximumValue = 5;
    starRatingView.minimumValue = 0;
    starRatingView.value = 3.5;
    starRatingView.backgroundColor = [UIColor clearColor];
    starRatingView.allowsHalfStars = YES;
    starRatingView.emptyStarImage = [UIImage imageNamed:@"EmptyStar"];
    starRatingView.filledStarImage = [UIImage imageNamed:@"FullStar"];
    starRatingView.userInteractionEnabled = NO;
    [commentCell.commentStarRatingView addSubview:starRatingView];

    return  commentCell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    dLog(@" ");
}

@end
