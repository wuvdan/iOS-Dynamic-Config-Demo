//
//  URLSchemeManager.m
//  AppDynamicConfig
//
//  Created by 吴丹 on 2023/2/27.
//

#import "URLSchemeManager.h"
#import "Router.h"
#import "MGJRouter.h"
#import "WebViewController.h"

@implementation URLSchemeManager
+ (BOOL)checkIsInnerPagWithURLString:(NSString *)URLString {
    
    if ([[URLString lowercaseString] hasPrefix:kRouter_Base_Path]) {
        return YES;
    }
    return NO;
}

+ (NSDictionary *)getParameterWithURL:(NSURL *)url {
    if ([self getJSONStringWithURL:url] && [self getJSONStringWithURL:url].length > 0) {

        NSString *requestString = [url absoluteString];
        NSMutableDictionary *dic = [self getUrlStringParameterWithURLString:requestString];

        if ([self object:dic forKeyCheckNull:@"needDecode"] != nil) {
            BOOL needDecode = [self object:dic intForKey:@"needDecode"];
            if (needDecode) {
                return [self dictionaryWithJsonString:[self getJSONStringWithURL:url] needDecoded:YES];
            } else {
                return [self dictionaryWithJsonString:[self getJSONStringWithURL:url] needDecoded:NO];
            }
        } else {
            return [self dictionaryWithJsonString:[self getJSONStringWithURL:url] needDecoded:NO];
        }
    }
    return @{};
}

+ (NSString *)getSechemsWithURL:(NSURL *)url {
    return [NSString stringWithFormat:@"%@://%@%@", url.scheme, url.host,url.path];;
}

+ (NSString *)getJSONStringWithURL:(NSURL *)url {
    NSString *requestString = [url absoluteString];
    NSMutableDictionary *dic = [self getUrlStringParameterWithURLString:requestString];

    if ([self object:dic forKeyCheckNull:@"needDecode"]!= nil) {
        BOOL needDecode = [self object:dic intForKey:@"needDecode"];
        if (needDecode) {
            NSString *decodeString = dic[kData_JSON_key];
            decodeString = [decodeString stringByReplacingOccurrencesOfString:@"+" withString:@" "];
            return [decodeString stringByRemovingPercentEncoding];
        } else {
            return dic[kData_JSON_key];
        }
    } else {
        if (dic.count > 0) {
            return dic[kData_JSON_key];
        } else {
            return @"";
        }
    }
}

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString needDecoded:(BOOL)needDecoded {
    if (jsonString == nil) {
        return nil;
    }

    if (needDecoded) {
        NSString *text = [self URLDecodedString:jsonString];

        NSData *jsonData = [text dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                            options:NSJSONReadingMutableContainers
                                                              error:&err];
        if(err) {
            NSLog(@"json解析失败：%@",err);
            return nil;
        }
        return dic;
    } else {
        NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                            options:NSJSONReadingMutableContainers
                                                              error:&err];
        if(err) {
            NSLog(@"json解析失败：%@",err);
            return nil;
        }
        return dic;
    }
}


+ (NSString *)URLDecodedString:(NSString *)str
{
    NSString *decodedString=(__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)str, CFSTR(""), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));

    return decodedString;
}

+ (void)openPageWithURLString:(NSString *)URLString controller:(nullable UIViewController *)controller {

    if (URLString.length == 0) {
        return;
    }

    NSURL *url = [NSURL URLWithString:URLString];
    // 若URLScheme为内部链接
    if ([URLSchemeManager checkIsInnerPagWithURLString:URLString]) {
        
        //判断是否能打开该scheme，若不能，则提示下载最新版本
        if (![MGJRouter canOpenURL:[URLSchemeManager getSechemsWithURL:url] matchExactly:YES]) {
            [URLSchemeManager alterCanNotOpenURLSchemeWithController:controller confirmBlock:nil cancelBlock:nil];
            return;
        }
        
        // 直接打开
        [MGJRouter openURL:[URLSchemeManager getSechemsWithURL:url]
              withUserInfo:@{CurrnetVC: controller,
                             DataJsonDic: [URLSchemeManager getParameterWithURL:url]}
        completion:nil];
        return;
    }
    
    // 若URLScheme为外部链接
    WebViewController *webVC = [[WebViewController alloc]init];
    webVC.urlString = URLString;
    [controller.navigationController showViewController:webVC sender:nil];
}

