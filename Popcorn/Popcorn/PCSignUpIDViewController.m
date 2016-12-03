//
//  PCSignUpViewController.m
//  Popcorn
//
//  Created by giftbot on 2016. 11. 27..
//  Copyright © 2016년 giftbot. All rights reserved.
//

#import "PCSignUpIDViewController.h"
#import "PCLoginNaviView.h"
#import "PCMainViewController.h"
#import "PCUserInformation.h"
#import "PCUserInfoValidation.h"
#import "PCNetworkParamKey.h"


@interface PCSignUpIDViewController () <UITextFieldDelegate>

@property PCLoginManager *loginManager;

// 회원가입폼 변수
@property (weak, nonatomic) IBOutlet UITextField *idTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwTextField;
@property (weak, nonatomic) IBOutlet UITextField *rePWTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *birthdayTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *genderSegment;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

// 회원가입폼에 대한 유효성 검사값 저장 변수
@property (nonatomic) BOOL isValidID;
@property (nonatomic) BOOL isValidPW;
@property (nonatomic) BOOL isValidEmail;
@property (nonatomic) BOOL isValidBirth;

@end

@implementation PCSignUpIDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
#ifdef DEBUG
    [self initTestSetting];
#endif
    self.loginManager = [[PCLoginManager alloc] init];
    self.loginManager.delegate = self;
    
    [self makeNavigationView];
    [self enableUserInteractionToBirthdayTextField];
}


- (void)initTestSetting {
    self.idTextField.text = @"testuser";
    self.pwTextField.text = @"testuser1";
    self.rePWTextField.text = @"testuser1";
    self.emailTextField.text = @"testemail@test.com";
    self.birthdayTextField.text = @"2000-01-01";
    
    self.isValidID = YES;
    self.isValidPW = YES;
    self.isValidEmail = YES;
    self.isValidBirth = YES;
}

#pragma mark - makeCustomView
- (void)makeNavigationView {
    // 
    PCLoginNaviView *viewNavi = [[PCLoginNaviView alloc] initWithType:LoginNaviBarTypePreve ViewController:self target:self action:@selector(onTouchUpToNextPage:)];
    sLog([viewNavi class]);
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)enableUserInteractionToBirthdayTextField {
    _birthdayTextField.userInteractionEnabled = YES;
}

// 스테이터스 바 스타일 메소드
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


#pragma mark - DatePicker for userBirthday
-(IBAction)showDatePicker {
    self.datePicker.hidden = NO;
    self.datePicker.backgroundColor = [UIColor whiteColor];
    
    [_datePicker addTarget:self
                    action:@selector(LabelTitle:)
          forControlEvents:UIControlEventValueChanged];
}

-(void)LabelTitle:(id)sender {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    dateFormat.dateStyle = NSDateFormatterMediumStyle;
    dateFormat.dateFormat = @"yyyy-MM-dd";
    NSString *dateString = [NSString stringWithFormat:@"%@",
                     [dateFormat stringFromDate:_datePicker.date]];
    
    self.birthdayTextField.text = dateString;
    self.datePicker.hidden = YES;
}


// 네비게이션 Pop
- (void)onTouchUpToNextPage:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)requestSignUp:(id)sender {
    // 수정필요 : 가입 조건 미충족 시 바로 화면에 보여줄 수 있도록 처리 필요
    
    if (_isValidID && _isValidPW && _isValidEmail && _isValidBirth) {
        NSString *gender = @"M";
        if (_genderSegment.selectedSegmentIndex == 1)
            gender = @"W";
        
        NSDictionary *form = @{SignUpIDKey:_idTextField.text,
                               SignUpPasswordKey:_pwTextField.text,
                               SignUpConfirmPWKey:_rePWTextField.text,
                               SignUpEmailKey:_emailTextField.text,
                               SignUpBirthdayKey:_birthdayTextField.text,
                               SignUpPhoneNumberKey:@"000-0000-0000",
                               SignUpGenderKey:gender};
        sLog(form);
        [self.loginManager signUpWithID:form];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *text;
    if (range.length == 0) {
        text = [textField.text stringByAppendingString:string];
    }
    else if (range.length == 1) {    // Backspace
        text = [textField.text substringToIndex:range.location];
    }
    else {     // Return Key
        return YES;
    }
    
    NSInteger textLength = text.length;
    
    if (textField == _idTextField) {
        self.isValidID = NO;
        if (textLength >= 4 && textLength <= 10)
            self.isValidID = [PCUserInfoValidation isValidID:text];
    }
    else if (textField == _rePWTextField) {
        self.isValidPW = NO;
        BOOL match = [_rePWTextField.text isEqualToString:_pwTextField.text];
        
        if (match && textLength >= 6)
            self.isValidPW = [PCUserInfoValidation isValidPW:text];
    }
    else if (textField == _emailTextField){
        self.isValidEmail = NO;
        if (textLength >= 8) {
            self.isValidEmail = [PCUserInfoValidation isValidEmail:text];
        }
    }
    else if (textField == _birthdayTextField){
        self.isValidBirth = NO;
        self.isValidBirth = [PCUserInfoValidation isValidBirthday:_birthdayTextField.text];
    }
    
    if (_isValidID && _isValidPW && _isValidEmail && _isValidBirth) {
        // 로그인 버튼 활성화
    }
    else {
        // 로그인 버튼 비활성화
    }

    return YES;
}

#pragma mark - LoginManager Delegate
- (void)didSignInWithID:(NSString *)token {
    if (token) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        PCMainViewController *mainView = [storyboard instantiateInitialViewController];
        [self.navigationController pushViewController:mainView animated:YES];
        
        // 키체인에 토큰값 저장
        [[PCUserInformation userInfo] saveUserToken:token];
    }
    else {
        alertLog(@"유저정보가 올바르지 않습니다.");
    }
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    dLog(@" ");
}

@end
