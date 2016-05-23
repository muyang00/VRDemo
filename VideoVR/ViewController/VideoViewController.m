//
//  VideoViewController.m
//  VideoVR
//
//  Created by 汪星能 on 16/5/2.
//  Copyright © 2016年 汪星能. All rights reserved.
//

#import "VideoViewController.h"
#import "GCSVideoView.h"

@interface VideoViewController () <GCSVideoViewDelegate>
{
    BOOL hadInit;
    BOOL vrMode;
    int videoMode;//0表示本地视频，1表示在线视频
}
@property (strong, nonatomic) UIButton *backBtn;
@property (strong, nonatomic) UIButton *vrButon;
@property (strong ,nonatomic) GCSVideoView *videoView;
@property (strong, nonatomic) NSString *vrURL;
@end

@implementation VideoViewController {
    BOOL _isPaused;
}

- (void)dealloc
{
    _backBtn   = nil;
    _vrButon   = nil;
    _videoView = nil;
    _vrURL     = nil;
}

-(void)viewWillAppear:(BOOL)animated {
//    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
//        SEL selector = NSSelectorFromString(@"setOrientation:");
//        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
//        [invocation setSelector:selector];
//        [invocation setTarget:[UIDevice currentDevice]];
//        int val = UIInterfaceOrientationLandscapeRight;
//        [invocation setArgument:&val atIndex:2];
//        [invocation invoke];
//    }
}

- (instancetype)initWithVideoMode:(int)mode
{
    self = [super init];
    if (self) {
        hadInit = NO;
        vrMode = YES;
        videoMode = mode;
    }
    return self;
}

- (instancetype)initWithURL:(NSString *)URL
{
    self = [super init];
    if (self) {
        hadInit = NO;
        vrMode = YES;
        videoMode = 1;
        _vrURL = URL;
    }
    return self;
}


- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscapeRight;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        [[UIDevice currentDevice] performSelector:@selector(setOrientation:)
                                       withObject:@(UIInterfaceOrientationLandscapeRight)];
    }
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self performSelector:@selector(initPanoramaView) withObject:nil afterDelay:0.2];
}


- (void)initPanoramaView {
    
    if (!hadInit) {
        hadInit = YES;
        
        _videoView = [[GCSVideoView alloc] initWithFrame:self.view.bounds];
        _videoView.delegate = self;
        _videoView.enableFullscreenButton = NO;
        _videoView.enableCardboardButton = NO;
        
        _isPaused = NO;
        
        if (videoMode) {
            if (!_vrURL) {
                _vrURL = @"http://115.28.185.242:8088/44.mp4";
            }
            [_videoView loadFromUrl:[NSURL URLWithString:_vrURL]];
        } else {
            NSString *videoPath = [[NSBundle mainBundle] pathForResource:@"congo" ofType:@"mp4"];
            [_videoView loadFromUrl:[[NSURL alloc] initFileURLWithPath:videoPath]];
        }
        
        [self.view addSubview:_videoView];
        
        [_videoView setValue:@YES forKey:@"vrModeEnabled"];
        [_videoView setValue:@YES forKey:@"isFullscreen"];
        [_videoView setValue:@3 forKey:@"startOrientation"];
        [_videoView setValue:@YES forKey:@"needsResize"];
        id watermarkButton = [_videoView valueForKey:@"watermarkButton"];
        [watermarkButton setHidden:YES];
        
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _backBtn.frame = CGRectMake(0, 0, 60, 44);
        _backBtn.backgroundColor = [UIColor orangeColor];
        _backBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        [_backBtn setTitle:@"返回" forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backViewController) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_backBtn];
        
        _vrButon = [UIButton buttonWithType:UIButtonTypeCustom];
        _vrButon.frame = CGRectMake(self.view.bounds.size.width-60, 0, 60, 44);
        _vrButon.backgroundColor = [UIColor orangeColor];
        _vrButon.titleLabel.font = [UIFont systemFontOfSize:11];
        [_vrButon setTitle:@"全景模式" forState:UIControlStateNormal];
        [_vrButon addTarget:self action:@selector(vrModeChanged) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_vrButon];
    }
}

- (void)vrModeChanged {
    if (vrMode) {
        [_vrButon setTitle:@"分镜模式" forState:UIControlStateNormal];
        [_videoView setValue:@NO forKey:@"vrModeEnabled"];
        [_videoView setValue:@YES forKey:@"isFullscreen"];
        [_videoView setValue:@3 forKey:@"startOrientation"];
        [_videoView setValue:@YES forKey:@"needsResize"];
    } else {
        [_vrButon setTitle:@"全景模式" forState:UIControlStateNormal];
        [_videoView setValue:@YES forKey:@"vrModeEnabled"];
        [_videoView setValue:@YES forKey:@"isFullscreen"];
        [_videoView setValue:@3 forKey:@"startOrientation"];
        [_videoView setValue:@YES forKey:@"needsResize"];
    }
    vrMode = !vrMode;
}



#pragma mark - GCSVideoViewDelegate

- (void)widgetViewDidTap:(GCSWidgetView *)widgetView {
    if (_isPaused) {
        [_videoView resume];
    } else {
        [_videoView pause];
    }
    _isPaused = !_isPaused;
}

- (void)widgetView:(GCSWidgetView *)widgetView didLoadContent:(id)content {
    NSLog(@"Finished loading video");
}

- (void)widgetView:(GCSWidgetView *)widgetView
didFailToLoadContent:(id)content
  withErrorMessage:(NSString *)errorMessage {
    NSLog(@"Failed to load video: %@", errorMessage);
}

- (void)videoView:(GCSVideoView*)videoView didUpdatePosition:(NSTimeInterval)position {
    // Loop the video when it reaches the end.
    if (position == videoView.duration) {
        [_videoView seekTo:0];
        [_videoView resume];
    }
}


- (void)backViewController {
    [_videoView stop];
    [_videoView removeFromSuperview];
    _videoView = nil;
    
//    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
//        SEL selector = NSSelectorFromString(@"setOrientation:");
//        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
//        [invocation setSelector:selector];
//        [invocation setTarget:[UIDevice currentDevice]];
//        int val = UIInterfaceOrientationMaskPortrait;
//        [invocation setArgument:&val atIndex:2];
//        [invocation invoke];
//    }
    
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        [[UIDevice currentDevice] performSelector:@selector(setOrientation:)
                                       withObject:@(UIInterfaceOrientationMaskPortrait)];
    }
    
    [self performSelector:@selector(goBack) withObject:nil afterDelay:0.3];
    
    
}

- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
