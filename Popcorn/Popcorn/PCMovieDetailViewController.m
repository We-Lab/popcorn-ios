//
//  PCMovieDetailViewController.m
//  Popcorn
//
//  Created by giftbot on 2016. 11. 29..
//  Copyright © 2016년 giftbot. All rights reserved.
//

#import "PCMovieDetailViewController.h"

@interface PCMovieDetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *movieMainImage;
@property (weak, nonatomic) IBOutlet UIImageView *moviePosterImage;

@property (weak, nonatomic) IBOutlet UIView *moviePosterView;

@property (weak, nonatomic) IBOutlet UIView *movieInfoButtonView;
@property (weak, nonatomic) IBOutlet UILabel *movieStoryLabel;
@property (weak, nonatomic) IBOutlet UITableView *movieVideoTableView;

@end

@implementation PCMovieDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setCustomViewStatus];
}

#pragma mark - Make Custem View
- (void)setCustomViewStatus{

    self.moviePosterView.layer.masksToBounds = NO;
    self.moviePosterView.layer.shadowOffset = CGSizeMake(0, 1);
    self.moviePosterView.layer.shadowRadius = 2;
    self.moviePosterView.layer.shadowOpacity = 0.3;
    
    self.movieInfoButtonView.layer.borderWidth = 1;
    self.movieInfoButtonView.layer.borderColor = [UIColor colorWithRed:225.f/255.f green:225.f/255.f blue:225.f/255.f alpha:1].CGColor;
    
    self.movieVideoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

}

#pragma mark - CollectionView Required
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 7;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *moviePhotoCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MoviePhotoCell" forIndexPath:indexPath];
    
    return moviePhotoCell;
}

#pragma mark - TableView Required
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *movieVideoCell = [tableView dequeueReusableCellWithIdentifier:@"MovieVideoCell" forIndexPath:indexPath];
    
    if (movieVideoCell != nil) {
        
        movieVideoCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MovieVideoCell"];
    }
    
    return movieVideoCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 70;
}




- (void)dealloc {
    dLog(@" ");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
