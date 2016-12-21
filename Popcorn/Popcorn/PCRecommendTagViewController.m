//
//  PCRecommendTagViewController.m
//  Popcorn
//
//  Created by giftbot on 2016. 12. 10..
//  Copyright © 2016년 giftbot. All rights reserved.
//

#import "PCRecommendTagViewController.h"

#import "PCMovieInfoManager.h"
#import "PCUserInfoManager.h"

#import "PCUserProfileParamKey.h"
#import "PCRecommendTagButton.h"
#import "PCUserInformation.h"


@interface PCRecommendTagViewController ()

@property (nonatomic) NSMutableDictionary *userSelectedTag;

@property (nonatomic) CGFloat xOffset;
@property (nonatomic) CGFloat yOffset;

@property (nonatomic) UILabel *showTagCountLabel;
@property (nonatomic) NSUInteger tagCount;

@end

static NSArray *genreArray;
static NSArray *genreCodeArray;
static NSArray *gradeArray;
static NSArray *gradeCodeArray;
static NSArray *countryArray;
static NSArray *countryCodeArray;

static CGFloat const widthPadding = 20;
static CGFloat const heightPadding = 10;


@implementation PCRecommendTagViewController

#pragma mark - Init
+ (void)initialize {
    genreArray = @[@"액션", @"범죄", @"스릴러", @"어드벤처", @"판타지", @"SF", @"애니메이션", @"드라마", @"코미디", @"가족", @"로맨스/멜로", @"다큐멘터리"];
    genreCodeArray = @[@1, @2, @3, @4, @5, @6, @7, @8, @9, @10, @11, @13];
    
    gradeArray = @[@"전체관람가", @"12세 이상", @"15세 이상", @"19세 이상"];
    gradeCodeArray = @[@2, @3, @1, @4];
    
    countryArray = @[@"한국", @"미국", @"영국", @"독일", @"프랑스", @"일본", @"인도", @"중국", @"홍콩"];
    countryCodeArray = @[@6, @1, @2, @3, @4, @15, @8, @14, @16];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    sLog( self.parentViewController );
    [self initUserSelectedTagDictionary];
    [self createCustomBarButtonItem];
    [self createTagView];
}

- (void)initUserSelectedTagDictionary {
    self.userSelectedTag = [@{PCUserProfileFavoriteGenreKey:@[],
                              PCUserProfileFavoriteGradeKey:@[],
                              PCUserProfileFavoriteCountryKey:@[]} mutableCopy];
}

#pragma mark - Create View
- (void)createCustomBarButtonItem{
    UIButton *barButton = [UIButton buttonWithType:UIButtonTypeCustom];
    barButton.frame = CGRectMake(0, 0, 50, 50);
    [barButton setTitle:@"적용" forState:UIControlStateNormal];
    [barButton setTitleColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0] forState:UIControlStateNormal];
    [barButton setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [barButton addTarget:self action:@selector(saveSelectedTag) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *badgeView = [[UIImageView alloc] initWithFrame:CGRectMake(33, 8, 20, 20)];
    badgeView.layer.cornerRadius = 11;
    badgeView.backgroundColor = [UIColor colorWithRed:0.94 green:0.33 blue:0.41 alpha:1.0];
    [barButton addSubview:badgeView];
    
    self.showTagCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(4, 4, 11, 11)];
    self.showTagCountLabel.textColor = [UIColor whiteColor];
    self.showTagCountLabel.text = @"0";
    self.showTagCountLabel.font = [UIFont boldSystemFontOfSize:13.0f];
    self.showTagCountLabel.textAlignment = NSTextAlignmentCenter;
    [badgeView addSubview:_showTagCountLabel];
    
    UIBarButtonItem *customBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:barButton];
    self.navigationItem.rightBarButtonItem = customBarButtonItem;
}

- (void)createTagView {
    
    CGRect navigationBarFrame = self.navigationController.navigationBar.frame;
    self.yOffset = navigationBarFrame.origin.y + navigationBarFrame.size.height + heightPadding;
    
    // 장르 태그버튼 생성
    [self createTagCategoryLabel:@"장르"];
    [self createTagButton:PCUserProfileFavoriteGenreKey];
    
    // 관람등급 태그버튼 생성
    [self createTagCategoryLabel:@"관람등급"];
    [self createTagButton:PCUserProfileFavoriteGradeKey];
    
    // 국가 태그버튼 생성
    [self createTagCategoryLabel:@"국가"];
    [self createTagButton:PCUserProfileFavoriteCountryKey];
    
    _showTagCountLabel.text = [NSString stringWithFormat:@"%ld", _tagCount];
    
}

