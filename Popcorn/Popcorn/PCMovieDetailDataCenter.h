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
@property NSMutableArray *movieDetailBestCommentList;
@property NSMutableArray *movieDetailBestFamousLineList;
@property NSMutableArray *movieDetailCommentList;
@property NSMutableArray *movieDetailFamousLineList;
@property NSString *movieID;

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
- (NSArray *)creatMovieActorMovieName;
- (NSArray *)creatMovieActorImage;
- (NSArray *)creatMoviePhoto;
- (NSString *)creatStarAverage;
- (NSURL *)creatMovieTrailer;
- (NSString *)creatMovieCommentCount;

- (NSArray *)creatBestCommentUserID;
- (NSArray *)creatBestCommentUserStar;
- (NSArray *)creatBestCommentUserText;
- (NSArray *)creatBestCommentLikeCount;
- (NSArray *)creatBestCommentWriteDate;

- (NSArray *)creatCommentUserID;
- (NSArray *)creatCommentUserStar;
- (NSArray *)creatCommentUserText;
- (NSArray *)creatCommentLikeCount;
- (NSArray *)creatCommentWriteDate;

- (NSArray *)creatBestFamousLineUserID;
- (NSArray *)creatBestFamousLineActorName;
- (NSArray *)creatBestFamousLineMovieName;
- (NSArray *)creatBestFamousLineUserText;
- (NSArray *)creatBestFamousLineLikeCount;
- (NSArray *)creatBestFamousLineWriteDate;

- (NSArray *)creatFamousLineUserID;
- (NSArray *)creatFamousLineActorName;
- (NSArray *)creatFamousLineMovieName;
- (NSArray *)creatFamousLineUserText;
- (NSArray *)creatFamousLineLikeCount;
- (NSArray *)creatFamousLineWriteDate;

@end
