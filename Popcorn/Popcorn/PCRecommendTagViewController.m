//
//  PCRecommendTagViewController.m
//  Popcorn
//
//  Created by giftbot on 2016. 12. 10..
//  Copyright © 2016년 giftbot. All rights reserved.
//

#import "PCRecommendTagViewController.h"

#import "PCMovieInfoManager.h"
#import "PCRecommendTagButton.h"

@interface PCRecommendTagViewController ()
@property (nonatomic) NSMutableDictionary *tagButtonsDic;
@property (nonatomic) NSMutableArray *userSelectedTag;

@property (nonatomic) CGFloat xOffset;
@property (nonatomic) CGFloat yOffset;

@property (nonatomic) UILabel *showTagCountLabel;
@property (nonatomic) NSUInteger tagCount;

@end

static NSArray *genreArray;
static NSArray *gradeArray;
static NSArray *countryArray;

static CGFloat const widthPadding = 20;
static CGFloat const heightPadding = 10;

typedef NS_ENUM(NSUInteger, RecommendTagCategory) {
    PCRecommendGenreTagCategory = 0,
    PCRecommendGradeTagCategory,
    PCRecommendCountryTagCategory,
};


@implementation PCRecommendTagViewController

#pragma mark - Init
+ (void)initialize {
    
    //id는 1번부터 시작하며  12번째 인덱스는 빈값이어서 다큐멘터리가 그 자리를 대신함. 다큐멘터리는 원래 13번
    genreArray = @[@"액션", @"범죄", @"스릴러", @"어드벤처", @"판타지", @"SF", @"애니메이션", @"드라마", @"코미디", @"가족", @"로맨스/멜로", @"다큐멘터리"];
    
    //id는 1번부터 시작해서 5번까지 있으나 5번은 공백값
    gradeArray = @[@"15세 이상", @"전체관람가", @"12세 이상", @"19세 이상"];
    
    //1번부터 38번까지 있으나 9개에서 컷
    countryArray = @[@"한국", @"미국", @"영국", @"독일", @"프랑스", @"일본", @"인도", @"중국", @"홍콩"];
    //한국:6, 미국:1, 영국:2, 독일:3, 프랑스:4, 일본:15 , 인도:8, 중국:14, 홍콩:16
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tagButtonsDic = [NSMutableDictionary new];
    self.userSelectedTag = [NSMutableArray new];
    [self saveSelectedTagBarButtonItem];
    [self createTagView];
}



#pragma mark - Create View
- (void)saveSelectedTagBarButtonItem{
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
    
    // 장르 태그
    [self createTagCategoryLabel:@"장르"];
    [self createTagButton:PCRecommendGenreTagCategory];
    
    // 관람등급 태그
    [self createTagCategoryLabel:@"관람등급"];
    [self createTagButton:PCRecommendGradeTagCategory];
    
    // 국가 태그
    [self createTagCategoryLabel:@"국가"];
    [self createTagButton:PCRecommendCountryTagCategory];
    
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


- (void)createTagButton:(RecommendTagCategory)category {
    
    CGSize tagButtonSize = CGSizeMake(100, 30);
    NSArray *categoryDetailArray = [NSArray array];
    NSMutableArray *tagStoreArray = [NSMutableArray array];
    
    switch (category) {
        case PCRecommendGenreTagCategory:
            categoryDetailArray = genreArray;
            break;
        case PCRecommendGradeTagCategory:
            categoryDetailArray = gradeArray;
            break;
        case PCRecommendCountryTagCategory:
            categoryDetailArray = countryArray;
            break;
    }
    
    for (NSInteger i = 0; i < categoryDetailArray.count; i++) {
        if (i % 3 == 0) {
            self.xOffset = 15;
            self.yOffset += tagButtonSize.height + heightPadding;
        }
        
        PCRecommendTagButton *tagButton = [PCRecommendTagButton buttonWithType:UIButtonTypeCustom];
        tagButton.frame = CGRectMake(_xOffset, _yOffset, tagButtonSize.width, tagButtonSize.height);
        tagButton.tag = i;
        [tagButton configureButtonWithTitle:categoryDetailArray[i]];
        [tagButton addTarget:self action:@selector(didSelectTagButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:tagButton];
        [tagStoreArray addObject:tagButton];
        self.xOffset += tagButtonSize.width + widthPadding;
    }
    
    NSNumber *keyValue = [NSNumber numberWithUnsignedInteger:category];
    [self.tagButtonsDic setObject:tagStoreArray forKey:keyValue];
    
    self.yOffset += tagButtonSize.height + heightPadding * 2;
}


- (void)didSelectTagButton:(UIButton *)button {
    if (button.isSelected) {
        [self.userSelectedTag removeObject:button.titleLabel.text];
        _tagCount -= 1;
    }
    else {
        [self.userSelectedTag addObject:button.titleLabel.text];
        _tagCount += 1;
    }
    button.selected = !button.selected;
    _showTagCountLabel.text = [NSString stringWithFormat:@"%ld", _tagCount];
}


// 선택한 태그 정보 저장 후 이전 화면으로 이동
- (void)saveSelectedTag {
//    NetworkTaskHandler completionHandler = ^(BOOL isSuccess, NSArray *resultArray){
//        if (isSuccess) {
//            [self didReceiveMovieData:resultArray];
//        }
//        else {
//            alertLog(@"영화정보를 가져오는 데 실패하였습니다.");
//        }
//    };
//    
//    [[PCMovieInfoManager movieManager] requestMovieListWithTag:_userSelectedTag andCompletionHandler:completionHandler];
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
