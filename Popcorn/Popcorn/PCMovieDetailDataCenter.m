//
//  PCMovieDetailDataCenter.m
//  Popcorn
//
//  Created by chaving on 2016. 12. 14..
//  Copyright © 2016년 giftbot. All rights reserved.
//

#import "PCMovieDetailDataCenter.h"
#import "PCNetworkParamKey.h"

@interface PCMovieDetailDataCenter ()

@property NSMutableArray *starHistogramArray;

@end

@implementation PCMovieDetailDataCenter

+ (instancetype)sharedMovieDetailData{
    
    static PCMovieDetailDataCenter *movieDetailData = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        movieDetailData = [[self alloc] init];
    });
    
    return movieDetailData;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.movieDetailDictionary = [[NSMutableDictionary alloc]init];
        self.movieDetailBestCommentList = [[NSMutableArray alloc]init];
        self.movieDetailBestFamousLineList = [[NSMutableArray alloc]init];
        self.movieDetailCommentList = [[NSMutableArray alloc]init];
        self.movieDetailFamousLineList = [[NSMutableArray alloc]init];
        self.movieDetailStarHistogramList = [[NSMutableArray alloc] init];
//        self.starHistogramArray = [[NSMutableArray alloc]
//                                   initWithObjects:@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0", nil];
    }
    return self;
}

