//
//  ViewController.m
//  VideoVR
//
//  Created by 汪星能 on 16/4/29.
//  Copyright © 2016年 汪星能. All rights reserved.
//

#import "RootViewController.h"
#import "VideoViewController.h"
#import "PhotoViewController.h"

@interface RootViewController () <UITextFieldDelegate>
@property (strong, nonatomic) NSString *vrURL;
@property (strong, nonatomic) UITextField *urlField;
@end

@implementation RootViewController

-(void)viewDidAppear:(BOOL)animated {
    self.title = @"首页";
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)viewWillAppear:(BOOL)animated {
//    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
//        SEL selector = NSSelectorFromString(@"setOrientation:");
//        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
//        [invocation setSelector:selector];
//        [invocation setTarget:[UIDevice currentDevice]];
//        int val = UIInterfaceOrientationMaskPortrait;
//        [invocation setArgument:&val atIndex:2];
//        [invocation invoke];
//    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *photoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [photoBtn setTitle:@"VR图片" forState:UIControlStateNormal];
    photoBtn.backgroundColor = [UIColor orangeColor];
    photoBtn.frame = CGRectMake(20, 80, 70, 44);
    [photoBtn addTarget:self action:@selector(handlePhotoBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:photoBtn];
    photoBtn.hidden = YES;
    
    _urlField = [[UITextField alloc] init];
    _urlField.delegate = self;
    _urlField.layer.borderWidth = 1;
    _urlField.layer.borderColor = [UIColor blackColor].CGColor;
    _urlField.placeholder = @"在线VR视频地址，不输入即播放默认视频";
    _urlField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _urlField.frame = CGRectMake(20, 20, [[UIScreen mainScreen] bounds].size.width-40, 44);
    [self.view addSubview:_urlField];
    
    
    
    UIButton *videoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [videoBtn setTitle:@"在线视频" forState:UIControlStateNormal];
    videoBtn.backgroundColor = [UIColor orangeColor];
    videoBtn.frame = CGRectMake(120, 80, 100, 44);
    videoBtn.tag = 100;
    [videoBtn addTarget:self action:@selector(handleVideoBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:videoBtn];
    
    UIButton *videoBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [videoBtn1 setTitle:@"本地视频" forState:UIControlStateNormal];
    videoBtn1.backgroundColor = [UIColor orangeColor];
    videoBtn1.frame = CGRectMake(120, 140, 100, 44);
    videoBtn1.tag = 200;
    [videoBtn1 addTarget:self action:@selector(handleVideoBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:videoBtn1];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    _vrURL = textField.text;
    [textField becomeFirstResponder];
    return YES;
}



- (void)handlePhotoBtn {
    
    PhotoViewController *photoVC = [[PhotoViewController alloc] init];
    [self.navigationController pushViewController:photoVC animated:YES];
}


- (void)handleVideoBtn:(UIButton *)btn {
    //0表示本地视频，1表示在线视频
    int mode = 0;
    if (btn.tag == 100) {
        mode = 1;
    }
    
    VideoViewController *videoVC;
    if (_urlField.text && _urlField.text.length) {
        videoVC = [[VideoViewController alloc] initWithURL:_urlField.text];
    } else {
        videoVC = [[VideoViewController alloc] initWithVideoMode:mode];
    }
    
    [self.navigationController pushViewController:videoVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