+ (void)openPageWithURLString:(NSString *)URLString
                   controller:(UIViewController *)controller
                   completion:(void(^)(BOOL success))completion {
    if (URLString.length == 0) {
        return;
    }

    NSURL *url = [NSURL URLWithString:[URLString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]];
    // 若URLScheme为内部链接
    if ([URLSchemeManager checkIsInnerPagWithURLString:URLString]) {
        
        //判断是否能打开该scheme，若不能，则提示下载最新版本
        if (![MGJRouter canOpenURL:[URLSchemeManager getSechemsWithURL:url] matchExactly:YES]) {
            [URLSchemeManager alterCanNotOpenURLSchemeWithController:controller confirmBlock:^{
                if (completion) {
                    completion(NO);
                }
            } cancelBlock:^{
                if (completion) {
                    completion(NO);
                }
            }];
            return;
        }
        
        // 直接打开
        [MGJRouter openURL:[URLSchemeManager getSechemsWithURL:url]
              withUserInfo:@{NavigationVC : controller.navigationController,
                             CurrnetVC: controller,
                             DataJsonDic: [URLSchemeManager getParameterWithURL:url]}
                completion:nil];
        
        if (completion) {
            completion(YES);
        }
        return;
    }
    
//    // 若URLScheme为外部链接
//    FTBannerWebViewController *webVC = [[FTBannerWebViewController alloc]init];
//    webVC.urlString = URLString;
//    [controller.navigationController showViewController:webVC sender:nil];
}

+ (void)alterCanNotOpenURLSchemeWithController:(UIViewController *)controller
                                  confirmBlock:(void(^)(void))confirmBlock
                                   cancelBlock:(void(^)(void))cancelBlock
{
//    DAlterViewController *alter = [DAlterViewController alterWithAlterWithTitle:@"温馨提示" content:@"请下载最新版本体验\n"];
//    [alter addAction:({
//        DAlterAction *action = [DAlterAction actionWithTitle:@"取消" actionType:(DAlterActionTypeCancel) handler:^(DAlterAction * _Nonnull action) {
//            if (cancelBlock) {
//                cancelBlock();
//            }
//        }];
//        action;
//    })];
//
//    [alter addAction:({
//        DAlterAction *action = [DAlterAction actionWithTitle:@"去下载" actionType:(DAlterActionTypeDefault) handler:^(DAlterAction * _Nonnull action) {
//            NSURL *appURL = [NSURL URLWithString:@"https://apps.apple.com/cn/app/%E5%90%88%E8%82%A5%E5%81%9C%E8%BD%A6/id986653212"];
//            if ([[UIApplication sharedApplication] canOpenURL:appURL]) {
//                [[UIApplication sharedApplication] openURL:appURL options:@{} completionHandler:nil];
//            }
//            if (confirmBlock) {
//                confirmBlock();
//            }
//        }];
//        action;
//    })];
//
//    [controller presentViewController:alter animated:YES completion:nil];
}

+ (void)showNoSupportAlertWithController:(UIViewController *)controller {
//    DAlterViewController *alter = [DAlterViewController alterWithAlterWithTitle:@"温馨提示" content:@"请下载最新版本体验\n"];
//    [alter addAction:({
//        DAlterAction *action = [DAlterAction actionWithTitle:@"取消" actionType:(DAlterActionTypeCancel) handler:^(DAlterAction * _Nonnull action) {
//
//        }];
//        action;
//    })];
//
//    [alter addAction:({
//        DAlterAction *action = [DAlterAction actionWithTitle:@"去下载" actionType:(DAlterActionTypeDefault) handler:^(DAlterAction * _Nonnull action) {
//            NSURL *appURL = [NSURL URLWithString:@"https://apps.apple.com/cn/app/%E5%90%88%E8%82%A5%E5%81%9C%E8%BD%A6/id986653212"];
//            if ([[UIApplication sharedApplication] canOpenURL:appURL]) {
//                [[UIApplication sharedApplication] openURL:appURL options:@{} completionHandler:nil];
//            }
//        }];
//        action;
//    })];
//
//    [controller presentViewController:alter animated:YES completion:nil];
}


+ (NSMutableDictionary *)getUrlStringParameterWithURLString:(NSString *)urlString{
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLComponents *urlComponents = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:NO];
    // url中参数的key value
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    for (NSURLQueryItem *item in urlComponents.queryItems) {
        [parameter setValue:item.value forKey:item.name];
    }
    return parameter;
}

+ (id)object:(NSDictionary *)dic forKeyCheckNull:(id)aKey {
    id value = [dic objectForKey:aKey];
    if ([value isEqual:[NSNull null]]) {
        return nil;
    }
    return value;
}

+ (int)object:(NSDictionary *)dic intForKey:(id)aKey {
    id value = [self object:dic forKeyCheckNull:aKey];
    if (value) {
        return [value intValue];
    }
    return 0;
}

@end
