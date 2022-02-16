//
//  ZZWebViewController.m
//  ZZKit
//
//  Created by donews on 2019/4/29.
//  Copyright © 2019年 donews. All rights reserved.
//

#import "ZZWebViewController.h"
#import <WebKit/WebKit.h>

@interface ZZWebViewController ()<WKNavigationDelegate,WKUIDelegate>

@property (nonatomic, strong) WKWebView *webview;

@end

@implementation ZZWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    [self.webview loadRequest:request];
    [self.view addSubview:self.webview];

    
}


- (void)webView:(WKWebView*)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge*)challenge completionHandler:(void(^)(NSURLSessionAuthChallengeDisposition disposition,NSURLCredential *credential))completionHandler {
    
    if([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        if([challenge previousFailureCount] ==0){
            NSURLCredential*credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
            completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
        }else{
            completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge,nil);
        }
        
    }else{
        completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge,nil);
    }
}

   


- (WKWebView *)webview {
    if (_webview == nil) {
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        _webview = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:configuration];
        _webview.navigationDelegate = self;
        _webview.UIDelegate = self;
    }
    return _webview;
}

@end
