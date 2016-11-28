//
//  PCSignUpViewController.m
//  Popcorn
//
//  Created by giftbot on 2016. 11. 27..
//  Copyright © 2016년 giftbot. All rights reserved.
//

#import "PCSignUpEmailViewController.h"
#import "PCLoginNaviView.h"

@interface PCSignUpEmailViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *birthdayTextField;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@end

@implementation PCSignUpEmailViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeNavigationView];
    [self enableUserInteractionToBirthdayTextField];
}

- (void)makeNavigationView {
    // 커스텀 네비게이션바 생성
    PCLoginNaviView *viewNavi = [[PCLoginNaviView alloc] initWithType:LoginNaviBarTypePreve ViewController:self target:self action:@selector(onTouchUpToNextPage:)];
    
    // 네비게이션 바 숨김
    [self.navigationController setNavigationBarHidden:YES];
    
    // 스테이터스 바 스타일
    [self preferredStatusBarStyle];
    self.edgesForExtendedLayout=UIRectEdgeTop;
    self.automaticallyAdjustsScrollViewInsets=NO;
}

- (void)enableUserInteractionToBirthdayTextField {
    _birthdayTextField.userInteractionEnabled = YES;
}

// 스테이터스 바 스타일 메소드
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

-(IBAction)showDatePicker {
    self.datePicker.hidden = NO;
//    [_datePicker addTarget:self
//                    action:@selector(LabelTitle:)
//          forControlEvents:UIControlEventValueChanged];
}

//-(void)LabelTitle:(id)sender {
//    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
//    dateFormat.dateStyle=NSDateFormatterMediumStyle;
//    [dateFormat setDateFormat:@"MM/dd/yyyy"];
//    NSString *str = [NSString stringWithFormat:@"%@",[dateFormat  stringFromDate:_datePicker.date]];
//    
//    UILabel *myLabel = [[UILabel alloc] init];
//    myLabel.frame = CGRectMake(50, 50, 150, 60);
//    myLabel.text = str;
//    myLabel.backgroundColor = [UIColor yellowColor];
//    [self.view addSubview:myLabel];
//}


// 네비게이션 Pop
- (void)onTouchUpToNextPage:(UIButton *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark - LoginManager Delegate
- (void)didSignUpWithEmail:(PCSignUpResult)result {
    
}

#pragma mark - TextField Delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if ( [textField isEqual:_birthdayTextField] ) {
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ( [textField isKindOfClass:[UITextField class]] ) {
        [textField endEditing:YES];
    }
    return YES;
}

@end
