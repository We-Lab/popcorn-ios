//
//  PCMovieTrailerViewController.m
//  Popcorn
//
//  Created by chaving on 2016. 12. 15..
//  Copyright © 2016년 giftbot. All rights reserved.
//

#import "PCMovieTrailerViewController.h"
#import "PCMovieDetailDataCenter.h"

@interface PCMovieTrailerViewController ()

@property PCMovieDetailDataCenter *movieDataCenter;
@property (weak, nonatomic) IBOutlet UIWebView *movieTrailerWebView;

@end

@implementation PCMovieTrailerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.movieDataCenter = [[PCMovieDetailDataCenter alloc] init];
    [self playVideo];
}

-(void)playVideo{
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[_movieDataCenter creatMovieTrailer]];
    
    [self.movieTrailerWebView loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
