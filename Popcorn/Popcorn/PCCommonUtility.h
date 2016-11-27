//
//  PCCommonUtility.h
//  Popcorn
//
//  Created by giftbot on 2016. 11. 28..
//  Copyright © 2016년 giftbot. All rights reserved.
//

#pragma mark - Define Log Format
// 디버그 모드와 릴리즈 모드 구분하여 로그 출력
#ifdef DEBUG
#   define dLog(fmt, ...) NSLog((@"%s[Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#   define sLog(fmt, ...) NSLog((@"%s[Line %d] %@"), __PRETTY_FUNCTION__, __LINE__, fmt, ##__VA_ARGS__);
#   define alertLog(fmt, ...) [self presentViewController:[PCUtility alertControllerWithOnlyTitle:[NSString stringWithFormat:fmt, ##__VA_ARGS__]] animated:YES completion:nil];
#else
#   define dLog(...)
#   define sLog(...)
#   define alertLog(...)
#endif

// 디버깅 모드, 릴리즈 모드 상관없이 로그 출력
#define aLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);


// 아이폰, 아이패드, 시뮬레이터 구분
# pragma mark - Define Device Classification
#define IS_IPAD         (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE       (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_SIMULATOR    (TARGET_IPHONE_SIMULATOR)


// OS 버전 확인
# pragma mark - Define Checking OS Version
#define DeviceSystemVersion         ([[[UIDevice currentDevice] systemVersion] floatValue])
#define IsOverOSVersion(version)    (deviceSystemVersion >= (version))
#define IsBelowOSVersion(version)   (deviceSystemVersion <= (version))
#define IsOverIOS9                  IsOverOSVersion(9.0f)
