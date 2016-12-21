//
//  PCChangeInfoTextViewController.m
//  Popcorn
//
//  Created by chaving on 2016. 12. 21..
//  Copyright © 2016년 giftbot. All rights reserved.
//

#import "PCChangeInfoTextViewController.h"
#import "PCChangeMyInfoViewController.h"
#import "PCChangePasswordViewController.h"

@interface PCChangeInfoTextViewController ()
@property (weak, nonatomic) IBOutlet UITextField *changeTextField;
@property (weak, nonatomic) IBOutlet UIButton *changeButton;

@end

@implementation PCChangeInfoTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.changeTextField.font = [UIFont systemFontOfSize:13];
    
    if (self.type == ChangeNickname) {
        
        self.changeTextField.placeholder = @"변경될 닉네임을 작성해주세요.";
        
    }else if (self.type == ChangePhoneNumber) {
        
        self.changeTextField.placeholder = @"변경될 전화번호를 작성해주세요.";
        
    }else if (self.type == ChangePassword) {
        
        self.changeTextField.placeholder = @"기존 비밀번호를 작성해주세요.";
        [self.changeButton setTitle:@"확인" forState:UIControlStateNormal];
        [_changeButton addTarget:self action:@selector(moveToChangePassword) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)moveToChangePassword {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MyPage" bundle:nil];
    PCChangePasswordViewController *passwordVC = [storyboard instantiateViewControllerWithIdentifier:@"PasswordViewController"];
    [self.navigationController pushViewController:passwordVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
