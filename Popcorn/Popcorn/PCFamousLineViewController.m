//
//  PCFamousLineViewController.m
//  Popcorn
//
//  Created by giftbot on 2016. 11. 29..
//  Copyright © 2016년 giftbot. All rights reserved.
//

#import "PCFamousLineViewController.h"
#import "PCFamousLineCustomCell.h"

@interface PCFamousLineViewController ()
@property (weak, nonatomic) IBOutlet UITableView *famousLineListTableView;

@end

@implementation PCFamousLineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = YES;
    self.famousLineListTableView.rowHeight = UITableViewAutomaticDimension;
    self.famousLineListTableView.estimatedRowHeight = 200;
}


#pragma mark - TableView Required
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PCFamousLineCustomCell *famousLineCell = [tableView dequeueReusableCellWithIdentifier:@"FamousLineCell" forIndexPath:indexPath];
    
    if (!famousLineCell) {
        
        famousLineCell = [[PCFamousLineCustomCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FamousLineCell"];
    }
    
    return  famousLineCell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    dLog(@" ");
}

@end
