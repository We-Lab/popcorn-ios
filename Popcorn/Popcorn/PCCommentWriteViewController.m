//
//  PCCommentWriteViewController.m
//  Popcorn
//
//  Created by chaving on 2016. 12. 14..
//  Copyright © 2016년 giftbot. All rights reserved.
//

#import "PCCommentWriteViewController.h"
#import <HCSStarRatingView.h>

@interface PCCommentWriteViewController () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *commentWriteStarRatingView;
@property (weak, nonatomic) IBOutlet UITextView *commentWriteTextView;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@end

@implementation PCCommentWriteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCustomViewStatus];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)setCustomViewStatus{

    self.commentWriteTextView.clearsOnInsertion = NO;
    [self.commentWriteTextView becomeFirstResponder];
    
    HCSStarRatingView *starRating = [[HCSStarRatingView alloc] init];
    starRating.frame = self.commentWriteStarRatingView.bounds;
    starRating.maximumValue = 5;
    starRating.minimumValue = 0;
    starRating.value = 0;
    starRating.backgroundColor = [UIColor clearColor];
    starRating.allowsHalfStars = YES;
    starRating.emptyStarImage = [UIImage imageNamed:@"EmptyStar"];
    starRating.filledStarImage = [UIImage imageNamed:@"FullStar"];
    [starRating addTarget:self action:@selector(didChangeValue:) forControlEvents:UIControlEventValueChanged];
    [self.commentWriteStarRatingView addSubview:starRating];
}

- (void)didChangeValue:(HCSStarRatingView *)sender {
    self.scoreLabel.text = [NSString stringWithFormat:@"%.1f 점", sender.value];
}

- (IBAction)cancelCommentWrite:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    dLog(@" ");
}


@end
