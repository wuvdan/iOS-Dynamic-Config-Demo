//
//  WebStyleModel.m
//  AppDynamicConfig
//
//  Created by 吴丹 on 2023/3/1.
//

#import "WebStyleModel.h"
#import "MJExtension.h"

@implementation WebStyleButtonModel

@end

@implementation WebStyleModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"rightButtons": @"WebStyleButtonModel"
    };
}
@end
