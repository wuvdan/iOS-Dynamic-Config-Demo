//
//  Router.m
//  AppDynamicConfig
//
//  Created by 吴丹 on 2023/2/27.
//

#import "Router.h"
#import "CommonPageViewController.h"
#import "CommonFuntionViewController.h"
#import "MGJRouter.h"
#import "NSDictionary+Router.h"
#import "WebViewController.h"
#import "URLSchemeManager.h"
#import "NavigationUtil.h"

#import "Common404ViewController.h"

#import "WMZDialog.h"
#import "ScanQRCodeViewController.h"
#import "Masonry.h"

@implementation Router

+ (void)load {
    
    [MGJRouter registerURLPattern:kRouter_Base_Path toHandler:^(NSDictionary *routerParameters) {
        
        if (routerParameters && [routerParameters isKindOfClass:[NSDictionary class]] && routerParameters.allKeys > 0) {
            // 获取基本参数
            NSDictionary *routerParameterUserInfo = [routerParameters dictForKey:MGJRouterParameterUserInfo];
            if (routerParameterUserInfo.count == 0) {
                return;
            }
            
            // 获取当前控制器
            UIViewController *currentController = [routerParameterUserInfo objectForKey:CurrnetVC];
            
            // 获取传参
            NSDictionary *dic = [routerParameterUserInfo dictForKey:DataJsonDic];
            
            NSInteger type = [dic intForKey:@"type"];
            if (type == 1) {
                // 404页面
                Common404ViewController *vc = [[Common404ViewController alloc] init];
                [self handleRouterParameters:routerParameters targetController:vc];
            } else {
                //  弹窗提示
                @DialogWeakify(self)
                Dialog()
                //固定高度
                .wHeightSet(350)
                .wTypeSet(DialogTypeMyView)
                .wWidthSet(DialogScreenW*0.8)
                .wShowAnimationSet(AninatonZoomInCombin)
                .wHideAnimationSet(AninatonZoomOut)
                .wMyDiaLogViewSet(^UIView *(UIView *mainView) {
                    @DialogStrongify(self)
                    UIImageView *image = [UIImageView new];
                    image.image = [UIImage imageNamed:@"down_tyx"];
                    image.frame = CGRectMake((mainView.frame.size.width-70)/2, 15, 70, 70);
                    [mainView addSubview:image];
                    
                    UILabel *la = [UILabel new];
                    la.font = [UIFont systemFontOfSize:17.0f];
                    la.text = @"温馨提示";
                    la.textAlignment = NSTextAlignmentCenter;
                    la.frame = CGRectMake(20, CGRectGetMaxY(image.frame)+15, mainView.frame.size.width-40, 40);
                    [mainView addSubview:la];
                    
                    UILabel *text = [UILabel new];
                    text.numberOfLines = 0;
                    text.font = [UIFont systemFontOfSize:15.0f];
                    text.text = @"非常抱歉，给您的使用带来了不便\n该功能当前版本不可用，请升级版本~";
                    text.textAlignment = NSTextAlignmentCenter;
                    text.frame = CGRectMake(20, CGRectGetMaxY(la.frame)+15, mainView.frame.size.width-40, 100);
                    [mainView addSubview:text];
                    
                    UIButton *know = [UIButton buttonWithType:UIButtonTypeCustom];
                    [mainView addSubview:know];
                    know.titleLabel.font = [UIFont systemFontOfSize:14.0f];
                    know.frame = CGRectMake(20, CGRectGetMaxY(text.frame)+15, mainView.frame.size.width-40, 44);
                    [know setTitle:@"升级版本" forState:UIControlStateNormal];
                    know.backgroundColor = DialogColor(0x108ee9);
                    mainView.layer.masksToBounds = YES;
                    mainView.layer.cornerRadius = 10;
                    return know;
                })
                .wStart();
            }
        }
    }];
    
    [MGJRouter registerURLPattern:kRouter_MAP_NAVI_Path toHandler:^(NSDictionary *routerParameters) {
        if (routerParameters && [routerParameters isKindOfClass:[NSDictionary class]] && routerParameters.allKeys > 0) {
            // 获取基本参数
            NSDictionary *routerParameterUserInfo = [routerParameters dictForKey:MGJRouterParameterUserInfo];
            if (routerParameterUserInfo.count == 0) {
                return;
            }
            
            // 获取当前控制器
            UIViewController *currentController = [routerParameterUserInfo objectForKey:CurrnetVC];
            
            // 获取传参
            NSDictionary *dic = [routerParameterUserInfo dictForKey:DataJsonDic];
            
            double latitude = [dic doubleForKey:@"latitude"];
            double longitude = [dic doubleForKey:@"longitude"];
            [NavigationUtil showMapWithCurrentController:currentController destinationLoaction:(CLLocationCoordinate2DMake(latitude, longitude))];
        }
    }];
    
    [MGJRouter registerURLPattern:kRouter_OPEN_URL_Path toHandler:^(NSDictionary *routerParameters) {
        if (routerParameters && [routerParameters isKindOfClass:[NSDictionary class]] && routerParameters.allKeys > 0) {
            // 获取基本参数
            NSDictionary *routerParameterUserInfo = [routerParameters dictForKey:MGJRouterParameterUserInfo];
            if (routerParameterUserInfo.count == 0) {
                return;
            }
        
            // 获取传参
            NSDictionary *dic = [routerParameterUserInfo dictForKey:DataJsonDic];
            
            NSString *url = [[dic stringForKey:@"url"] stringByRemovingPercentEncoding];
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url] options:@{} completionHandler:^(BOOL success) {
                            
            }];
        }
    }];
    
    [MGJRouter registerURLPattern:kRouter_Action_Close_Path toHandler:^(NSDictionary *routerParameters) {
        if (routerParameters && [routerParameters isKindOfClass:[NSDictionary class]] && routerParameters.allKeys > 0) {
            // 获取基本参数
            NSDictionary *routerParameterUserInfo = [routerParameters dictForKey:MGJRouterParameterUserInfo];
            if (routerParameterUserInfo.count == 0) {
                return;
            }
        
            // 获取当前控制器
            UIViewController *currentController = [routerParameterUserInfo objectForKey:CurrnetVC];
            
            // 获取传参
            NSDictionary *dic = [routerParameterUserInfo dictForKey:DataJsonDic];
            if ([[dic stringForKey:@"type"] isEqualToString:@"dismiss"]) {
                [currentController dismissViewControllerAnimated:YES completion:nil];
                return;
            }
            [currentController.navigationController popViewControllerAnimated:YES];
        }
    }];
    
    [MGJRouter registerURLPattern:kRouter_ScanCode_Path toHandler:^(NSDictionary *routerParameters) {
        ScanQRCodeViewController *vc = [[ScanQRCodeViewController alloc] init];
        [self handleRouterParameters:routerParameters targetController:vc];
    }];
    
    [MGJRouter registerURLPattern:kRouter_Demo1_Path toHandler:^(NSDictionary *routerParameters) {
        CommonPageViewController *vc = [[CommonPageViewController alloc] init];
        [self handleRouterParameters:routerParameters targetController:vc];
    }];
    
    [MGJRouter registerURLPattern:kRouter_Demo2_Path toHandler:^(NSDictionary *routerParameters) {
        CommonFuntionViewController *vc = [[CommonFuntionViewController alloc] init];
        [self handleRouterParameters:routerParameters targetController:vc];
    }];
    
    [MGJRouter registerURLPattern:kRouter_Web_Path toHandler:^(NSDictionary *routerParameters) {
        WebViewController *vc = [[WebViewController alloc] init];
        [self handleRouterParameters:routerParameters targetController:vc];
    }];
    
    [MGJRouter registerURLPattern:kRouter_TokenInvalid_Path toHandler:^(NSDictionary *routerParameters) {
        
        if (routerParameters && [routerParameters isKindOfClass:[NSDictionary class]] && routerParameters.allKeys > 0) {
            // 获取基本参数
            NSDictionary *routerParameterUserInfo = [routerParameters dictForKey:MGJRouterParameterUserInfo];
            if (routerParameterUserInfo.count == 0) {
                return;
            }
            
            // 获取当前控制器
            UIViewController *currentController = [routerParameterUserInfo objectForKey:CurrnetVC];
            
            // 获取传参
            NSDictionary *dic = [routerParameterUserInfo dictForKey:DataJsonDic];
            
            Dialog()
            .wTypeSet(DialogTypeMyView)
            .wShowAnimationSet(AninatonZoomIn)
            .wHideAnimationSet(AninatonZoomOut)
            .wMyDiaLogViewSet(^UIView *(UIView *mainView) {
                UIImageView *image = [UIImageView new];
                image.image = [UIImage imageNamed:@"healthy"];
                [mainView addSubview:image];
                [image mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(80).priorityHigh();
                    make.left.right.top.mas_equalTo(0);
                }];
                
                UILabel *la = [UILabel new];
                la.font = [UIFont systemFontOfSize:15.0f];
                la.text = [dic stringForKey:@"message"];
                la.numberOfLines = 0;
                [mainView addSubview:la];
                [la mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(10);
                    make.right.mas_equalTo(-10);
                    make.top.equalTo(image.mas_bottom);
                }];
                
                UIButton *know = [UIButton buttonWithType:UIButtonTypeCustom];
                [mainView addSubview:know];
                know.titleLabel.font = [UIFont systemFontOfSize:14.0f];
                [know setTitle:@"我知道了" forState:UIControlStateNormal];
                [know setTitleColor:DialogDarkColor(DialogColor(0x3333333), DialogColor(0xffffff)) forState:UIControlStateNormal];
                [know mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.mas_equalTo(0);
                    make.height.mas_equalTo(44).priorityHigh();
                    make.top.equalTo(la.mas_bottom);
                }];
            
                mainView.layer.masksToBounds = YES;
                mainView.layer.cornerRadius = 10;
                return know;
            })
            .wStartView(currentController.view);
        }
    }];
    
    [MGJRouter registerURLPattern:kRouter_Share_Path toHandler:^(NSDictionary *routerParameters) {
        
        if (routerParameters && [routerParameters isKindOfClass:[NSDictionary class]] && routerParameters.allKeys > 0) {
            // 获取基本参数
            NSDictionary *routerParameterUserInfo = [routerParameters dictForKey:MGJRouterParameterUserInfo];
            if (routerParameterUserInfo.count == 0) {
                return;
            }

            // 获取传参
            NSDictionary *dic = [routerParameterUserInfo dictForKey:DataJsonDic];
            
            Dialog()
            .wTypeSet(DialogTypeShare)
            .wEventMenuClickSet(^(id anyID, NSInteger section, NSInteger row) {
                NSLog(@"%@ %ld %ld---%@",anyID,(long)section,(long)row, dic);
            })
            .wDataSet(@[
                        @{@"name":@"微信",@"image":@"wallet"},
                        @{@"name":@"支付宝",@"image":@"aaa"},
                        @{@"name":@"米聊",@"image":@"bbb"},
                        @{@"name":@"微信1",@"image":@"wallet"},
                        @{@"name":@"支付宝2",@"image":@"aaa"},
                        @{@"name":@"米聊2",@"image":@"bbb"},
                        @{@"name":@"微信1",@"image":@"wallet"},
                        @{@"name":@"支付宝2",@"image":@"aaa"}
            ])
            .wRowCountSet(2)
            .wColumnCountSet(4)
            .wStart();
        }
    }];
    
    [MGJRouter registerURLPattern:kRouter_Alert_Path toHandler:^(NSDictionary *routerParameters) {
        
        if (routerParameters && [routerParameters isKindOfClass:[NSDictionary class]] && routerParameters.allKeys > 0) {
            // 获取基本参数
            NSDictionary *routerParameterUserInfo = [routerParameters dictForKey:MGJRouterParameterUserInfo];
            if (routerParameterUserInfo.count == 0) {
                return;
            }
            
            // 获取当前控制器
            UIViewController *currentController = [routerParameterUserInfo objectForKey:CurrnetVC];
            
            // 获取传参
            NSDictionary *dic = [routerParameterUserInfo dictForKey:DataJsonDic];
                        
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[dic stringForKey:@"title"] message:[dic stringForKey:@"message"] preferredStyle:(UIAlertControllerStyleAlert)];
            
            NSArray *actions = [dic arrayForKey:@"actions"];
            
            [actions enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                NSString *name = [obj stringForKey:@"name"];
                NSString *path = [obj stringForKey:@"path"];
                NSInteger style = [obj integerForKey:@"style"];

                [alertController addAction:[UIAlertAction actionWithTitle:name style:style handler:^(UIAlertAction * _Nonnull action) {
                    [URLSchemeManager openPageWithURLString:path controller:currentController];
                }]];
            }];
            [currentController presentViewController:alertController animated:YES completion:nil];
        }
    }];
    
    [MGJRouter registerURLPattern:kRouter_Sheet_Path toHandler:^(NSDictionary *routerParameters) {
        
        if (routerParameters && [routerParameters isKindOfClass:[NSDictionary class]] && routerParameters.allKeys > 0) {
            // 获取基本参数
            NSDictionary *routerParameterUserInfo = [routerParameters dictForKey:MGJRouterParameterUserInfo];
            if (routerParameterUserInfo.count == 0) {
                return;
            }
            
            // 获取当前控制器
            UIViewController *currentController = [routerParameterUserInfo objectForKey:CurrnetVC];
            
            // 获取传参
            NSDictionary *dic = [routerParameterUserInfo dictForKey:DataJsonDic];
                        
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[dic stringForKey:@"title"] message:[dic stringForKey:@"message"] preferredStyle:(UIAlertControllerStyleActionSheet)];
            
            NSArray *actions = [dic arrayForKey:@"actions"];
            
            [actions enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                NSString *name = [obj stringForKey:@"name"];
                NSString *path = [obj stringForKey:@"path"];
                NSInteger style = [obj integerForKey:@"style"];

                [alertController addAction:[UIAlertAction actionWithTitle:name style:style handler:^(UIAlertAction * _Nonnull action) {
                    [URLSchemeManager openPageWithURLString:path controller:currentController];
                }]];
            }];
            [currentController presentViewController:alertController animated:YES completion:nil];
        }
    }];
}

