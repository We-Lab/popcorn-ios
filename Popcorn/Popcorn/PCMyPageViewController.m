//
//  PCMyPageViewController.m
//  Popcorn
//
//  Created by giftbot on 2016. 11. 27..
//  Copyright © 2016년 giftbot. All rights reserved.
//

#import "PCMyPageViewController.h"
#import "PCUserInformation.h"

@interface PCMyPageViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *myPageMainTableView;
@property UIButton *myPageButton;

@end

@implementation PCMyPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self makeTableViewHeader];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
#ifndef DEBUG
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:NSStringFromClass([self class])];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
#endif
}

#pragma mark - Make TableView Header
- (void)makeTableViewHeader{

    UIView *myPageTableHeaderView = [[UIView alloc] init];
    
    myPageTableHeaderView.frame = CGRectMake(0, 0, self.view.frame.size.width, [self ratioHeight:245]);
    myPageTableHeaderView.backgroundColor = [UIColor whiteColor];
    
    self.myPageMainTableView.tableHeaderView = myPageTableHeaderView;
    
    UIImageView *userImageView = [[UIImageView alloc] init];
    
    userImageView.frame = CGRectMake(0, 0, self.view.frame.size.width, [self ratioHeight:200]);
    userImageView.backgroundColor = [UIColor grayColor];
    
    [myPageTableHeaderView addSubview:userImageView];
    
    UIView *myPageButtonView = [[UIView alloc] init];
    
    myPageButtonView.frame = CGRectMake(0, userImageView.frame.size.height, userImageView.frame.size.width, [self ratioHeight:45]);
    
    [myPageTableHeaderView addSubview:myPageButtonView];
    
    
    UILabel *userName = [[UILabel alloc] init];
    
    userName.frame = CGRectMake(12, userImageView.frame.size.height - [self ratioHeight:32], userImageView.frame.size.width -24, [self ratioHeight:20]);
    userName.text = @"유저 아이디?";
    userName.textColor = [UIColor whiteColor];
    userName.font = [UIFont systemFontOfSize:17 weight:UIFontWeightSemibold];
    
    [userImageView addSubview:userName];
    
    for (NSInteger i = 0; i < 3; i += 1) {
        
        CGFloat baseMovieContentWidth = myPageButtonView.frame.size.width/3;
        CGFloat baseMovieContentHeight = myPageButtonView.frame.size.height;
        
        UIView *myPageButtonLine = [[UIView alloc] init];

        myPageButtonLine.tag = i;
        NSInteger row = myPageButtonLine.tag;
        myPageButtonLine.frame = CGRectMake(baseMovieContentWidth * row,0,
                                            baseMovieContentWidth,baseMovieContentHeight);
        
        [myPageButtonView addSubview:myPageButtonLine];
        
        self.myPageButton = [[UIButton alloc] init];
        
        self.myPageButton.frame = CGRectMake(0, 0, myPageButtonLine.frame.size.width, [self ratioHeight:42]);
        self.myPageButton.backgroundColor = [UIColor whiteColor];
        self.myPageButton.tag = i;
        
        if (i == 0) {
            myPageButtonLine.backgroundColor = [UIColor  colorWithRed:51.f/255.f green:51.f/255.f blue:51.f/255.f alpha:1];
            [self.myPageButton setTitle:@"평가영화" forState:UIControlStateNormal];
        }else if (i == 1){
            
            [self.myPageButton setTitle:@"명대사" forState:UIControlStateNormal];
            
        }else if (i == 2){
            
            [self.myPageButton setTitle:@"좋아요" forState:UIControlStateNormal];
        }
        
        self.myPageButton.titleLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightSemibold];
        [self.myPageButton setTitleColor:[UIColor  colorWithRed:51.f/255.f green:51.f/255.f blue:51.f/255.f alpha:1] forState:UIControlStateNormal];
        
        [self.myPageButton addTarget:self action:@selector(setReloadSection:) forControlEvents:UIControlEventTouchUpInside];
        
        [myPageButtonLine addSubview:self.myPageButton];
    }
}

#pragma mark - TableView Required
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        UITableViewCell *myCommentCell = [tableView dequeueReusableCellWithIdentifier:@"MyCommentCell" forIndexPath:indexPath];
        
        if (!myCommentCell) {
            
            myCommentCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyCommentCell"];
        }
        
        return myCommentCell;
        
    }else if (indexPath.section == 1) {
        
        UITableViewCell *myFamousLineCell = [tableView dequeueReusableCellWithIdentifier:@"MyFamousLineCell" forIndexPath:indexPath];
        
        if (!myFamousLineCell) {
            
            myFamousLineCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyFamousLineCell"];
        }
        
        return myFamousLineCell;
    
    }else if (indexPath.section == 2) {
        
        UITableViewCell *myLikeMovieCell = [tableView dequeueReusableCellWithIdentifier:@"MyLikeMovieCell" forIndexPath:indexPath];
        
        if (!myLikeMovieCell) {
            
            myLikeMovieCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyLikeMovieCell"];
        }
        
        return myLikeMovieCell;
    }
    
    return nil;
}

- (void)setReloadSection:(UIButton *)sender{

    [self.myPageMainTableView reloadSections:[NSIndexSet indexSetWithIndex:sender.tag] withRowAnimation:UITableViewRowAnimationLeft];
}


- (IBAction)requestSignOut:(id)sender {
    [[PCUserInformation userInfo] hasUserSignedOut];
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
