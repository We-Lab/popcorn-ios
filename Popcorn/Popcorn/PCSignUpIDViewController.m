//
//  PCSignUpViewController.m
//  Popcorn
//
//  Created by giftbot on 2016. 11. 27..
//  Copyright © 2016년 giftbot. All rights reserved.
//

#import "PCSignUpIDViewController.h"

//#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>

#import "PCLoginNaviView.h"
#import "PCMainViewController.h"
#import "PCUserInformation.h"
#import "PCUserInfoValidation.h"
#import "PCNetworkParamKey.h"




@interface PCSignUpIDViewController () <UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property PCLoginManager *loginManager;
@property (weak, nonatomic) IBOutlet UIView *fieldLayoutView;

// 회원가입폼 변수
@property (weak, nonatomic) IBOutlet UITextField *idTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwTextField;
@property (weak, nonatomic) IBOutlet UITextField *rePWTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *nickTextField;
@property (weak, nonatomic) IBOutlet UITextField *birthdayTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *genderSegment;
@property (nonatomic) UIDatePicker *datePicker;

@property UITextField *activeField;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UIImageView *addImageView;

// 회원가입폼에 대한 유효성 검사값 저장 변수
@property (nonatomic) BOOL isValidID;
@property (nonatomic) BOOL isValidPW;
@property (nonatomic) BOOL isValidNick;
@property (nonatomic) BOOL isValidEmail;
@property (nonatomic) BOOL isValidBirth;

@end

@implementation PCSignUpIDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
#ifdef DEBUG
//    [self initTestSetting];
#endif
    self.loginManager = [[PCLoginManager alloc] init];
    self.loginManager.delegate = self;
    
    [self makeNavigationView];
    [self enableUserInteractionToBirthdayTextField];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self registNotification];
    
#ifndef DEBUG
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"PCSignUpIDViewController"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
#endif
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self unregistNotification];
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

// 네비게이션 Pop
- (void)onTouchUpToNextPage:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - DatePicker for userBirthday
-(IBAction)showDatePicker {
    
    self.birthdayTextField.text = nil;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"\n\n\n\n\n\n\n\n\n\n" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIView *dateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, alert.view.frame.size.width, 250)];
    [dateView setBackgroundColor:[UIColor clearColor]];
    [alert.view addSubview:dateView];
    
    self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, alert.view.frame.size.width, 200)];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    [self.datePicker addTarget:self action:@selector(LabelTitle:) forControlEvents:UIControlEventValueChanged];
    [dateView addSubview:self.datePicker];
    
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:^{
        
    }];

}

-(void)LabelTitle:(id)sender {
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    dateFormat.dateStyle = NSDateFormatterMediumStyle;
    dateFormat.dateFormat = @"yyyy-MM-dd";
    NSString *dateString = [NSString stringWithFormat:@"%@",
                     [dateFormat stringFromDate:_datePicker.date]];
    
    self.birthdayTextField.text = dateString;
}

- (IBAction)requestSignUp:(UIButton *)button {
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

- (IBAction)requestSignUpWithFacebook:(UIButton *)button {
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                  initWithGraphPath:@"/me"
                                  parameters:@{ @"fields": @"id,name,email,birthday,gender,location,picture",}
                                  HTTPMethod:@"GET"];
    
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        if (error) {
            //
        }
        else {
            sLog(result);
            if ([result objectForKey:@"id"]) {
                NSLog(@"User id : %@",[result objectForKey:@"id"]);
            }
            if ([result objectForKey:@"email"]) {
                NSLog(@"Email: %@",[result objectForKey:@"email"]);
            }
            if ([result objectForKey:@"name"]) {
                NSLog(@"First Name : %@",[result objectForKey:@"name"]);
            }
        }
    }];
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
        NSLog(@"아이디 유효성 검사 : %d", _isValidID);
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
    else if (textField == _nickTextField){
        self.isValidNick = NO;
        if (textLength >= 4 && textLength <= 10) {
            self.isValidNick = [PCUserInfoValidation isValidNick:text];
        }
    }
    else if (textField == _birthdayTextField){
        self.isValidBirth = NO;
        self.isValidBirth = [PCUserInfoValidation isValidBirthday:_birthdayTextField.text];
    }
    
    if (_isValidID && _isValidPW && _isValidNick && _isValidEmail && _isValidBirth) {
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
        [[PCUserInformation userInfo] hasUserSignedIn:token];
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

- (void)textFieldDidBeginEditing:(UITextField *)textField{

    self.activeField = textField;
    self.activeField.delegate = self;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    self.activeField = nil;
}


#pragma mark - KeyBoard Notification
-(void) registNotification{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

-(void) unregistNotification{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidHideNotification object:nil];
}

- (void)keyboardWasShown:(NSNotification*)keyboardNotification{
    
    NSDictionary* info = [keyboardNotification userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    CGRect mainViewRect = self.view.frame;
    CGFloat otherHeight = mainViewRect.size.height - keyboardSize.height;
    
    mainViewRect.origin.y = (otherHeight/3)*2 - (self.fieldLayoutView.frame.origin.y + self.activeField.frame.origin.y);
    
    if ((otherHeight/3)*2 < (self.fieldLayoutView.frame.origin.y + self.activeField.frame.origin.y)) {
        
        self.view.frame = mainViewRect;
    }
}

- (void)keyboardWillBeHidden:(NSNotification*)keyboardNotification{

    CGRect mainViewRect = self.view.frame;
    mainViewRect.origin.y = 0;
    self.view.frame = mainViewRect;
}

- (IBAction)resignOnTap:(id)sender {

    [self.activeField resignFirstResponder];
}

#pragma mark - Profile Image Picker
- (IBAction)profileImageSelect:(id)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    picker.sourceType = sourceType;
    picker.delegate = self;
    picker.allowsEditing = YES;
    
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    UIImage *pickedImage = info[UIImagePickerControllerEditedImage];
    
    if (pickedImage == nil) {
        pickedImage = info[UIImagePickerControllerOriginalImage];
    }
    
    if (pickedImage == nil) {
        NSLog(@"사진이 없습니다.");
        return;
    }
    
    
    //Binary data -------------------------------
    
    NSData *imageData = UIImageJPEGRepresentation(pickedImage, 1.0);
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    [userDefault setObject:imageData forKey:@"ImageData"];
    
    [userDefault synchronize];
    
    // Data save End ---------------------------
    
    
    self.profileImageView.image = pickedImage;
    self.profileImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    [self.addImageView setHidden:YES];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    dLog(@" ");
}

@end
