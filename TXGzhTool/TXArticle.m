//
//  TXArticle.m
//  WX_GZH_Demo
//
//  Created by  杭州信配iOS开发 on 2017/5/5.
//  Copyright © 2017年  张天雄. All rights reserved.
//

#import "TXArticle.h"

@implementation TXArticle

- (NSString*)title{
    if (!_title) {
        _title=@"";
    }
    return _title;
}
- (NSString*)content{
    if (!_content) {
        _content=@"";
    }
    return _content;
}
- (NSString*)author{
    if (!_author) {
        _author=@"";
    }
    return _author;
}
- (NSString*)thumb_media_id{
    if (!_thumb_media_id) {
        _thumb_media_id=@"";
    }
    return _thumb_media_id;
}
- (NSString*)digest{
    if (!_digest) {
        _digest=@"";
    }
    return _digest;
}
- (NSNumber*)show_cover_pic{
    if (!_show_cover_pic) {
        _show_cover_pic=@0;
    }
    return _show_cover_pic;
}
- (NSString*)content_source_url{
    if (!_content_source_url) {
        _content_source_url=@"";
    }
    return _content_source_url;
}
/*模型转字典*/
- (NSDictionary*)keyValues{
    NSMutableDictionary * keyValues=[NSMutableDictionary dictionary];
    unsigned int outCount;
    objc_property_t * arrPropertys = class_copyPropertyList([self class], &outCount);
    for (NSInteger index = 0; index < outCount; index ++) {
        objc_property_t property = arrPropertys[index];
        NSString *propertyName = [NSString stringWithUTF8String:property_getName(property)];
        if(![propertyName isEqual:[NSNull null]]){
            [keyValues setValue:[self valueForKey:propertyName] forKey:propertyName];
        }else if (!propertyName){
            [keyValues setValue:[self valueForKey:propertyName] forKey:propertyName];
        }
    }
    free(arrPropertys);
    return keyValues;
}
@end
