//
//  NavigationUtil.m
//  AppDynamicConfig
//
//  Created by 吴丹 on 2023/2/27.
//

#import "NavigationUtil.h"
#import "SPAlertController.h"
#import <MapKit/MapKit.h>

#import "WDAlterManager.h"
@implementation NavigationUtil
+ (NSArray<NSString *> *)currentInstallMapApps {
    NSArray *urls = @[@"qqmap", @"iosamap", @"baidumap"];
    NSMutableArray *tempArray = [NSMutableArray array];
    for (NSString *url in urls) {
        if ([self checkInstallAppWithSechame:url]) {
            [tempArray addObject:url];
        }
    }
    [tempArray addObject:@""];
    return tempArray;
}

+ (NSArray<NSString *> *)currentInstallMapAppNames {
    NSMutableArray *tempArray = [NSMutableArray array];
    for (NSString *url in [self currentInstallMapApps]) {
        if ([url isEqualToString:@"qqmap"]) {
            [tempArray addObject:@"腾讯地图"];
        } else if ([url isEqualToString:@"iosamap"]) {
            [tempArray addObject:@"高德地图"];
        } else if ([url isEqualToString:@"baidumap"]) {
            [tempArray addObject:@"百度地图"];
        } else if ([url isEqualToString:@""]) {
            [tempArray addObject:@"苹果地图"];
        }
    }
    return tempArray;
}

+ (void)showMapWithCurrentController:(UIViewController *)controller destinationLoaction:(CLLocationCoordinate2D)destinationLoaction {
    NSArray *mapAppArray = [self currentInstallMapApps];
    if (mapAppArray.count == 0) {
        [WDAlterManager showAlterWithTitle:@"无法跳转" message:@"对不起，请先下载导航软件" buttons:@[@"我知道了"] didSelectedHandle:^(NSInteger index) {
            
        } inController:controller];
        
        
        
        return;
    }
    
    SPAlertController *alertController = [SPAlertController alertControllerWithTitle:@"请选择地图" message:@"" preferredStyle:SPAlertControllerStyleActionSheet];
    alertController.titleFont = [UIFont systemFontOfSize:13];
    alertController.titleColor = [UIColor blackColor];
        
    [mapAppArray enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *name = [self currentInstallMapAppNames][idx];
        
        SPAlertAction *action = [SPAlertAction actionWithTitle:name style:SPAlertActionStyleDefault handler:^(SPAlertAction * _Nonnull action) {
            if ([obj isEqualToString:@"qqmap"]) {
                [self openQQMapWithDestinationLoaction:destinationLoaction];
            } else if ([obj isEqualToString:@"iosamap"]) {
                [self openAMapWithDestinationLoaction:destinationLoaction];
            } else if ([obj isEqualToString:@"baidumap"]) {
                [self openBaiduMapWithDestinationLoaction:destinationLoaction];
            } else {
                [self openSystemMapWithDestinationLoaction:destinationLoaction];
            }
        }];
        action.titleColor = [UIColor blackColor];
        [alertController addAction:action];
    }];
    
    SPAlertAction *cancel = [SPAlertAction actionWithTitle:@"取消" style:SPAlertActionStyleCancel handler:^(SPAlertAction * _Nonnull action) {
    }];
    cancel.titleColor = [UIColor redColor];
    [alertController addAction:cancel];
    [controller presentViewController:alertController animated:YES completion:^{}];
}

// 苹果地图
+ (void)openSystemMapWithDestinationLoaction:(CLLocationCoordinate2D)destinationLoaction {
    MKMapItem *currentLoc =  [MKMapItem mapItemForCurrentLocation];
    MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:destinationLoaction addressDictionary:nil]];
    NSArray *items = @[currentLoc,toLocation];
    NSDictionary *dic = @{
                          MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving,
                          MKLaunchOptionsMapTypeKey : @(MKMapTypeStandard),
                          MKLaunchOptionsShowsTrafficKey : @(YES)
                          };
    [MKMapItem openMapsWithItems:items launchOptions:dic];
}

// 高德地图
+ (void)openAMapWithDestinationLoaction:(CLLocationCoordinate2D)destinationLoaction {
    
    NSString *urlString = [[NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&lat=%f&lon=%f&dev=0&style=2",@"xxx",@"FeiTian",destinationLoaction.latitude,destinationLoaction.longitude] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    

    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString] options:@{} completionHandler:^(BOOL success) {
        
    }];
}

// 百度地图
+ (void)openBaiduMapWithDestinationLoaction:(CLLocationCoordinate2D)destinationLoaction {
    NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name=终点&mode=driving&coord_type=gcj02",destinationLoaction.latitude,destinationLoaction.longitude] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];

    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString] options:@{} completionHandler:^(BOOL success) {
        
    }];
}

// 腾讯地图
+ (void)openQQMapWithDestinationLoaction:(CLLocationCoordinate2D)destinationLoaction {
    NSString *urlString = [[NSString stringWithFormat:@"qqmap://map/routeplan?from=我的位置&type=drive&tocoord=%f,%f&to=终点&coord_type=1&policy=0",destinationLoaction.latitude,destinationLoaction.longitude] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString] options:@{} completionHandler:^(BOOL success) {
        
    }];
}


+ (BOOL)checkInstallAppWithSechame:(NSString *)sechame {
    NSString *url = [NSString stringWithFormat:@"%@://", sechame];
    NSURL *appPath = [NSURL URLWithString:url];
    return [[UIApplication sharedApplication] canOpenURL:appPath];
}
@end
