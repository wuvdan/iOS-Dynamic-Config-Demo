//
//  ConfigModel.m
//  AppDynamicConfig
//
//  Created by 吴丹 on 2023/2/27.
//

#import "ConfigModel.h"
#import "MJExtension.h"

@implementation ConfigModel
- (instancetype)initWithName:(NSString *)name path:(NSString *)path {
    self = [super init];
    if (self) {
        _name = name;
        _path = path;
    }
    return self;
}
@end

@implementation ConfigDataModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"functions": @"ConfigModel",
        @"pages": @"ConfigModel"
    };
}
@end
