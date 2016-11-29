//
//  MovieInfoManager.h
//  Popcorn
//
//  Created by giftbot on 2016. 11. 29..
//  Copyright © 2016년 giftbot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PCMovieInfoManager : NSObject

+ (NSDictionary *)requestMovieDetail:(NSString *)movieID;
+ (NSDictionary *)requestActorDetail:(NSString *)actorID;
+ (NSDictionary *)requestAllComments:(NSString *)movieID;
+ (NSDictionary *)requestAllFamousLines:(NSString *)movieID;


@end


