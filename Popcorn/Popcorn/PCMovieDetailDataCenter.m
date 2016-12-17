//
//  PCMovieDetailDataCenter.m
//  Popcorn
//
//  Created by chaving on 2016. 12. 14..
//  Copyright © 2016년 giftbot. All rights reserved.
//

#import "PCMovieDetailDataCenter.h"
#import "PCNetworkParamKey.h"

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
        self.movieDetailBestCommentList = [[NSMutableDictionary alloc]init];
        self.movieDetailBestFamousLineList = [[NSMutableDictionary alloc]init];
        self.movieDetailCommentList = [[NSMutableDictionary alloc]init];
        self.movieDetailFamousLineList= [[NSMutableDictionary alloc]init];
    }
    return self;
}

#pragma mark - Movie Detail
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
        
        NSString *dataText = [dataDic objectForKey:@"name_kor"];
        
        [dataArray addObject:dataText];
    }
    
    return dataArray;
}
- (NSArray *)creatMovieActorImage{
    
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
    NSArray *dataList = [[PCMovieDetailDataCenter sharedMovieDetailData].movieDetailDictionary objectForKey:MovieDetailActorsKey];
    
    for (NSInteger i = 0; i < dataList.count; i += 1) {
        
        NSDictionary *dataDic = dataList[i];
        
        NSURL *dataURL = [NSURL URLWithString:[dataDic objectForKey:@"profile_url"]];
        
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


@end
























