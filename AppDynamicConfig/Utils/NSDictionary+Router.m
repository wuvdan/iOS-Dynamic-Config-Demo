//
//  NSDictionary+Router.m
//  AppDynamicConfig
//
//  Created by 吴丹 on 2023/2/27.
//

#import "NSDictionary+Router.h"

@implementation NSDictionary (Router)
-(id)objectForKeyCheckNull:(id)aKey
{
    id value = [self objectForKey:aKey];
    if ([value isEqual:[NSNull null]]) {
        return nil;
    }
    return value;
}

-(id)objectForKey:(id)aKey DefaultValue:(id)value
{
    id obj = [self objectForKey:aKey];
    if (obj==[NSNull null] || obj==nil) {
        return value;
    }
    return obj;
}

-(NSInteger)integerForKey:(id)aKey
{
    id value = [self objectForKeyCheckNull:aKey];
    return [value integerValue];
}

-(int)intForKey:(id)aKey
{
    id value = [self objectForKeyCheckNull:aKey];
    if (value) {
        return [value intValue];
    }
    return 0;
}

-(float)floatForKey:(id)aKey{
    id value = [self objectForKeyCheckNull:aKey];
    if (value) {
        return [value floatValue];
    }
    return 0.f;
}

-(double)doubleForKey:(id)aKey{
    id value = [self objectForKeyCheckNull:aKey];
    if (value) {
        return [value doubleValue];
    }
    return 0.f;
}

-(NSString *)stringForKey:(id)aKey
{
    id obj = [self objectForKey:aKey];
    if (obj==[NSNull null] || obj==nil) {
        return @"";
    }
    return [NSString stringWithFormat:@"%@",obj];
}

-(NSDictionary *)dictForKey:(id)akey{
    id value = [self objectForKeyCheckNull:akey];
    if (value && [value isKindOfClass:[NSDictionary class]]) {
        return value;
    }
    return [NSDictionary dictionary];
}

-(NSArray *)arrayForKey:(id)akey
{
    id value = [self objectForKeyCheckNull:akey];
    if (value && [value isKindOfClass:[NSArray class]]) {
        return value;
    }
    return [NSArray array];
}

//字典转Json字符串
+ (NSString*)convertToJSONData:(id)infoDict
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:infoDict
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    
    NSString *jsonString = @"";
    
    if (! jsonData)
    {
        NSLog(@"Got an error: %@", error);
    }else
    {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    jsonString = [jsonString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
    
    [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    return jsonString;
}
//JSON字符串转化为字典
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}
@end
