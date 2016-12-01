//
//  PCMovieNaviView.h
//  Popcorn
//
//  Created by chaving on 2016. 12. 1..
//  Copyright © 2016년 giftbot. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    
    MovieNaviBarTypeNormal = 0,
    MovieNaviBarTypeDetailView = 1
    
}MovieNaviBarType;

@interface PCMovieNaviView : UIView

- (instancetype)initWithType:(MovieNaviBarType)type ViewController:(UIViewController *)vc target:(id)target action:(SEL)action;

@end
