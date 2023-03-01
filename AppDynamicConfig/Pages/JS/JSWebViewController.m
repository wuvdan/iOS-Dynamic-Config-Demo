//
//  JSWebViewController.m
//  AppDynamicConfig
//
//  Created by 吴丹 on 2023/2/28.
//

#import "JSWebViewController.h"
#import "Masonry.h"
#import "WeakScriptMessageDelegate.h"
#import "URLSchemeManager.h"
#import "WebStyleModel.h"
#import "MJExtension.h"

@interface JSWebViewController ()<WKNavigationDelegate, WKScriptMessageHandler, WKUIDelegate, UIScrollViewDelegate>
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, assign) BOOL haveAddScriptMsgHandler;
@property (nonatomic, strong) WebStyleModel *styleModel;
@end

@implementation JSWebViewController

- (void)dealloc {
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.webView removeObserver:self forKeyPath:@"title"];
    [self.webView removeObserver:self forKeyPath:@"canGoBack"];
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"action"];
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"style"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.progressView];
    [self.view addSubview:self.webView];
    self.title = @"默认标题";
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
    [self.webView addObserver:self forKeyPath:@"canGoBack" options:NSKeyValueObservingOptionNew context:NULL];
    
    [self.zx_navSubLeftBtn setImage:[[UIImage imageNamed:@"appoint_close"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    self.zx_navSubLeftBtn.hidden = YES;
    
    __weak typeof(self) weakself = self;
    [self zx_leftClickedBlock:^(ZXNavItemBtn * _Nonnull btn) {
        if ([weakself.webView canGoBack]) {
            [weakself.webView goBack];
        } else {
            [weakself.navigationController popViewControllerAnimated:YES];
        }
    }];
    
    [self zx_subLeftClickedBlock:^(ZXNavItemBtn * _Nonnull btn) {
        [weakself.navigationController popViewControllerAnimated:YES];
    }];
    
    self.zx_navTitleColor = [UIColor blackColor];
    self.zx_navSubLeftBtn.tintColor = [UIColor blackColor];
    
    [self setZx_handlePopBlock:^BOOL(ZXNavigationBarController * _Nonnull viewController, ZXNavPopBlockFrom popBlockFrom) {
        return !weakself.styleModel.notSupportGesture && ![weakself.webView canGoBack];
    }];
    
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.mas_equalTo(0);
        make.top.mas_equalTo(self.zx_navBar.mas_bottom);
    }];
    
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(0);
        make.height.mas_equalTo(1);
        make.top.mas_equalTo(self.zx_navBar.mas_bottom);
    }];
    
    [self.view bringSubviewToFront:self.progressView];
}


#pragma mark kvo 监听进度 必须实现此方法 监听的回调
- (void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                      context:(void *)context{
    
    
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(estimatedProgress))]
        && object == self.webView) {
        self.progressView.progress = self.webView.estimatedProgress;
        if (self.webView.estimatedProgress >= 1.0f) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.progressView.progress = 0;
            });
        }
    } else if([keyPath isEqualToString:@"title"]
         && object == self.webView) {
        self.title = self.webView.title;
    } else if ([keyPath isEqualToString:@"canGoBack"]
              && object == self.webView) {
        self.zx_navSubLeftBtn.hidden = ![self.webView canGoBack];
    }  else {
        [super observeValueForKeyPath:keyPath
                             ofObject:object
                               change:change
                              context:context];
    }
}

#pragma mark - WKNavigationDelegate
/* 页面开始加载 */
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"页面开始加载: %@--%@", webView.URL, navigation);
}

/* 开始返回内容 */
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    NSLog(@"开始返回内容: %@--%@", webView.URL, navigation);
}


/* 页面加载完成 */
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"页面加载完成: %@--%@", webView.URL, navigation);
}

/* 页面加载失败 */
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"页面加载失败: %@--%@", webView.URL, navigation);
}

/* 在发送请求之前，决定是否跳转 */
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    //允许跳转
    decisionHandler(WKNavigationActionPolicyAllow);
    //不允许跳转
    //decisionHandler(WKNavigationActionPolicyCancel);
}