#pragma mark - Movie Detail Contents
- (NSString *)creatMovieTitle{
    return [[PCMovieDetailDataCenter sharedMovieDetailData].movieDetailDictionary objectForKey:MovieDetailTitleKey];
}
- (NSString *)creatMovieDate{
    return [[PCMovieDetailDataCenter sharedMovieDetailData].movieDetailDictionary objectForKey:MovieDetailDateKey];
}
- (NSString *)creatMovieRunningTime{
    return [[PCMovieDetailDataCenter sharedMovieDetailData].movieDetailDictionary objectForKey:MovieDetailRunningTimeKey];
}
- (NSString *)creatMovieGrade{
    
    NSDictionary *dataDic = [[PCMovieDetailDataCenter sharedMovieDetailData].movieDetailDictionary objectForKey:MovieDetailGradeKey];
    
    return [dataDic objectForKey:@"content"];
}
- (NSString *)creatMovieStory{
    return [[PCMovieDetailDataCenter sharedMovieDetailData].movieDetailDictionary objectForKey:MovieDetailStoryKey];
}
- (NSURL *)creatMovieMainImage{
    return [NSURL URLWithString:[[PCMovieDetailDataCenter sharedMovieDetailData].movieDetailDictionary objectForKey:MovieDetailMainImageKey]];
}
- (NSURL *)creatMoviePosterImage{
    return [NSURL URLWithString:[[PCMovieDetailDataCenter sharedMovieDetailData].movieDetailDictionary objectForKey:MovieDetailPosterImageKey]];
}
- (NSString *)creatMovieGenre{
    
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
    NSArray *dataList = [[PCMovieDetailDataCenter sharedMovieDetailData].movieDetailDictionary objectForKey:MovieDetailGenreKey];
    
    for (NSInteger i = 0; i < dataList.count; i += 1) {
        
        NSDictionary *dataDic = dataList[i];
        
        NSString *dataText = [dataDic objectForKey:@"content"];
        
        [dataArray addObject:dataText];
    }
    
    return [dataArray componentsJoinedByString: @", "];
}
- (NSString *)creatMovieNation{
    
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
    NSArray *dataList = [[PCMovieDetailDataCenter sharedMovieDetailData].movieDetailDictionary objectForKey:MovieDetailNationKey];
    
    for (NSInteger i = 0; i < dataList.count; i += 1) {
        
        NSDictionary *dataDic = dataList[i];
        
        NSString *dataText = [dataDic objectForKey:@"content"];
        
        [dataArray addObject:dataText];
    }
    
    return [dataArray componentsJoinedByString: @", "];
}
- (NSArray *)creatMovieDirectorName{
    
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
    NSArray *dataList = [[PCMovieDetailDataCenter sharedMovieDetailData].movieDetailDictionary objectForKey:MovieDetailDirecterKey];
    
    for (NSInteger i = 0; i < dataList.count; i += 1) {
        
        NSDictionary *dataDic = dataList[i];
        
        NSString *dataText = [dataDic objectForKey:@"name_kor"];
        
        [dataArray addObject:dataText];
    }
    
    return dataArray;
}
- (NSArray *)creatMovieDirectorImage{
    
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
    NSArray *dataList = [[PCMovieDetailDataCenter sharedMovieDetailData].movieDetailDictionary objectForKey:MovieDetailDirecterKey];
    
    for (NSInteger i = 0; i < dataList.count; i += 1) {
        
        NSDictionary *dataDic = dataList[i];
        
        NSURL *dataURL = [NSURL URLWithString:[dataDic objectForKey:@"profile_url"]];
        
        [dataArray addObject:dataURL];
    }
    
    return dataArray;
}
- (NSArray *)creatMovieActorName{
    
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
    NSArray *dataList = [[PCMovieDetailDataCenter sharedMovieDetailData].movieDetailDictionary objectForKey:MovieDetailActorsKey];
    
    for (NSInteger i = 0; i < dataList.count; i += 1) {
        
        NSDictionary *dataDic = dataList[i];
        
        NSDictionary *dataSubList = [dataDic objectForKey:MovieDetailActorKey];
        
        NSString *dataText = [dataSubList objectForKey:@"name_kor"];
        
        [dataArray addObject:dataText];
    }
    
    return dataArray;
}
- (NSArray *)creatMovieActorMovieName{
    
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
    NSArray *dataList = [[PCMovieDetailDataCenter sharedMovieDetailData].movieDetailDictionary objectForKey:MovieDetailActorsKey];
    
    for (NSInteger i = 0; i < dataList.count; i += 1) {
        
        NSDictionary *dataDic = dataList[i];
        
        NSString *dataText = [dataDic objectForKey:MovieDetailActorMovieNameKey];
        
        [dataArray addObject:dataText];
    }
    
    return dataArray;
}
- (NSArray *)creatMovieActorImage{
    
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
    NSArray *dataList = [[PCMovieDetailDataCenter sharedMovieDetailData].movieDetailDictionary objectForKey:MovieDetailActorsKey];
    
    for (NSInteger i = 0; i < dataList.count; i += 1) {
        
        NSDictionary *dataDic = dataList[i];
        
        NSDictionary *dataSubList = [dataDic objectForKey:MovieDetailActorKey];
        
        NSURL *dataURL = [NSURL URLWithString:[dataSubList objectForKey:@"profile_url"]];
        
        [dataArray addObject:dataURL];
    }
    
    return dataArray;
}
- (NSArray *)creatMoviePhoto{
    
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
    NSArray *dataList = [[PCMovieDetailDataCenter sharedMovieDetailData].movieDetailDictionary objectForKey:MovieDetailPhotosKey];
    
    for (NSInteger i = 0; i < dataList.count; i += 1) {
        
        NSDictionary *dataDic = dataList[i];
        
        NSURL *dataURL = [NSURL URLWithString:[dataDic objectForKey:@"url"]];
        
        [dataArray addObject:dataURL];
    }
    
    return dataArray;
}
- (NSString *)creatStarAverage{

    return [[PCMovieDetailDataCenter sharedMovieDetailData].movieDetailDictionary objectForKey:MovieDetailStarAvergeKey];
}
- (NSURL *)creatMovieTrailer{
    return [NSURL URLWithString:[[PCMovieDetailDataCenter sharedMovieDetailData].movieDetailDictionary objectForKey:MovieDetailTrailerKey]];
}
- (NSString *)creatMovieCommentCount{
    return [[PCMovieDetailDataCenter sharedMovieDetailData].movieDetailDictionary objectForKey:@"comment_count"];
}

