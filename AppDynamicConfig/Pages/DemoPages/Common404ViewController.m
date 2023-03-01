//
//  Common404ViewController.m
//  AppDynamicConfig
//
//  Created by 吴丹 on 2023/2/28.
//

#import "Common404ViewController.h"
#import "LYEmptyView.h"
#import "UIView+Empty.h"

@interface Common404ViewController ()

@end

@implementation Common404ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    LYEmptyView *view = [LYEmptyView emptyViewWithImage:[UIImage imageNamed:@"noData"] titleStr:@"404" detailStr:@"该功能不存在"];
    //1.先设置样式
    self.view.ly_emptyView = view;
    //2.显示emptyView
    [self.view ly_showEmptyView];
}

@end