- (void)createTagCategoryLabel:(NSString *)title {
    CGSize tagTitleSize = CGSizeMake(self.view.frame.size.width, 30);
    
    self.xOffset = 15;
    UILabel *tagCategoryLabel = [[UILabel alloc] init];
    tagCategoryLabel.frame = CGRectMake(_xOffset, _yOffset, tagTitleSize.width - _xOffset, tagTitleSize.height);
    tagCategoryLabel.textColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1.0];
    tagCategoryLabel.text = title;
    [self.view addSubview:tagCategoryLabel];
}


- (void)createTagButton:(NSString *)category {
    NSArray *categoryDetailArray;
    NSArray *codeArray;
    NSUInteger tagIndex;
    
    if ([category isEqualToString:PCUserProfileFavoriteGenreKey]) {
        categoryDetailArray = genreArray;
        codeArray = genreCodeArray;
        tagIndex = 0;
    }
    else if ([category isEqualToString:PCUserProfileFavoriteGradeKey]) {
        categoryDetailArray = gradeArray;
        codeArray = gradeCodeArray;
        tagIndex = 20;
    }
    else {
        categoryDetailArray = countryArray;
        codeArray = countryCodeArray;
        tagIndex = 40;
    }
    
    
    CGSize tagButtonSize = CGSizeMake(100, 30);
    _userSelectedTag = [[[PCUserInformation sharedUserData] getUserFavoriteTags] mutableCopy];
    
    for (NSInteger i = 0; i < categoryDetailArray.count; i++) {
        if (i % 3 == 0) {
            self.xOffset = 15;
            self.yOffset += tagButtonSize.height + heightPadding;
        }
        
        PCRecommendTagButton *tagButton = [PCRecommendTagButton buttonWithType:UIButtonTypeCustom];
        tagButton.frame = CGRectMake(_xOffset, _yOffset, tagButtonSize.width, tagButtonSize.height);
        
        tagButton.tag = tagIndex + i;
        [tagButton configureButtonWithTitle:categoryDetailArray[i]];
        
        [tagButton addTarget:self action:@selector(didSelectTagButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:tagButton];
        self.xOffset += tagButtonSize.width + widthPadding;
        
        // 유저가 이전에 설정했었던 태그는 선택상태로 만들기
        for (NSInteger j = 0; j < [_userSelectedTag[category] count]; j++) {
            if ([_userSelectedTag[category][j] integerValue] == [codeArray[i] integerValue]) {
                tagButton.selected = YES;
                _tagCount += 1;
            }
        }
    }
    
    self.yOffset += tagButtonSize.height + heightPadding * 2;
}


- (void)didSelectTagButton:(UIButton *)button {
    NSMutableArray *addTagArray;
    NSArray *codeArray;
    NSString *tagKey;
    NSInteger index;
    
    if (button.tag < 20) {
        codeArray = genreCodeArray;
        addTagArray = [_userSelectedTag[PCUserProfileFavoriteGenreKey] mutableCopy];
        tagKey = PCUserProfileFavoriteGenreKey;
        index = 0;
    }
    else if (button.tag < 40) {
        codeArray = gradeCodeArray;
        addTagArray = [_userSelectedTag[PCUserProfileFavoriteGradeKey] mutableCopy];
        tagKey = PCUserProfileFavoriteGradeKey;
        index = 20;
    }
    else {
        codeArray = countryCodeArray;
        addTagArray = [_userSelectedTag[PCUserProfileFavoriteCountryKey] mutableCopy];
        tagKey = PCUserProfileFavoriteCountryKey;
        index = 40;
    }
    
    if (button.isSelected) {
        [addTagArray removeObject:codeArray[(button.tag - index)]];
        _tagCount -= 1;
    }
    else {
        [addTagArray addObject:codeArray[(button.tag - index)]];
        _tagCount += 1;
    }
    button.selected = !button.selected;
    _showTagCountLabel.text = [NSString stringWithFormat:@"%ld", _tagCount];
    
    [_userSelectedTag setObject:addTagArray forKey:tagKey];
}


- (void)saveSelectedTag {
    UserInfoTaskHandler completionHandler = ^(BOOL isSuccess) {
        if (isSuccess) {
            sLog(@"태그 저장 성공");
            [[PCUserInformation sharedUserData] changeFavoriteTags:_userSelectedTag];
        } else {
            sLog(@"태그 저장 실패");
        }
    };
    
    [[PCUserInfoManager userInfoManager] changeUserFavoriteTags:_userSelectedTag withCompletionHandler:completionHandler];
    
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -
- (void)dealloc {
    dLog(@" ");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
