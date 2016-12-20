//
//  PCActorViewController.m
//  Popcorn
//
//  Created by giftbot on 2016. 11. 29..
//  Copyright © 2016년 giftbot. All rights reserved.
//

#import "PCActorViewController.h"
#import "PCMovieDetailDataCenter.h"
#import <UIImageView+WebCache.h>

@interface PCActorViewController ()

@property PCMovieDetailDataCenter *movieDataCenter;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollContentsViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *directorViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *actorContentsViewHeight;
@property (weak, nonatomic) IBOutlet UIView *actorListView;
@property (weak, nonatomic) IBOutlet UIView *directerListView;

@end

@implementation PCActorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.movieDataCenter = [PCMovieDetailDataCenter sharedMovieDetailData];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self creatActorList];
}


#pragma mark - Actor List View
- (void)creatActorList {
    
    CGFloat baseMargin = [self ratioHeight:15];
    CGFloat baseMovieContentWidth = (self.view.frame.size.width - [self ratioWidth:24])/3;
    CGFloat baseMovieContentHeight = [self ratioHeight:130];
    
    for (NSInteger j = 0; j < [_movieDataCenter creatMovieDirectorName].count; j += 1) {
        
        UIView *directerView = [[UIView alloc] init];
        directerView.tag = j;
        NSInteger row = directerView.tag%3;
        directerView.frame = CGRectMake(baseMovieContentWidth * row,0,
                                        baseMovieContentWidth,baseMovieContentHeight);
        
        [self.directerListView addSubview:directerView];
        
        UIImageView *directerImage = [[UIImageView alloc] init];
        
        directerImage.frame = CGRectMake(directerView.frame.size.width/2 - [self ratioWidth:35], 0, [self ratioWidth:70], [self ratioHeight:70]);
        directerImage.layer.cornerRadius = [self ratioWidth:35];
        [directerImage sd_setImageWithURL:[_movieDataCenter creatMovieDirectorImage][j]];
        directerImage.contentMode = UIViewContentModeScaleAspectFill;
        directerImage.clipsToBounds = YES;
        
        [directerView addSubview:directerImage];
        
        UILabel *directerName = [[UILabel alloc] init];
        
        directerName.frame = CGRectMake(0, [self ratioHeight:80], directerView.frame.size.width, [self ratioHeight:20]);
        directerName.text = [_movieDataCenter creatMovieDirectorName][j];
        directerName.font = [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold];
        directerName.textColor = [UIColor colorWithRed:51.f/255.f green:51.f/255.f blue:51.f/255.f alpha:1];
        directerName.textAlignment = NSTextAlignmentCenter;
        
        [directerView addSubview:directerName];
    }
    
    for (NSInteger i = 0; i < [_movieDataCenter creatMovieActorName].count; i += 1) {
        
        UIView *actorView = [[UIView alloc] init];
        actorView.tag = i;
        NSInteger row = actorView.tag%3;
        NSInteger cal = actorView.tag/3;
        actorView.frame = CGRectMake(baseMovieContentWidth * row,(baseMovieContentHeight+baseMargin)*cal,
                                     baseMovieContentWidth,baseMovieContentHeight);
        
        [self.actorListView addSubview:actorView];
        
        UIImageView *actorImage = [[UIImageView alloc] init];
        
        actorImage.frame = CGRectMake(actorView.frame.size.width/2 - [self ratioWidth:35], 0, [self ratioWidth:70], [self ratioHeight:70]);
        actorImage.layer.cornerRadius = [self ratioWidth:35];
        [actorImage sd_setImageWithURL:[_movieDataCenter creatMovieActorImage][i]];
        actorImage.contentMode = UIViewContentModeScaleAspectFill;
        actorImage.clipsToBounds = YES;
        actorImage.backgroundColor = [UIColor grayColor];
        
        [actorView addSubview:actorImage];
        
        UILabel *actorName = [[UILabel alloc] init];
        
        actorName.frame = CGRectMake(0, [self ratioHeight:80], actorView.frame.size.width, [self ratioHeight:20]);
        actorName.text = [_movieDataCenter creatMovieActorName][i];
        actorName.font = [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold];
        actorName.textColor = [UIColor colorWithRed:51.f/255.f green:51.f/255.f blue:51.f/255.f alpha:1];
        actorName.textAlignment = NSTextAlignmentCenter;
        
        [actorView addSubview:actorName];
        
        UILabel *actorMovieName = [[UILabel alloc] init];
        
        actorMovieName.frame = CGRectMake(0, [self ratioHeight:100], actorView.frame.size.width, [self ratioHeight:20]);
        actorMovieName.font = [UIFont systemFontOfSize:12];
        actorMovieName.textColor = [UIColor colorWithRed:102.f/255.f green:102.f/255.f blue:102.f/255.f alpha:1];
        actorMovieName.textAlignment = NSTextAlignmentCenter;
        actorMovieName.text = [_movieDataCenter creatMovieActorMovieName][i];
        
        [actorView addSubview:actorMovieName];
    }
    self.actorContentsViewHeight.constant = [self ratioHeight:47] + (baseMovieContentHeight+baseMargin)*([_movieDataCenter creatMovieActorName].count/3+1);
    self.scrollContentsViewHeight.constant = self.directorViewHeight.constant + self.viewMargin.constant + self.actorContentsViewHeight.constant;
}

#pragma mark - Custom Method
- (CGFloat)ratioWidth:(NSInteger)num{
    return (num * self.view.frame.size.width) / 375;
}

- (CGFloat)ratioHeight:(NSInteger)num{
    return (num * self.view.frame.size.height) / 667;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    dLog(@" ");
}

@end
