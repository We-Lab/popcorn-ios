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
@property (weak, nonatomic) IBOutlet UIView *tableViewHeaderButtonView;
@property UIButton *myPageButton;
@property NSInteger selectButton;
@property UIView *buttonUnderLine;

@end

@implementation PCMyPageViewController

- (instancetype)init
{
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
    
    CGFloat baseMovieContentWidth = self.tableViewHeaderButtonView.frame.size.width/3;
    CGFloat baseMovieContentHeight = [self ratioHeight:42];
    
    for (NSInteger i = 0; i < 3; i += 1) {
        
        self.myPageButton = [[UIButton alloc] init];
        
        self.myPageButton.tag = i;
        NSInteger row = self.myPageButton.tag;
        
        self.myPageButton.frame = CGRectMake(baseMovieContentWidth * row, 0, baseMovieContentWidth, baseMovieContentHeight);
        self.myPageButton.backgroundColor = [UIColor whiteColor];
        
        if (i == 0) {
            [self.myPageButton setTitle:@"평가영화" forState:UIControlStateNormal];
        }else if (i == 1){
            [self.myPageButton setTitle:@"명대사" forState:UIControlStateNormal];
        }else if (i == 2){
            [self.myPageButton setTitle:@"좋아요" forState:UIControlStateNormal];
        }
        
        self.myPageButton.titleLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightSemibold];
        [self.myPageButton setTitleColor:[UIColor  colorWithRed:51.f/255.f green:51.f/255.f blue:51.f/255.f alpha:1] forState:UIControlStateNormal];
        
        [self.myPageButton addTarget:self action:@selector(setReloadSection:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.tableViewHeaderButtonView addSubview:self.myPageButton];
    }
    
    self.buttonUnderLine = [[UIView alloc] init];
    
    self.buttonUnderLine.frame = CGRectMake(0, baseMovieContentHeight, baseMovieContentWidth, [self ratioHeight:3]);
    self.buttonUnderLine.backgroundColor = [UIColor darkGrayColor];
    
    [self.tableViewHeaderButtonView addSubview:self.buttonUnderLine];
}

#pragma mark - TableView Required
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.selectButton == 0) {
        
        UITableViewCell *myCommentCell = [tableView dequeueReusableCellWithIdentifier:@"MyCommentCell" forIndexPath:indexPath];
        
        if (!myCommentCell) {
            
            myCommentCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyCommentCell"];
        }
        
        return myCommentCell;
        
    }else if (self.selectButton == 1) {
        
        UITableViewCell *myFamousLineCell = [tableView dequeueReusableCellWithIdentifier:@"MyFamousLineCell" forIndexPath:indexPath];
        
        if (!myFamousLineCell) {
            
            myFamousLineCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyFamousLineCell"];
        }
        
        return myFamousLineCell;
    
    }else if (self.selectButton == 2) {
        
        UITableViewCell *myLikeMovieCell = [tableView dequeueReusableCellWithIdentifier:@"MyLikeMovieCell" forIndexPath:indexPath];
        
        if (!myLikeMovieCell) {
            
            myLikeMovieCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyLikeMovieCell"];
        }
        
        return myLikeMovieCell;
    }
    
    return nil;
}

- (void)setReloadSection:(UIButton *)sender{

    if (self.selectButton != sender.tag) {
        
        if (self.selectButton > sender.tag) {
            
            self.selectButton = sender.tag;
            
            [UIView animateWithDuration:0.3 animations:^{
                self.buttonUnderLine.frame = CGRectMake((self.tableViewHeaderButtonView.frame.size.width/3 * sender.tag), [self ratioHeight:42], self.tableViewHeaderButtonView.frame.size.width/3, [self ratioHeight:3]);
            }];
            
            [self.myPageMainTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationLeft];
            
        }else if (self.selectButton < sender.tag) {
            
            self.selectButton = sender.tag;
            
            [UIView animateWithDuration:0.3 animations:^{
                self.buttonUnderLine.frame = CGRectMake((self.tableViewHeaderButtonView.frame.size.width/3 * sender.tag), [self ratioHeight:42], self.tableViewHeaderButtonView.frame.size.width/3, [self ratioHeight:3]);
            }];
            
            [self.myPageMainTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationRight];
        }
        
    }
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
