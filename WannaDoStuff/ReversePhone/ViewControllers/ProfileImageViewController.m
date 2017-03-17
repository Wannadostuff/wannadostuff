//
//  ProfileImageViewController.m
//  ReversePhone
//
//  Created by Mac on 5/12/16.
//  Copyright © 2016 returnzero. All rights reserved.
//

#import "ProfileImageViewController.h"
#import "AsyncImageView.h"

@interface ProfileImageViewController ()

@property (weak, nonatomic) IBOutlet AsyncImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UIView *profileImageContainer;

@end

@implementation ProfileImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.profileImageContainer.layer.masksToBounds = YES;
    self.profileImageView.clipsToBounds = YES;
    self.profileImageView.crossfadeDuration = 0.0;
    self.profileImageContainer.layer.cornerRadius = self.profileImageContainer.frame.size.width / 2;
    self.profileImageContainer.layer.borderWidth = 3.f;
    self.profileImageContainer.layer.borderColor = [UIColor greenColor].CGColor;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.profileImageView.imageURL = [NSURL URLWithString:self.imageURL];
}

- (IBAction)closeButtonClicked:(id)sender {
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.profileImageContainer.layer.cornerRadius = self.profileImageContainer.frame.size.width / 2;
}

@end
