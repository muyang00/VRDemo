//
//  PhotoViewController.m
//  VideoVR
//
//  Created by 汪星能 on 16/4/30.
//  Copyright © 2016年 汪星能. All rights reserved.
//

#import "PhotoViewController.h"
#import "GCSPanoramaView.h"

@interface PhotoViewController () <GCSWidgetViewDelegate>
{
    BOOL hadInit;
    BOOL vrMode;
}
@property (strong, nonatomic) GCSPanoramaView *panoramaView;
@property (strong, nonatomic) UIButton *backBtn;
@property (strong, nonatomic) UIButton *vrButon;
@end

@implementation PhotoViewController

- (void)dealloc
{
    _panoramaView = nil;
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



-(void)viewDidAppear:(BOOL)animated {
    self.title = @"照片VR";
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        hadInit = NO;
        vrMode = YES;
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
    
    self.view.backgroundColor = [UIColor blackColor];
    
    [self performSelector:@selector(initPanoramaView) withObject:nil afterDelay:0.3];
}

- (void)initPanoramaView {
    if (!hadInit) {
        hadInit = YES;
        
        _panoramaView = [[GCSPanoramaView alloc] initWithFrame:self.view.bounds];
        _panoramaView.delegate = self;
        _panoramaView.enableFullscreenButton = NO;
        _panoramaView.enableCardboardButton = NO;
        [_panoramaView loadImage:[UIImage imageNamed:@"andes.jpg"]
                          ofType:kGCSPanoramaImageTypeStereoOverUnder];
        [self.view addSubview:_panoramaView];
        
        [_panoramaView setValue:@YES forKey:@"vrModeEnabled"];
        [_panoramaView setValue:@YES forKey:@"isFullscreen"];
        [_panoramaView setValue:@3 forKey:@"startOrientation"];
        [_panoramaView setValue:@YES forKey:@"needsResize"];
        id watermarkButton = [_panoramaView valueForKey:@"watermarkButton"];
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


- (void)backViewController {
    _panoramaView = nil;
    
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
                                       withObject:@(UIInterfaceOrientationPortrait)];
    }
    
    [self performSelector:@selector(goBack) withObject:nil afterDelay:0.3];
    
    
}

- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)vrModeChanged {
    if (vrMode) {
        [_vrButon setTitle:@"分镜模式" forState:UIControlStateNormal];
        [_panoramaView setValue:@NO forKey:@"vrModeEnabled"];
        [_panoramaView setValue:@YES forKey:@"isFullscreen"];
        [_panoramaView setValue:@3 forKey:@"startOrientation"];
        [_panoramaView setValue:@YES forKey:@"needsResize"];
    } else {
        [_vrButon setTitle:@"全景模式" forState:UIControlStateNormal];
        [_panoramaView setValue:@YES forKey:@"vrModeEnabled"];
        [_panoramaView setValue:@YES forKey:@"isFullscreen"];
        [_panoramaView setValue:@3 forKey:@"startOrientation"];
        [_panoramaView setValue:@YES forKey:@"needsResize"];
    }
    vrMode = !vrMode;
}


/**
 * Called when the user taps the widget view. This corresponds to the Cardboard viewer's trigger
 * event.
 */
- (void)widgetViewDidTap:(GCSWidgetView *)widgetView {

    
}

/** Called when the widget view's display mode changes. See |GCSWidgetDisplayMode|. */
- (void)widgetView:(GCSWidgetView *)widgetView
didChangeDisplayMode:(GCSWidgetDisplayMode)displayMode {
    
}

/** Called when the content is successfully loaded. */
- (void)widgetView:(GCSWidgetView *)widgetView didLoadContent:(id)content {
    
}

/** Called when there is an error loading content in the widget view. */
- (void)widgetView:(GCSWidgetView *)widgetView didFailToLoadContent:(id)content withErrorMessage:(NSString *)errorMessage {
    
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