- (NSArray *)creatMovieStarHistogram{
    
    self.starHistogramArray= [NSMutableArray arrayWithArray:@[@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0"]];

    
    for (NSInteger i = 0; i < self.movieDetailStarHistogramList.count; i += 1) {
        
        NSString *starNum = [NSString stringWithFormat:@"%@",[self.movieDetailStarHistogramList[i] objectForKey:@"star"]];
        NSString *starCount = [NSString stringWithFormat:@"%@",[self.movieDetailStarHistogramList[i] objectForKey:@"count"]];
        
        if ([starNum isEqualToString:@"0.0"]) {
            [self.starHistogramArray replaceObjectAtIndex:1 withObject:starCount];
            
        }else if ([starNum isEqualToString:@"0.5"]){
            [self.starHistogramArray replaceObjectAtIndex:2 withObject:starCount];
            
        }else if ([starNum isEqualToString:@"1"]){
            [self.starHistogramArray replaceObjectAtIndex:3 withObject:starCount];
            
        }else if ([starNum isEqualToString:@"1.5"]){
            [self.starHistogramArray replaceObjectAtIndex:4 withObject:starCount];
            
        }else if ([starNum isEqualToString:@"2"]){
            [self.starHistogramArray replaceObjectAtIndex:5 withObject:starCount];
            
        }else if ([starNum isEqualToString:@"2.5"]){
            [self.starHistogramArray replaceObjectAtIndex:6 withObject:starCount];
            
        }else if ([starNum isEqualToString:@"3"]){
            [self.starHistogramArray replaceObjectAtIndex:7 withObject:starCount];
            
        }else if ([starNum isEqualToString:@"3.5"]){
            [self.starHistogramArray replaceObjectAtIndex:8 withObject:starCount];
            
        }else if ([starNum isEqualToString:@"4"]){
            [self.starHistogramArray replaceObjectAtIndex:9 withObject:starCount];
            
        }else if ([starNum isEqualToString:@"4.5"]){
            [self.starHistogramArray replaceObjectAtIndex:10 withObject:starCount];
            
        }else if ([starNum isEqualToString:@"5"]){
            [self.starHistogramArray replaceObjectAtIndex:11 withObject:starCount];
            
        }
    }
    
    [self.starHistogramArray replaceObjectAtIndex:12 withObject:@"0"];
    
    return self.starHistogramArray;
}

#pragma mark - Movie Detail BEST Comments
- (NSArray *)creatBestCommentUserID{
    
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
    NSMutableArray *dataList = [PCMovieDetailDataCenter sharedMovieDetailData].movieDetailBestCommentList;
    
    for (NSInteger i = 0; i < dataList.count; i += 1) {
        
        NSDictionary *dataDic = dataList[i];
        
        NSDictionary *dataAuthor = [dataDic objectForKey:MovieCommentUserIDKey];
        
        NSString *dataID = [dataAuthor objectForKey:@"nickname"];
        
        [dataArray addObject:dataID];
    }
    
    return dataArray;
}
- (NSArray *)creatBestCommentUserStar{
    
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
    NSMutableArray *dataList = [PCMovieDetailDataCenter sharedMovieDetailData].movieDetailBestCommentList;
    
    for (NSInteger i = 0; i < dataList.count; i += 1) {
        
        NSDictionary *dataDic = dataList[i];
        
        NSString *dataText = [dataDic objectForKey:MovieCommentUserStarKey];
        
        [dataArray addObject:dataText];
    }
    
    return dataArray;
}
- (NSArray *)creatBestCommentUserText{
    
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
    NSMutableArray *dataList = [PCMovieDetailDataCenter sharedMovieDetailData].movieDetailBestCommentList;
    
    for (NSInteger i = 0; i < dataList.count; i += 1) {
        
        NSDictionary *dataDic = dataList[i];
        
        NSString *dataText = [dataDic objectForKey:MovieCommentUserTextKey];
        
        [dataArray addObject:dataText];
    }
    
    return dataArray;
}
- (NSArray *)creatBestCommentLikeCount{
    
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
    NSMutableArray *dataList = [PCMovieDetailDataCenter sharedMovieDetailData].movieDetailBestCommentList;
    
    for (NSInteger i = 0; i < dataList.count; i += 1) {
        
        NSDictionary *dataDic = dataList[i];
        
        NSString *dataText = [dataDic objectForKey:MovieCommentLikeCountKey];
        
        [dataArray addObject:dataText];
    }
    
    return dataArray;
}
- (NSArray *)creatBestCommentWriteDate{
    
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
    NSMutableArray *dataList = [PCMovieDetailDataCenter sharedMovieDetailData].movieDetailBestCommentList;
    
    for (NSInteger i = 0; i < dataList.count; i += 1) {
        
        NSDictionary *dataDic = dataList[i];
        
        NSString *dataText = [dataDic objectForKey:MovieCommentWriteDateKey];
        
        [dataArray addObject:dataText];
    }
    
    return dataArray;
}
- (NSArray *)creatBestCommentUserImage{
    
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
    NSMutableArray *dataList = [PCMovieDetailDataCenter sharedMovieDetailData].movieDetailBestCommentList;
    
    for (NSInteger i = 0; i < dataList.count; i += 1) {
        
        NSDictionary *dataDic = dataList[i];
        
        NSDictionary *dataAuthor = [dataDic objectForKey:MovieCommentUserIDKey];
        
        NSURL *dataID = [dataAuthor objectForKey:@"profile_img"];
        
        [dataArray addObject:dataID];
    }
    
    return dataArray;
}

#pragma mark - Movie Detail Comments
- (NSArray *)creatCommentUserID{
    
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
    NSMutableArray *dataList = [PCMovieDetailDataCenter sharedMovieDetailData].movieDetailCommentList;
    
    for (NSInteger i = 0; i < dataList.count; i += 1) {
        
        NSDictionary *dataDic = dataList[i];
        
        NSDictionary *dataAuthor = [dataDic objectForKey:MovieCommentUserIDKey];
        
        NSString *dataID = [dataAuthor objectForKey:@"nickname"];
        
        [dataArray addObject:dataID];
    }
    
    return dataArray;
}
- (NSArray *)creatCommentUserStar{
    
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
    NSMutableArray *dataList = [PCMovieDetailDataCenter sharedMovieDetailData].movieDetailCommentList;
    
    for (NSInteger i = 0; i < dataList.count; i += 1) {
        
        NSDictionary *dataDic = dataList[i];
        
        NSString *dataText = [dataDic objectForKey:MovieCommentUserStarKey];
        
        [dataArray addObject:dataText];
    }
    
    return dataArray;
}
- (NSArray *)creatCommentUserText{
    
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
    NSMutableArray *dataList = [PCMovieDetailDataCenter sharedMovieDetailData].movieDetailCommentList;
    
    for (NSInteger i = 0; i < dataList.count; i += 1) {
        
        NSDictionary *dataDic = dataList[i];
        
        NSString *dataText = [dataDic objectForKey:MovieCommentUserTextKey];
        
        [dataArray addObject:dataText];
    }
    
    return dataArray;
}
- (NSArray *)creatCommentLikeCount{
    
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
    NSMutableArray *dataList = [PCMovieDetailDataCenter sharedMovieDetailData].movieDetailCommentList;
    
    for (NSInteger i = 0; i < dataList.count; i += 1) {
        
        NSDictionary *dataDic = dataList[i];
        
        NSString *dataText = [dataDic objectForKey:MovieCommentLikeCountKey];
        
        [dataArray addObject:dataText];
    }
    
    return dataArray;
}
- (NSArray *)creatCommentWriteDate{
    
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
    NSMutableArray *dataList = [PCMovieDetailDataCenter sharedMovieDetailData].movieDetailCommentList;
    
    for (NSInteger i = 0; i < dataList.count; i += 1) {
        
        NSDictionary *dataDic = dataList[i];
        
        NSString *dataText = [dataDic objectForKey:MovieCommentWriteDateKey];
        
        [dataArray addObject:dataText];
    }
    
    return dataArray;
}
- (NSArray *)creatCommentUserImage{
    
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
    NSMutableArray *dataList = [PCMovieDetailDataCenter sharedMovieDetailData].movieDetailCommentList;
    
    for (NSInteger i = 0; i < dataList.count; i += 1) {
        
        NSDictionary *dataDic = dataList[i];
        
        NSDictionary *dataAuthor = [dataDic objectForKey:MovieCommentUserIDKey];
        
        NSURL *dataID = [dataAuthor objectForKey:@"profile_img"];
        
        [dataArray addObject:dataID];
    }
    
    return dataArray;
}


#pragma mark - Movie Detail BEST Famousline
- (NSArray *)creatBestFamousLineUserID{
    
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
    NSMutableArray *dataList = [PCMovieDetailDataCenter sharedMovieDetailData].movieDetailBestFamousLineList;
    
    for (NSInteger i = 0; i < dataList.count; i += 1) {
        
        NSDictionary *dataDic = dataList[i];
        
        NSString *dataText = [dataDic objectForKey:MovieFamousLineUserIDKey];
        
        [dataArray addObject:dataText];
    }
    
    return dataArray;
}
- (NSArray *)creatBestFamousLineActorName{
    
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
    NSMutableArray *dataList = [PCMovieDetailDataCenter sharedMovieDetailData].movieDetailBestFamousLineList;
    
    for (NSInteger i = 0; i < dataList.count; i += 1) {
        
        NSDictionary *dataDic = dataList[i];
        
        NSString *dataText = [dataDic objectForKey:MovieFamousLineActorName];
        
        [dataArray addObject:dataText];
    }
    
    return dataArray;
}
- (NSArray *)creatBestFamousLineMovieName{
    
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
    NSMutableArray *dataList = [PCMovieDetailDataCenter sharedMovieDetailData].movieDetailBestFamousLineList;
    
    for (NSInteger i = 0; i < dataList.count; i += 1) {
        
        NSDictionary *dataDic = dataList[i];
        
        NSString *dataText = [dataDic objectForKey:MovieFamousLineMovieName];
        
        [dataArray addObject:dataText];
    }
    
    return dataArray;
}
- (NSArray *)creatBestFamousLineUserText{
    
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
    NSMutableArray *dataList = [PCMovieDetailDataCenter sharedMovieDetailData].movieDetailBestFamousLineList;
    
    for (NSInteger i = 0; i < dataList.count; i += 1) {
        
        NSDictionary *dataDic = dataList[i];
        
        NSString *dataText = [dataDic objectForKey:MovieFamousLineUserTextKey];
        
        [dataArray addObject:dataText];
    }
    
    return dataArray;
}
- (NSArray *)creatBestFamousLineLikeCount{
    
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
    NSMutableArray *dataList = [PCMovieDetailDataCenter sharedMovieDetailData].movieDetailBestFamousLineList;
    
    for (NSInteger i = 0; i < dataList.count; i += 1) {
        
        NSDictionary *dataDic = dataList[i];
        
        NSString *dataText = [dataDic objectForKey:MovieFamousLineLikeCountKey];
        
        [dataArray addObject:dataText];
    }
    
    return dataArray;
}
- (NSArray *)creatBestFamousLineWriteDate{
    
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
    NSMutableArray *dataList = [PCMovieDetailDataCenter sharedMovieDetailData].movieDetailBestFamousLineList;
    
    for (NSInteger i = 0; i < dataList.count; i += 1) {
        
        NSDictionary *dataDic = dataList[i];
        
        NSString *dataText = [dataDic objectForKey:MovieFamousLineWriteDateKey];
        
        [dataArray addObject:dataText];
    }
    
    return dataArray;
}

- (NSArray *)creatBestFamousLineActorImage{
    
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
    NSMutableArray *dataList = [PCMovieDetailDataCenter sharedMovieDetailData].movieDetailBestFamousLineList;
    
    for (NSInteger i = 0; i < dataList.count; i += 1) {
        
        NSDictionary *dataDic = dataList[i];
        
        NSURL *dataText = [dataDic objectForKey:@"actor_img_url"];
        
        [dataArray addObject:dataText];
    }
    
    return dataArray;
}

#pragma mark - Movie Detail Famousline
- (NSArray *)creatFamousLineUserID{
    
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
    NSMutableArray *dataList = [PCMovieDetailDataCenter sharedMovieDetailData].movieDetailFamousLineList;
    
    for (NSInteger i = 0; i < dataList.count; i += 1) {
        
        NSDictionary *dataDic = dataList[i];
        
        NSString *dataText = [dataDic objectForKey:MovieFamousLineUserIDKey];
        
        [dataArray addObject:dataText];
    }
    
    return dataArray;
}
- (NSArray *)creatFamousLineActorName{
    
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
    NSMutableArray *dataList = [PCMovieDetailDataCenter sharedMovieDetailData].movieDetailFamousLineList;
    
    for (NSInteger i = 0; i < dataList.count; i += 1) {
        
        NSDictionary *dataDic = dataList[i];
        
        NSString *dataText = [dataDic objectForKey:MovieFamousLineActorName];
        
        [dataArray addObject:dataText];
    }
    
    return dataArray;
}
- (NSArray *)creatFamousLineMovieName{
    
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
    NSMutableArray *dataList = [PCMovieDetailDataCenter sharedMovieDetailData].movieDetailFamousLineList;
    
    for (NSInteger i = 0; i < dataList.count; i += 1) {
        
        NSDictionary *dataDic = dataList[i];
        
        NSString *dataText = [dataDic objectForKey:MovieFamousLineMovieName];
        
        [dataArray addObject:dataText];
    }
    
    return dataArray;
}
- (NSArray *)creatFamousLineUserText{
    
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
    NSMutableArray *dataList = [PCMovieDetailDataCenter sharedMovieDetailData].movieDetailFamousLineList;
    
    for (NSInteger i = 0; i < dataList.count; i += 1) {
        
        NSDictionary *dataDic = dataList[i];
        
        NSString *dataText = [dataDic objectForKey:MovieFamousLineUserTextKey];
        
        [dataArray addObject:dataText];
    }
    
    return dataArray;
}
- (NSArray *)creatFamousLineLikeCount{
    
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
    NSMutableArray *dataList = [PCMovieDetailDataCenter sharedMovieDetailData].movieDetailFamousLineList;
    
    for (NSInteger i = 0; i < dataList.count; i += 1) {
        
        NSDictionary *dataDic = dataList[i];
        
        NSString *dataText = [dataDic objectForKey:MovieFamousLineLikeCountKey];
        
        [dataArray addObject:dataText];
    }
    
    return dataArray;
}
- (NSArray *)creatFamousLineWriteDate{
    
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
    NSMutableArray *dataList = [PCMovieDetailDataCenter sharedMovieDetailData].movieDetailFamousLineList;
    
    for (NSInteger i = 0; i < dataList.count; i += 1) {
        
        NSDictionary *dataDic = dataList[i];
        
        NSString *dataText = [dataDic objectForKey:MovieFamousLineWriteDateKey];
        
        [dataArray addObject:dataText];
    }
    
    return dataArray;
}
- (NSArray *)creatFamousLineActorImage{
    
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
    NSMutableArray *dataList = [PCMovieDetailDataCenter sharedMovieDetailData].movieDetailFamousLineList;
    
    for (NSInteger i = 0; i < dataList.count; i += 1) {
        
        NSDictionary *dataDic = dataList[i];
        
        NSURL *dataText = [dataDic objectForKey:@"actor_img_url"];
        
        [dataArray addObject:dataText];
    }
    
    return dataArray;
}

@end
























