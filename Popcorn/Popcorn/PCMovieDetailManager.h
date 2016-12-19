//
//  PCMovieDetailManager.h
//  Popcorn
//
//  Created by chaving on 2016. 12. 14..
//  Copyright © 2016년 giftbot. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const movieDataRequestNotification = @"MovieDataRequestNotification";
typedef void(^DataTaskHandler)(NSURLResponse *, id, NSError *);


@interface PCMovieDetailManager : NSObject

- (NSURLSessionDataTask *)requestMovieDetailData:(DataTaskHandler)handler;
- (NSURLSessionDataTask *)requestMovieDetailStarGraphData:(DataTaskHandler)handler;
- (NSURLSessionDataTask *)requestMovieDetailBestCommentData:(DataTaskHandler)handler;
- (NSURLSessionDataTask *)requestMovieDetailBestFamousLineData:(DataTaskHandler)handler;
- (NSURLSessionDataTask *)requestMovieDetailCommentData:(DataTaskHandler)handler;
- (NSURLSessionDataTask *)requestMovieDetailFamousLineData:(DataTaskHandler)handler;

@end
