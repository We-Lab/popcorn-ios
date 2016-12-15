//
//  PCMovieDetailManager.h
//  Popcorn
//
//  Created by chaving on 2016. 12. 14..
//  Copyright © 2016년 giftbot. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const movieDataRequestNotification = @"MovieDataRequestNotification";

@interface PCMovieDetailManager : NSObject

- (void)requestMovieDetailData;

@end
