//
//  ProfileViewController.m
//  ReversePhone
//
//  Created by Mac on 23/05/2016.
//  Copyright © 2016 returnzero. All rights reserved.
//

#import "ProfileViewController.h"
#import "AppDelegate.h"
#import "AsyncImageView.h"
#import "Shared.h"
#import "UserData.h"
#import "WebServicesClient.h"
#import "MBProgressHUD.h"

@interface ProfileViewController() <UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIView *photoContainer;
@property (weak, nonatomic) IBOutlet AsyncImageView *photoImage;
@property (nonatomic, strong) UserData *userData;
@end

@implementation ProfileViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.photoContainer.layer.masksToBounds = YES;
    self.photoImage.clipsToBounds = YES;
    self.photoContainer.layer.cornerRadius = self.photoContainer.frame.size.width / 2;
    self.photoContainer.layer.borderWidth = 3.f;
    self.photoContainer.layer.borderColor = [UIColor redColor].CGColor;
    
    _btn_save.layer.cornerRadius = 10;
    _btn_save.clipsToBounds = YES;
    
    _userData = [[UserData alloc] init];
    [_userData getUserData];
    
    self.lbl_username.text = _userData.userName;
    self.txt_firstname.text = _userData.firstName;
    self.txt_lastname.text = _userData.lastName;
    self.txt_email.text = _userData.userEmail;
    
    NSString *photoUrl = _userData.photoURL;
    self.photoImage.imageURL = [NSURL URLWithString: photoUrl];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    UITapGestureRecognizer *imagePickTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageOnclick)];
    [self.photoImage addGestureRecognizer:imagePickTap];
    
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [appDelegate.slideViewController setSideMenuEnabled:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [appDelegate.slideViewController setSideMenuEnabled:NO];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)imageOnclick {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take From Camera", @"Take From Photo Album", nil];
    actionSheet.tag = 1;
    [actionSheet showInView:self.view];
    actionSheet = nil;
}

- (IBAction)saveOnclick:(id)sender {
    
    _userData.firstName = self.txt_firstname.text;
    _userData.lastName = self.txt_lastname.text;
    _userData.userEmail = self.txt_email.text;
    
    [_userData saveUserData];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Updating user profile...";
    
    [[WebServicesClient sharedClient]profileUpdate:self.photoImage.image completion:^(BOOL success, NSDictionary *userData) {
    }];
    [hud hide:YES];
}

#pragma mark - action sheet
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if(actionSheet.tag == 1) {
        if(buttonIndex == 0) {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            
            [self presentViewController:picker animated:YES completion:nil];
        } else if(buttonIndex == 1) {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            
            [self presentViewController:picker animated:YES completion:nil];
        }
    }
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(nonnull NSDictionary<NSString *,id> *)info
{
    UIImage * chosenImage = info[UIImagePickerControllerEditedImage];
    
    CGFloat angle;
    switch (chosenImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            angle =  M_PI;
            break;
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            angle = -M_PI_2;
            break;
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            angle = M_PI_2;
            break;
        default:
            angle = 0;
            break;
    }
    
    UIImage *upImage = [[UIImage alloc] initWithCGImage:chosenImage.CGImage];
    [self.photoImage setImage:[Shared rotateImage:upImage byDegree:angle]];
    
    self.photoChanged = YES;
    [picker dismissViewControllerAnimated:YES
                               completion:nil];
}

@end
