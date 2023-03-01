//
//  ConfigModel.h
//  AppDynamicConfig
//
//  Created by 吴丹 on 2023/2/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ConfigModel : NSObject
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *path;
- (instancetype)initWithName:(NSString *)name path:(NSString *)path;
@end

@interface ConfigDataModel : NSObject
@property (copy, nonatomic) NSArray<ConfigModel *> *functions;
@property (copy, nonatomic) NSArray<ConfigModel *> *pages;
@end


NS_ASSUME_NONNULL_END