/* 在收到响应后，决定是否跳转 */
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
     
    NSLog(@"%@",navigationResponse.response.URL.absoluteString);
    //允许跳转
    decisionHandler(WKNavigationResponsePolicyAllow);
    //不允许跳转
    //decisionHandler(WKNavigationResponsePolicyCancel);
}

- (void)setRemoteURLString:(NSString *)remoteURLString {
    _remoteURLString = remoteURLString;
    NSURL *url = [NSURL URLWithString:remoteURLString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

- (void)setLocalURLString:(NSString *)localURLString {
    _localURLString = localURLString;
    NSURL *url = [NSURL fileURLWithPath:localURLString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

- (WKWebView *)webView {
    if (!_webView) {
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        [config.userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:@"style"];
        [config.userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:@"action"];
        _webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:config];
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
        _webView.allowsBackForwardNavigationGestures = YES;
        _webView.scrollView.delegate = self;
    }
    return _webView;
}

- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] init];
        _progressView.progressTintColor = [UIColor redColor];
    }
    return _progressView;
}

- (void)userContentController:(nonnull WKUserContentController *)userContentController didReceiveScriptMessage:(nonnull WKScriptMessage *)message {
    NSLog(@"====>%@---%@", message.body, message.name);
    if ([message.name isEqualToString:@"action"]) {
        [URLSchemeManager openPageWithURLString:message.body[@"url"] controller:self];
        return;
    }
    
    if ([message.name isEqualToString:@"style"]) {
        self.styleModel = [WebStyleModel mj_objectWithKeyValues:message.body];
        [self setupStyleByModel:self.styleModel];
        return;
    }
}

- (void)setupStyleByModel:(WebStyleModel *)model {
    
    if (!model.showNavigationBar) {
        self.zx_navBar.hidden = YES;
        [self.webView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        
        [self.progressView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.mas_equalTo(0);
            make.height.mas_equalTo(1);
            make.top.mas_equalTo(self.webView.mas_top);
        }];
        
        [self.view bringSubviewToFront:self.progressView];
        
    } else {
        self.zx_navBar.hidden = NO;
        [self.webView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.bottom.mas_equalTo(0);
            make.top.mas_equalTo(self.zx_navBar.mas_bottom);
        }];
        [self.progressView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.mas_equalTo(0);
            make.height.mas_equalTo(1);
            make.top.mas_equalTo(self.zx_navBar.mas_bottom);
        }];
        [self.view bringSubviewToFront:self.progressView];
        
        if (model.scrollNavigationBar) {
            self.zx_navBar.alpha = 0;
        } else {
            self.zx_navBar.alpha = 1;
        }
    }
    
    self.webView.scrollView.bounces = model.notSupportBounces;
}

//- (UIStatusBarStyle)preferredStatusBarStyle {
//    return self.statusBarStyle;
//}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.styleModel.scrollNavigationBar) {
        CGFloat y = scrollView.contentOffset.y;

        CGFloat topHeight = 88;//kWidth(180);
//        if (AfterEqualToIPhoneX) {
//            topHeight -= StatusBarHeight;
//        }

        if (y < 0) {
            self.zx_navBar.alpha = 0;
//            self.statusBarStyle = UIStatusBarStyleDefault;
        } else if (y < topHeight) {
            self.zx_navBar.alpha = 0;
//            self.statusBarStyle = UIStatusBarStyleLightContent;
        } else {
//            self.statusBarStyle = self.baseJSNavigationStyleModel.statusBarBlack ? UIStatusBarStyleDefault : UIStatusBarStyleLightContent;
            self.zx_navBar.alpha = 1;
        }
        
//        self.zx_navBar.backgroundColor = model.bgColor.length > 0 ? [UIColor colorWithHexString:model.bgColor] : FTHexColor(0xFF5196F3, 1);
//        self.zx_navTitleColor = model.bgColor.length > 0 ? [UIColor colorWithHexString:model.viewColor] : FTHexColor(0xFFFFFF, 1);
//        self.zx_navTintColor = model.bgColor.length > 0 ? [UIColor colorWithHexString:model.viewColor] : FTHexColor(0xFFFFFF, 1);

        [self setNeedsStatusBarAppearanceUpdate];
    }
}

@end
