//
//  WebViewController.m
//  AppDynamicConfig
//
//  Created by 吴丹 on 2023/2/27.
//

#import "WebViewController.h"
#import <WebKit/WebKit.h>

@interface WebViewController ()<WKNavigationDelegate,WKScriptMessageHandler>
@property (nonatomic, strong) WKWebView *wkWebView;
@property (nonatomic, strong) UIProgressView *progressView;
@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.wkWebView = [[WKWebView alloc]initWithFrame:[UIScreen mainScreen].bounds configuration:[[WKWebViewConfiguration alloc] init]];
    self.wkWebView.navigationDelegate = self;
    self.wkWebView.allowsBackForwardNavigationGestures = YES;
    [self.view addSubview:self.wkWebView];
    NSLog(@"%@", self.params);
    if (self.params) {
        NSString *url = self.params[@"url"];
        NSString *urldecode = [url stringByRemovingPercentEncoding];

        [self.wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urldecode]]];
    } else {
        [self.wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]]];
    }
    
}

@end