+ (void)handleRouterParameters:(NSDictionary *)routerParameters targetController:(UIViewController *)controller {
    if (routerParameters && [routerParameters isKindOfClass:[NSDictionary class]] && routerParameters.allKeys > 0) {
        // 获取基本参数
        NSDictionary *routerParameterUserInfo = [routerParameters dictForKey:MGJRouterParameterUserInfo];
        if (routerParameterUserInfo.count == 0) {
            return;
        }
        
        // 获取当前控制器
        UIViewController *currentController = [routerParameterUserInfo objectForKey:CurrnetVC];
        
        // 获取传参
        NSDictionary *dic = [routerParameterUserInfo dictForKey:DataJsonDic];

        // showType
        // 0: push
        //  没有导航栏则使用present
        // 1: present
        NSInteger showType = [dic integerForKey:kShowType];
        
        if ([controller respondsToSelector:@selector(setParams:)]) {
            [controller performSelector:@selector(setParams:) withObject:dic];
        }
                
        if (currentController.navigationController && showType == 0) {
            [currentController.navigationController pushViewController:controller animated:YES];
        } else {
            [currentController presentViewController:controller animated:YES completion:nil];
        }
    } else {
        UIViewController *currentController = [self keyWindow].rootViewController;
        if (currentController) {
            if (currentController.navigationController) {
                [currentController.navigationController pushViewController:controller animated:YES];
            } else {
                [currentController presentViewController:controller animated:YES completion:nil];
            }
        }
        [self alertWithTitle:@"温馨提示" message:@"该路由配置有问题" actions:@[
            [UIAlertAction actionWithTitle:@"我知道了" style:(UIAlertActionStyleDefault) handler:nil]
        ]];
    }
}

+ (void)alertWithTitle:(NSString *)title message:(NSString *)message actions:(NSArray<UIAlertAction *> *)actions{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:(UIAlertControllerStyleAlert)];
    [actions enumerateObjectsUsingBlock:^(UIAlertAction * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [alertController addAction:obj];
    }];
    [[self keyWindow].rootViewController presentViewController:alertController animated:YES completion:nil];
}

+ (UIWindow *)keyWindow
{
    for (UIWindowScene *windowScene in UIApplication.sharedApplication.connectedScenes) {
        if (windowScene.activationState == UISceneActivationStateForegroundActive) {
            for (UIWindow *window in windowScene.windows) {
                if (window.isKeyWindow) {
                    return window;
                }
            }
            break;
        }
    }
    return nil;
}

@end
