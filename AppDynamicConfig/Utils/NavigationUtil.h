//
//  NavigationUtil.h
//  AppDynamicConfig
//
//  Created by 吴丹 on 2023/2/27.
//

#import <Foundation/Foundation.h>
@import MapKit;
NS_ASSUME_NONNULL_BEGIN

@interface NavigationUtil : NSObject
+ (void)showMapWithCurrentController:(UIViewController *)controller destinationLoaction:(CLLocationCoordinate2D)destinationLoaction;
@end

NS_ASSUME_NONNULL_END
