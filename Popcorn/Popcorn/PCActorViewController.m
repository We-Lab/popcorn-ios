//
//  PCActorViewController.m
//  Popcorn
//
//  Created by giftbot on 2016. 11. 29..
//  Copyright © 2016년 giftbot. All rights reserved.
//

#import "PCActorViewController.h"

@interface PCActorViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollContentsViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *directorViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *actorContentsViewHeight;
@property (weak, nonatomic) IBOutlet UIView *actorListView;

@end

@implementation PCActorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatActorList];
}

#pragma mark - Actor List View
- (void)creatActorList {

    for (NSInteger i = 0; i < 22; i += 1) {
        
        CGFloat baseMargin = [self ratioHeight:25];
        CGFloat baseMovieContentWidth = self.actorListView.frame.size.width/3;
        CGFloat baseMovieContentHeight = [self ratioHeight:125];
        
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
        actorImage.backgroundColor = [UIColor colorWithRed:29.f/255.f green:140.f/255.f blue:249.f/255.f alpha:1];
        
        [actorView addSubview:actorImage];
        
        UILabel *actorName = [[UILabel alloc] init];
        
        actorName.frame = CGRectMake(0, [self ratioHeight:85], actorView.frame.size.width, [self ratioHeight:20]);
        actorName.text = [NSString stringWithFormat:@"배우이름 %ld",i];
        actorName.font = [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold];
        actorName.textColor = [UIColor colorWithRed:51.f/255.f green:51.f/255.f blue:51.f/255.f alpha:1];
        actorName.textAlignment = NSTextAlignmentCenter;
        
        [actorView addSubview:actorName];
        
        UILabel *actorMovieName = [[UILabel alloc] init];
        
        actorMovieName.frame = CGRectMake(0, [self ratioHeight:105], actorView.frame.size.width, [self ratioHeight:20]);
        actorMovieName.text = [NSString stringWithFormat:@"배역이름 %ld",i];
        actorMovieName.font = [UIFont systemFontOfSize:13];
        actorMovieName.textColor = [UIColor colorWithRed:128.f/255.f green:128.f/255.f blue:128.f/255.f alpha:1];
        actorMovieName.textAlignment = NSTextAlignmentCenter;
        
        [actorView addSubview:actorMovieName];
        
        
        self.actorContentsViewHeight.constant = [self ratioHeight:47] + (baseMovieContentHeight+baseMargin)*(22/3+1);
        self.scrollContentsViewHeight.constant = self.directorViewHeight.constant + self.viewMargin.constant + self.actorContentsViewHeight.constant;
    }
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
