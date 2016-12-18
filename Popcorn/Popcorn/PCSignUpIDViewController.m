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
#import "PCUserInformation.h"
#import "PCUserInfoValidation.h"
#import "PCNetworkParamKey.h"

#import "PCMainViewController.h"
#import "PCSignInViewController.h"

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

// 회원가입폼에 대한 유효성 검사값 저장 변수
@property (nonatomic) BOOL isValidID;
@property (nonatomic) BOOL isValidPW;
@property (nonatomic) BOOL isValidNick;
@property (nonatomic) BOOL isValidEmail;
@property (nonatomic) BOOL isValidBirth;

//
@property (nonatomic) UIDatePicker *datePicker;
@property (weak, nonatomic) UITextField *activeField;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UIImageView *addImageView;

@end

@implementation PCSignUpIDViewController

#pragma mark - Init
- (void)viewDidLoad {
    [super viewDidLoad];
    
#ifdef DEBUG
    [self initTestSetting];
#endif
    self.loginManager = [[PCLoginManager alloc] init];
    self.loginManager.delegate = self;
    
    [self makeNavigationView];
    [self registNotification];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
#ifndef DEBUG
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"PCSignUpIDViewController"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
#endif
}

- (void)initTestSetting {
    self.idTextField.text = @"giftbot";
    self.pwTextField.text = @"giftbot1";
    self.rePWTextField.text = @"giftbot1";
    self.nickTextField.text = @"giftbot";
    self.emailTextField.text = @"itperson@naver.com";
    self.birthdayTextField.text = @"1984-08-04";
    
    self.isValidID = YES;
    self.isValidPW = YES;
    self.isValidEmail = YES;
    self.isValidNick = YES;
    self.isValidBirth = YES;
}


#pragma mark - makeCustomView
- (void)makeNavigationView {
    [self.navigationController setNavigationBarHidden:YES];
    
    PCLoginNaviView *viewNavi = [[PCLoginNaviView alloc] initWithType:LoginNaviBarTypePreve andViewController:self];
    [viewNavi.prevButton addTarget:self action:@selector(onTouchUpToNextPage:) forControlEvents:UIControlEventTouchUpInside];
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
    NSString *dateString = [NSString stringWithFormat:@"%@", [dateFormat stringFromDate:_datePicker.date]];
    
    self.birthdayTextField.text = dateString;
}

- (IBAction)requestSignUp:(UIButton *)button {
    // 수정필요 : 가입 조건 미충족 시 바로 화면에 보여줄 수 있도록 처리 필요
    if (_isValidID && _isValidPW && _isValidEmail && _isValidBirth && _isValidNick) {
        NSString *gender = @"M";
        if (_genderSegment.selectedSegmentIndex == 1)
            gender = @"W";
        
        NSDictionary *form = @{SignUpIDKey:_idTextField.text,
                               SignUpPasswordKey:_pwTextField.text,
                               SignUpConfirmPWKey:_rePWTextField.text,
                               SignUpEmailKey:_emailTextField.text,
                               SignUpNicknameKey:_nickTextField.text,
                               SignUpBirthdayKey:_birthdayTextField.text,
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
    }
    else if (textField == _rePWTextField) {
        self.isValidPW = NO;
        BOOL match = [text isEqualToString:_pwTextField.text];
        
        if (match && textLength >= 8)
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
- (void)didSignUpWithID:(PCSignUpResult)statusCode andResponseObject:(NSDictionary *)responseObject {
    if (statusCode == PCSignUpSuccess) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"입력하신 Email로 인증코드를 발송하였습니다"
                                                                                 message:nil
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        
        PCSignUpIDViewController *weakSelf = self;
        UIAlertAction *switchToSignInView;
        switchToSignInView = [UIAlertAction actionWithTitle:@"확인"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * _Nonnull action) {
                                                        PCSignInViewController *signInVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SignInViewController"];
                                                        [weakSelf.navigationController showViewController:signInVC sender:weakSelf];
                                                    }];
        [alertController addAction:switchToSignInView];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else if (statusCode == PCSignUpServerError) {
        alertLog(@"서버 오류 발생");
    }
    else if (statusCode == PCSignUpFailed) {
        if (responseObject[@"email"] != nil) {
            alertLog(@"중복된 Email이 있거나 잘못 입력하셨습니다");
        }
        else if (responseObject[@"username"] != nil) {
            alertLog(@"중복된 ID가 있거나 잘못 입력하셨습니다");
        }
        else if (responseObject[@"password1"]) {
            alertLog(@"패스워드를 다시 입력해주시기 바랍니다");
        }
        else {
            alertLog(@"회원가입 양식에 맞지 않거나 중복된 내용이 존재합니다");
        }
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
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.allowsEditing = YES;
    picker.delegate = self;
    
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *pickedImage = info[UIImagePickerControllerEditedImage];
    if (pickedImage == nil) {
        pickedImage = info[UIImagePickerControllerOriginalImage];
    }

    NSData *imageData = UIImageJPEGRepresentation(pickedImage, 1.0);
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    [userDefault setObject:imageData forKey:@"ImageData"];
    
    self.profileImageView.image = pickedImage;
    self.profileImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [picker dismissViewControllerAnimated:YES completion:^{}];
    [self.addImageView setHidden:YES];
}


#pragma mark -
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    dLog(@" ");
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidHideNotification object:nil];
}

@end
