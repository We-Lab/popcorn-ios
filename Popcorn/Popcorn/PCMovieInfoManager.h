//
//  MovieInfoManager.h
//  Popcorn
//
//  Created by giftbot on 2016. 11. 29..
//  Copyright © 2016년 giftbot. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^MovieNetworkingHandler)(BOOL isSuccess, NSArray *movieListData);

typedef NS_ENUM(NSUInteger, RankingListType) {
    BoxOfficeRankingDetailList,
    RatingRankingDetailList,
    LikeRankingDetailList,
};

@interface PCMovieInfoManager : NSObject

+ (instancetype)movieManager;

- (void)requestMovieList:(NSString *)inputText withCompletionHandler:(MovieNetworkingHandler)completionHandler;
- (void)requestRankingList:(RankingListType)rankingType withCompletionHandler:(MovieNetworkingHandler)completionHandler;

// Main
- (void)requestBoxOfficeListwithCompletionHandler:(MovieNetworkingHandler)completionHandler;

//Recommend
- (void)requestMovieListWithTag:(NSArray *)tagArray andCompletionHandler:(MovieNetworkingHandler)completionHandler;


@end


