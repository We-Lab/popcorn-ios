//
//  PCRankingViewController.m
//  Popcorn
//
//  Created by giftbot on 2016. 11. 27..
//  Copyright © 2016년 giftbot. All rights reserved.
//

#import "PCSearchViewController.h"
#import "PCSearchResultTableViewCell.h"

@interface PCSearchViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UILabel *viewTitleLabel;
@property (weak, nonatomic) IBOutlet UITableView *switchingTableView;

@property (nonatomic) BOOL hasSearched;
@property (nonatomic) NSArray *rankingTypeArray;

@end

@implementation PCSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createCustomPlaceholder];
    self.rankingTypeArray = @[@"박스오피스 랭킹", @"평점순 랭킹", @"좋아요순 랭킹", @"장르별 랭킹"];
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
    [super viewWillAppear:animated];
    
#ifndef DEBUG
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:NSStringFromClass([self class])];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
#endif
}

- (void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBarHidden = NO;
    [super viewWillDisappear:animated];
}

#pragma mark - Search Result



#pragma mark - Textfield Configure
- (void)createCustomPlaceholder {
    NSTextAttachment *placeholderImageTextAttachment = [[NSTextAttachment alloc] init];
    UIImage *searchImage = [UIImage imageNamed:@"Search"];
    placeholderImageTextAttachment.image = [PCCommonUtility resizeImage:searchImage scaledToSize:CGSizeMake(15, 15) andAlpha:0.4f];
    placeholderImageTextAttachment.bounds = CGRectMake(-7, -3, 15, 15);
    
    NSMutableAttributedString *placeholderImageString = [[NSAttributedString attributedStringWithAttachment:placeholderImageTextAttachment] mutableCopy];
    
    NSMutableAttributedString *placeholderString = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"영화 제목 검색", nil)];
    [placeholderImageString appendAttributedString:placeholderString];
    
    self.searchTextField.attributedPlaceholder = placeholderImageString;
    self.searchTextField.textAlignment = NSTextAlignmentCenter;
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField.text.length == 0) {
        self.searchTextField.attributedPlaceholder = nil;
        self.searchTextField.textAlignment = NSTextAlignmentLeft;
        self.searchTextField.placeholder = @"영화 제목 검색";
        UIImage *searchImage = [UIImage imageNamed:@"Search"];
        searchImage = [PCCommonUtility resizeImage:searchImage scaledToSize:CGSizeMake(15, 15) andAlpha:0.4f];
        
        self.searchTextField.leftView = [[UIImageView alloc] initWithImage:searchImage];
        self.searchTextField.leftViewMode = UITextFieldViewModeAlways;
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if (textField.text.length == 0){
        self.searchTextField.leftView = nil;
        self.searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.viewTitleLabel.text = @"랭킹";
        self.hasSearched = NO;
        [self createCustomPlaceholder];
    }
    else {
        self.searchTextField.clearButtonMode = UITextFieldViewModeAlways;
        self.viewTitleLabel.text = @"검색 결과";
        self.hasSearched = YES;
    }
    
    [self.switchingTableView reloadData];
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField endEditing:YES];
    return YES;
}

- (IBAction)hideKeyboardWhenTouchOutside {
    if (_searchTextField.isEditing)
        [_searchTextField endEditing:YES];
}

# pragma mark - Configure TableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_hasSearched) {
        return 8;
    }
    else {
        return _rankingTypeArray.count;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_hasSearched){
        return 60;
    }
    else {
        return 115;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_hasSearched == NO) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RankingViewCell" forIndexPath:indexPath];
        
        NSString *imageName = [@"test" stringByAppendingString:[NSString stringWithFormat:@"%ld.jpg", indexPath.row % 4]];
        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
        
        cell.textLabel.text = _rankingTypeArray[indexPath.row];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:26];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.backgroundColor = [UIColor clearColor];
        return cell;
    }
    else {
        PCSearchResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchResultCell"];
        if (cell == nil){
            cell = [[PCSearchResultTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"SearchResultCell"];
        }
        cell.textLabel.text = @"테스트";
        cell.countryLabel.text = @"한국";
        cell.imageView.image = [UIImage imageNamed:@"test1.jpg"];
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}


# pragma mark -
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    dLog(@" ");
}
@end
