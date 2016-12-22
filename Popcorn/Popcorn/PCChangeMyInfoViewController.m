//
//  PCChangeMyInfoViewController.m
//  Popcorn
//
//  Created by chaving on 2016. 12. 21..
//  Copyright © 2016년 giftbot. All rights reserved.
//

#import "PCChangeMyInfoViewController.h"

#import "PCInitialViewController.h"
#import "PCUserInfoManager.h"
#import "PCUserInformation.h"
#import "PCChangeInfoTextViewController.h"
#import "KeychainItemWrapper.h"

@interface PCChangeMyInfoViewController () <UITableViewDelegate, UITableViewDataSource,UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@end

@implementation PCChangeMyInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (section == 0) {
        return 3;
    }
    
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InfoCell" forIndexPath:indexPath];
    
    NSArray *cellBlueArray = @[@"프로필 사진 변경",@"닉네임 변경",@"전화번호 변경"];
    NSArray *cellRedArray = @[@"비밀번호 변경",@"로그아웃"];
    
    if (indexPath.section == 0) {
        cell.textLabel.text = cellBlueArray[indexPath.row];
        
    }else{
        cell.textLabel.text = cellRedArray[indexPath.row];
        
        if (indexPath.row == 0) {
            cell.textLabel.textColor = [UIColor colorWithRed:29.0/255.0 green:140.0/255.0 blue:249.0/255.0 alpha:1];
        }else if (indexPath.row == 1) {
            cell.textLabel.textColor = [UIColor redColor];
        }
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            [self profileImageSelect];
        }else if (indexPath.row == 1){
            NSDictionary *temp = @{@"type":@"ChangeNick"};
            [self moveToMovieDetailView:temp];
        }else if (indexPath.row == 2){
            NSDictionary *temp = @{@"type":@"ChangePhoneNumber"};
            [self moveToMovieDetailView:temp];
        }
        
        
    }else if (indexPath.section == 1) {
    
        if (indexPath.row == 0) {
            NSDictionary *temp = @{@"type":@"ChangePassword"};
            [self moveToMovieDetailView:temp];
        }else if (indexPath.row == 1) {
            [self requestSignOut];
        }
    }
}

- (void)profileImageSelect{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.allowsEditing = YES;
    picker.delegate = self;
    
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {

    UIImage *image = nil;
    
    if (info[UIImagePickerControllerEditedImage]) {
        image = info[UIImagePickerControllerEditedImage];
    } else {
        image = info[UIImagePickerControllerOriginalImage];
    }
    
    [picker dismissViewControllerAnimated:YES
                               completion:^{
                                   [[PCUserInfoManager userInfoManager] changeUserProfileImage:image withCompletionHandler:^(BOOL isSuccess) {
                                       [[PCUserInformation sharedUserData] changeProfileImage:image];
                                   }];
                               }];
}

#pragma mark - Configure Segue
- (void)moveToMovieDetailView:(id)sender {
    [self performSegueWithIdentifier:@"ToMoveChangeInfoSegue" sender:sender];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"ToMoveChangeInfoSegue"]) {
        
        if ([[sender objectForKey:@"type"] isEqualToString:@"ChangeNick"]) {
            
            PCChangeInfoTextViewController *vc = (PCChangeInfoTextViewController *)segue.destinationViewController;
            vc.type = ChangeNickname;
            
        }else if ([[sender objectForKey:@"type"] isEqualToString:@"ChangePhoneNumber"]) {
            
            PCChangeInfoTextViewController *vc = (PCChangeInfoTextViewController *)segue.destinationViewController;
            vc.type = ChangePhoneNumber;
            
        }else if ([[sender objectForKey:@"type"] isEqualToString:@"ChangePassword"]) {
            
            PCChangeInfoTextViewController *vc = (PCChangeInfoTextViewController *)segue.destinationViewController;
            vc.type = ChangePassword;
        }
    }
}

#pragma mark - Sign Out Action
- (void)requestSignOut{
//    [[PCUserInformation sharedUserData] hasUserSignedOut];

    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"UserSignedIn"];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"UserInformationAsDictionary"];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    PCInitialViewController *initialView = [storyboard instantiateInitialViewController];
    
    [self presentViewController:initialView animated:YES completion:^{
        [UIApplication sharedApplication].keyWindow.rootViewController = initialView;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
