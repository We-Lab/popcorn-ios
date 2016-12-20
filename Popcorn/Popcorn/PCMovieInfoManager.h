//
//  MovieInfoManager.h
//  Popcorn
//
//  Created by giftbot on 2016. 11. 29..
//  Copyright © 2016년 giftbot. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^NetworkTaskHandler)(BOOL isSuccess, NSArray *resultArray);

typedef NS_ENUM(NSUInteger, RankingListType) {
    BoxOfficeRankingDetailList,
    RatingRankingDetailList,
    LikeRankingDetailList,
};

@interface PCMovieInfoManager : NSObject

+ (instancetype)movieManager;

- (void)requestMovieList:(NSString *)inputText withCompletionHandler:(NetworkTaskHandler)completionHandler;
- (void)requestRankingList:(RankingListType)rankingType withCompletionHandler:(NetworkTaskHandler)completionHandler;

// Main
- (void)requestBoxOfficeListwithCompletionHandler:(NetworkTaskHandler)completionHandler;
- (void)requestMagazineListWithCompletionHandler:(NetworkTaskHandler)completionHandler;
- (void)requestBestCommentWithCompletionHandler:(NetworkTaskHandler)completionHandler;
- (void)requestTodayRecommendMovieWithCompletionHandler:(NetworkTaskHandler)completionHandler;

//Recommend
- (void)requestMovieListWithTags:(NSDictionary *)tags andCompletionHandler:(NetworkTaskHandler)completionHandler;


@end


