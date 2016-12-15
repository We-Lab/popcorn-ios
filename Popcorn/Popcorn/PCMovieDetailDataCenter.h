//
//  PCMovieDetailDataCenter.h
//  Popcorn
//
//  Created by chaving on 2016. 12. 14..
//  Copyright © 2016년 giftbot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PCMovieDetailDataCenter : NSObject

@property NSMutableDictionary *movieDetailDictionary;

+ (instancetype)sharedMovieDetailData;

- (NSString *)creatMovieTitle;
- (NSString *)creatMovieDate;
- (NSString *)creatMovieRunningTime;
- (NSString *)creatMovieGrade;
- (NSString *)creatMovieStory;
- (NSURL *)creatMovieMainImage;
- (NSURL *)creatMoviePosterImage;
- (NSArray *)creatMovieGenre;
- (NSString *)creatMovieNation;
- (NSArray *)creatMovieDirectorName;
- (NSArray *)creatMovieDirectorImage;
- (NSArray *)creatMovieActorName;
- (NSArray *)creatMovieActorImage;
- (NSArray *)creatMoviePhoto;
- (NSString *)creatStarAverage;
- (NSURL *)creatMovieTrailer;

@end
