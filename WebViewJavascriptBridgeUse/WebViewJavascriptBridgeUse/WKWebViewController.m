//
//  WKWebViewController.m
//  WebViewJavascriptBridgeUse
//
//  Created by 云联智慧 on 2019/5/13.
//  Copyright © 2019 云联智慧. All rights reserved.
//

#import "WKWebViewController.h"
#import <WebKit/WebKit.h>
@interface WKWebViewController ()<WKNavigationDelegate,WKUIDelegate>
@property(nonatomic, readwrite) WKWebView *webView;
@property WKWebViewJavascriptBridge *webViewBridge;
@end

@implementation WKWebViewController
- (WKWebView *)webView
{
    if (_webView)
    {
        return _webView;
    }
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    configuration.userContentController = [WKUserContentController new];
    
    WKPreferences *preferences = [WKPreferences new];
    preferences.javaScriptCanOpenWindowsAutomatically = YES;
    preferences.minimumFontSize = 36.0;
    configuration.preferences = preferences;
        
    _webView = [[WKWebView alloc] initWithFrame:self.view.frame configuration:configuration];
    NSString *urlStr = [[NSBundle mainBundle] pathForResource:@"index.html" ofType:nil];
    NSString *localHtml = [NSString stringWithContentsOfFile:urlStr encoding:NSUTF8StringEncoding error:nil];
    NSURL *fileURL = [NSURL fileURLWithPath:urlStr];
    [_webView loadHTMLString:localHtml baseURL:fileURL];
    _webView.UIDelegate = self;
    return _webView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.webView];
    _webViewBridge = [WKWebViewJavascriptBridge bridgeForWebView:self.webView];
    [_webViewBridge setWebViewDelegate:self];
    [self registerNativeFunctions];
}
- (void)registerNativeFunctions
{
    [self registGetDeviceNameFunction];
    [self registJSCallOCFunction];
}
#pragma mark 获取设备名称
/** 获取设备名称 */
-(void)registGetDeviceNameFunction
{
    //这里注册的oc方法一定要跟js端写的一致
    [_webViewBridge registerHandler:@"getDeviceName" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSString *deviceName = [[UIDevice currentDevice] name];
        //这里是回调，可以传值给js端
        responseCallback(deviceName);
    }];
}
#pragma mark 测试js调用OC时传入参数并回传
-(void)registJSCallOCFunction
{
    //这里注册的oc方法一定要跟js端写的一致
    [_webViewBridge registerHandler:@"postParamertersToOC" handler:^(id data, WVJBResponseCallback responseCallback) {
        //参数类型取决于js端传递的类型
        
        NSLog(@"data class = %@",[data class]);
        NSLog(@"data  = %@",data);
        NSString *backStr = @"接收到js传的参数了,我现在是OC端回传给你信息";
        responseCallback(backStr);
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
