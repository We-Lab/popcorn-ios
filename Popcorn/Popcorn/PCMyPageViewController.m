//
//  PCMyPageViewController.m
//  Popcorn
//
//  Created by giftbot on 2016. 11. 27..
//  Copyright © 2016년 giftbot. All rights reserved.
//

#import "PCMyPageViewController.h"
#import "PCUserInformation.h"

@interface PCMyPageViewController ()
@property (weak, nonatomic) IBOutlet UITableView *myPageMainTableView;

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
    
    self.myPageMainTableView.tableHeaderView = myPageTableHeaderView;
    
    UIImageView *userImageView = [[UIImageView alloc] init];
    
    userImageView.frame = CGRectMake(0, 0, self.view.frame.size.width, [self ratioHeight:200]);
    
    [myPageTableHeaderView addSubview:userImageView];
    
    UIView *myPageButtonView = [[UIView alloc] init];
    
    myPageButtonView.frame = CGRectMake(0, userImageView.frame.size.height, userImageView.frame.size.width, [self ratioHeight:45]);
    
    [myPageTableHeaderView addSubview:myPageButtonView];
    
    for (NSInteger i = 0; i < 3; i += 1) {
        
        CGFloat baseMovieContentWidth = myPageButtonView.frame.size.width/3;
        CGFloat baseMovieContentHeight = myPageButtonView.frame.size.height;
        
        UIView *myPageButtonLine = [[UIView alloc] init];
        
        myPageButtonLine.tag = i;
        NSInteger row = myPageButtonLine.tag;
        myPageButtonLine.frame = CGRectMake(baseMovieContentWidth * row,0,
                                            baseMovieContentWidth,baseMovieContentHeight);
        
        [myPageButtonView addSubview:myPageButtonLine];
        
        UIButton *myPageButton = [[UIButton alloc] init];
        
        myPageButton.frame = CGRectMake(0, 0, myPageButtonLine.frame.size.width, [self ratioHeight:42]);
        
        if (i == 0) {
            myPageButton.titleLabel.text = @"평가영화";
        }else if (i == 1){
            
            myPageButton.titleLabel.text = @"명대사";
        }else if (i == 2){
            
            myPageButton.titleLabel.text = @"좋아요";
        }
        
        myPageButton.titleLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightSemibold];
        myPageButton.titleLabel.textColor = [UIColor colorWithRed:51.f/255.f green:51.f/255.f blue:51.f/255.f alpha:1];
        
        [myPageButtonLine addSubview:myPageButton];
    }
}

#pragma mark - TableView Required
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *myPageCell = [tableView dequeueReusableCellWithIdentifier:@"MyPageCell" forIndexPath:indexPath];
    
    if (myPageCell != nil) {
        myPageCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyPageCell"];
    }
    
    return myPageCell;
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
