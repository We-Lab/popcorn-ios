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
@property NSMutableDictionary *movieDetailCommentList;
@property NSMutableDictionary *movieDetailFamousLineList;
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

- (NSArray *)creatBestCommentUserID;
- (NSArray *)creatBestCommentUserStar;
- (NSArray *)creatBestCommentUserText;
- (NSArray *)creatBestCommentLikeCount;
- (NSArray *)creatBestCommentWriteDate;

- (NSArray *)creatBestFamousLineUserID;
- (NSArray *)creatBestFamousLineActorName;
- (NSArray *)creatBestFamousLineMovieName;
- (NSArray *)creatBestFamousLineUserText;
- (NSArray *)creatBestFamousLineLikeCount;
- (NSArray *)creatBestFamousLineWriteDate;

@end
