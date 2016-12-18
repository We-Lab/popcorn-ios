//
//  PCRankingViewController.m
//  Popcorn
//
//  Created by giftbot on 2016. 11. 27..
//  Copyright © 2016년 giftbot. All rights reserved.
//

#import "PCSearchViewController.h"

#import <SDWebImage/UIImageView+WebCache.h>

#import "PCMovieInfoManager.h"
#import "PCSearchResultTableViewCell.h"
#import "PCRankingDetailViewController.h"

@interface PCSearchViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UILabel *viewTitleLabel;
@property (weak, nonatomic) IBOutlet UITableView *switchingTableView;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapGesture;

@property (nonatomic) BOOL hasSearched;
@property (nonatomic) NSArray *movieListData;
@property (nonatomic) NSUInteger searchResultCount;
@property (nonatomic) NSUInteger selectedRow;

@end

static NSArray const *rankingTypeArray;

@implementation PCSearchViewController


# pragma mark - Init
+ (void)initialize {
    rankingTypeArray = @[@"박스오피스 랭킹", @"평점순 랭킹", @"좋아요순 랭킹"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createCustomPlaceholder];
    self.tapGesture.cancelsTouchesInView = NO;
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


#pragma mark - Search Movie
- (void)searchMovie:(NSString *)inputText {
    NetworkTaskHandler completionHandler = ^(BOOL isSuccess, NSArray *resultArray){
        if (isSuccess) {
            [self didReceiveMovieData:resultArray];
        }
        else {
            alertLog(@"영화정보를 가져오는 데 실패하였습니다.");
        }
    };
    
    [[PCMovieInfoManager movieManager] requestMovieList:inputText withCompletionHandler:completionHandler];
}

- (void)didReceiveMovieData:(NSArray *)resultArray {
    sLog(resultArray);
    self.movieListData = resultArray;
    self.searchResultCount = resultArray.count;
    
    if (_searchResultCount == 0) {
        self.viewTitleLabel.text = @"검색 결과 없음";
    }
    else {
        self.viewTitleLabel.text = [NSString stringWithFormat:@"검색 결과 : %lu", _searchResultCount];
        [self.switchingTableView reloadData];
    }
}


#pragma mark - Configure Textfield
- (void)createCustomPlaceholder {
    NSTextAttachment *placeholderImageTextAttachment = [[NSTextAttachment alloc] init];
    UIImage *searchImage = [UIImage imageNamed:@"Search"];
    placeholderImageTextAttachment.image = [PCCommonUtility resizeImage:searchImage scaledToSize:CGSizeMake(15, 15) andAlpha:0.5f];
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
        self.hasSearched = YES;
        self.searchTextField.clearButtonMode = UITextFieldViewModeAlways;
        self.viewTitleLabel.text = @"검색 결과";
        [self searchMovie:textField.text];
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
        return _searchResultCount;
    }
    else {
        return rankingTypeArray.count;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_hasSearched){
        return (60 * [UIScreen mainScreen].bounds.size.height) / 667;
    }
    else {
        return (130 * [UIScreen mainScreen].bounds.size.height) / 667;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_hasSearched == NO) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RankingViewCell" forIndexPath:indexPath];
        
        NSString *imageName = [@"test" stringByAppendingString:[NSString stringWithFormat:@"%ld.jpg", indexPath.row % 4]];
        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
        
        cell.textLabel.text = rankingTypeArray[indexPath.row];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:26];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.backgroundColor = [UIColor clearColor];
        return cell;
    }
    else {
        PCSearchResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchResultCell"];
        if (cell == nil)
            cell = [[PCSearchResultTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"SearchResultCell"];
        
        NSString *titleString = _movieListData[indexPath.row][@"title_kor"];
        NSString *yearString = _movieListData[indexPath.row][@"created_year"];
        cell.textLabel.text = [NSString stringWithFormat:@"%@ (%@)", titleString, yearString];
        
        NSArray *genreArray= _movieListData[indexPath.row][@"genre"];
        __block NSString *genreLabelString;
        [genreArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (genreLabelString == nil) {
                genreLabelString = obj[@"content"];
            }
            else {
                NSString *appendString = [NSString stringWithFormat:@"  %@", obj[@"content"]];
                genreLabelString = [genreLabelString stringByAppendingString:appendString];
            }
        }];
        cell.additionalInfoLabel.text = genreLabelString;
        cell.imageView.image = [UIImage imageNamed:@"test1.jpg"];
        
        NSURL *imageURL = [NSURL URLWithString:_movieListData[indexPath.row][@"img_url"]];
        [cell.imageView sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"test1.jpg"]];
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedRow = indexPath.row;
    return indexPath;
}


# pragma mark - Configure Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    PCRankingDetailViewController *rankingDetailVC = segue.destinationViewController;
    rankingDetailVC.rankingType = _selectedRow;
}


# pragma mark -
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    dLog(@" ");
}
@end
