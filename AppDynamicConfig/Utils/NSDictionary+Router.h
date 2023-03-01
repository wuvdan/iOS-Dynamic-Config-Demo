//
//  NSDictionary+Router.h
//  AppDynamicConfig
//
//  Created by 吴丹 on 2023/2/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (Router)
/**通过key获取对象*/
-(id)objectForKeyCheckNull:(id)aKey;

/**通过key获取对象，并设置默认值*/
-(id)objectForKey:(id)aKey DefaultValue:(id)value;

/**通过key获取NSInteger类型的value*/
-(NSInteger)integerForKey:(id)aKey;

/**通过key获取int类型的value*/
-(int)intForKey:(id)aKey;

/**通过key获取float类型的value*/
-(float)floatForKey:(id)aKey;

/**通过key获取double类型的value*/
-(double)doubleForKey:(id)aKey;

/**通过key获取NSString类型的value*/
-(NSString *)stringForKey:(id)aKey;

/**通过key获取NSDictionary类型的value*/
-(NSDictionary *)dictForKey:(id)akey;

/**通过key获取NSArray类型的value*/
-(NSArray *)arrayForKey:(id)akey;

/**字典转Json字符串**/
+ (NSString*)convertToJSONData:(id)infoDict;

/**JSON字符串转化为字典**/
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
@end

NS_ASSUME_NONNULL_END
