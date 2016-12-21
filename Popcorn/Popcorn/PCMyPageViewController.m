//
//  PCMyPageViewController.m
//  Popcorn
//
//  Created by giftbot on 2016. 11. 27..
//  Copyright © 2016년 giftbot. All rights reserved.
//

#import "PCMyPageViewController.h"

#import "PCUserInformation.h"
#import "PCUserInfoManager.h"

@interface PCMyPageViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *myPageMainTableView;
@property (weak, nonatomic) IBOutlet UIView *tableViewHeaderButtonView;
@property (weak, nonatomic) IBOutlet UIImageView *userProfileImageView;

@property (weak, nonatomic) IBOutlet UILabel *myPageUserID;

@property (nonatomic) UIButton *myPageButton;
@property (nonatomic) NSInteger selectButton;
@property (nonatomic) UIView *buttonUnderLine;

@property (nonatomic) NSArray *myCommentList;
@property (nonatomic) NSArray *myFamousList;
@property (nonatomic) NSArray *myLikeList;

@end

@implementation PCMyPageViewController

#pragma mark - Init
- (instancetype)init {
    self = [super init];
    if (self) {
        self.selectButton = 0;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.myPageMainTableView.rowHeight = UITableViewAutomaticDimension;
    self.myPageMainTableView.estimatedRowHeight = 150;
    self.userProfileImageView.image = [[PCUserInformation sharedUserData] getUserProfileImage];
    
    [self makeTableViewHeader];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self requestUserInteractionData];
    
#ifndef DEBUG
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:NSStringFromClass([self class])];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
#endif
}

- (void)requestUserInteractionData {
    [[PCUserInfoManager userInfoManager] requestUserCommentListWithCompletionHandler:^(BOOL isSuccess, NSDictionary *resultDictionary) {
        if (isSuccess)
            [self didReceiveUserInteractionData:resultDictionary andIndex:0];
        else
            alertLog(@"코멘트 정보를 가져오는 데 실패하였습니다.");
    }];
    [[PCUserInfoManager userInfoManager] requestUserFamousListWithCompletionHandler:^(BOOL isSuccess, NSDictionary *resultDictionary) {
        if (isSuccess)
            [self didReceiveUserInteractionData:resultDictionary andIndex:1];
        else
            alertLog(@"명대사 정보를 가져오는 데 실패하였습니다.");
    }];
    [[PCUserInfoManager userInfoManager] requestUserLikeMovieListWithCompletionHandler:^(BOOL isSuccess, NSDictionary *resultDictionary) {
        if (isSuccess)
            [self didReceiveUserInteractionData:resultDictionary andIndex:2];
        else
            alertLog(@"좋아요 정보를 가져오는 데 실패하였습니다.");
    }];
}

- (void)didReceiveUserInteractionData:(NSDictionary *)userData andIndex:(NSUInteger)index {
    if (index == 0) {
        self.myCommentList = userData[@"results"];
    }
    else if (index == 1) {
        self.myFamousList = userData[@"results"];
    }
    else if (index == 2) {
        self.myLikeList = userData[@"results"];
    }
}


#pragma mark - Make TableView Header
- (void)makeTableViewHeader{
    
    CGFloat baseMovieContentWidth = self.view.frame.size.width/3;
    CGFloat baseMovieContentHeight = [self ratioHeight:42];
    
    self.buttonUnderLine = [[UIView alloc] init];
    self.buttonUnderLine.frame = CGRectMake(0, baseMovieContentHeight, baseMovieContentWidth, [self ratioHeight:3]);
    self.buttonUnderLine.backgroundColor = [UIColor darkGrayColor];
    [self.tableViewHeaderButtonView addSubview:self.buttonUnderLine];
    
    [PCCommonUtility makeTextShadow:self.myPageUserID opacity:0.8];
}

#pragma mark - TableView Required
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.selectButton == 0) {
        return _myCommentList.count;
    }
    else if (self.selectButton == 1) {
        return _myFamousList.count;
    }
    else if (self.selectButton == 2) {
        return _myLikeList.count;
    }
    
    [_myPageMainTableView reloadData];
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *textCell = @[@"MyCommentCell", @"MyFamousLineCell", @"MyLikeMovieCell"];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:textCell[self.selectButton] forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:textCell[self.selectButton]];
    }
    return cell;
}

- (IBAction)reloadSection:(UIButton *)sender {

    if (self.selectButton != sender.tag) {
        if (self.selectButton > sender.tag) {
            self.selectButton = sender.tag;
            
            [UIView animateWithDuration:0.3 animations:^{
                self.buttonUnderLine.frame = CGRectMake((self.view.frame.size.width/3 * sender.tag), [self ratioHeight:42], self.view.frame.size.width/3, [self ratioHeight:3]);
            }];
            
            [self.myPageMainTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationLeft];
            
        }
        else if (self.selectButton < sender.tag) {
            self.selectButton = sender.tag;
            [UIView animateWithDuration:0.3 animations:^{
                self.buttonUnderLine.frame = CGRectMake((self.view.frame.size.width/3 * sender.tag), [self ratioHeight:42], self.view.frame.size.width/3, [self ratioHeight:3]);
            }];
            
            [self.myPageMainTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationRight];
        }
    }
}



#pragma mark - Custom Method
- (CGFloat)ratioWidth:(NSInteger)num{
    return (num * self.view.frame.size.width) / 375;
}

- (CGFloat)ratioHeight:(NSInteger)num{
    return (num * self.view.frame.size.height) / 667;
}

- (void)dealloc {
    dLog(@" ");
    [[NSUserDefaults standardUserDefaults] removeObserver:self forKeyPath:@"UserSignedIn"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
