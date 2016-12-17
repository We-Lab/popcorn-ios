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
#warning need to confirm genre
    genreArray = @[@"액션", @"드라마", @"전쟁", @"다큐멘터리", @"코미디", @"공포", @"로맨스", @"애니메이션", @"판타지", @"SF", @"미스터리", @"스릴러"];
    gradeArray = @[@"12세 등급", @"15세 등급", @"19세 등급", @"전체 관람가능"];
    countryArray = @[@"한국", @"미국", @"일본", @"영국", @"중국", @"인도", @"독일", @"프랑스", @"홍콩"];
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
    }
    else {
        [self.userSelectedTag addObject:button.titleLabel.text];
    }
    button.selected = !button.selected;
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
