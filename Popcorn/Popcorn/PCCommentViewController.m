//
//  PCCommentViewController.m
//  Popcorn
//
//  Created by giftbot on 2016. 11. 29..
//  Copyright © 2016년 giftbot. All rights reserved.
//

#import "PCCommentViewController.h"
#import "PCCommentCustomCell.h"
#import <HCSStarRatingView.h>

@interface PCCommentViewController () <UITableViewDelegate, UITableViewDataSource>


@end

@implementation PCCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setCustomViewStatus];

}

#pragma mark - Make Custem View
- (void)setCustomViewStatus{
    
    self.navigationController.view.backgroundColor = [UIColor clearColor];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *commentCell = [tableView dequeueReusableCellWithIdentifier:@"CommnetCell" forIndexPath:indexPath];
    
    if (commentCell != nil) {
        
        commentCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CommnetCell"];
    }
    
    return  commentCell;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//
////    CGFloat  [tableView cellForRowAtIndexPath:indexPath].text.hei;
//    
//    return nil;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    dLog(@" ");
}

@end
