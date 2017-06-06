//
//  TXArticle.h
//  WX_GZH_Demo
//
//  Created by  杭州信配iOS开发 on 2017/5/5.
//  Copyright © 2017年  张天雄. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TXArticle : NSObject
//标题
@property (nonatomic,copy)NSString * title;
//图文消息的封面图片素材id（必须是永久mediaID）
@property (nonatomic,copy)NSString * thumb_media_id;
//作者
@property (nonatomic,copy)NSString * author;
//图文消息的摘要，仅有单图文消息才有摘要，多图文此处为空
@property (nonatomic,copy)NSString * digest;
//是否显示封面，0为false，即不显示，1为true，即显示
@property (nonatomic,copy)NSNumber * show_cover_pic;
//图文消息的具体内容，支持HTML标签，必须少于2万字符，小于1M，且此处会去除JS
@property (nonatomic,copy)NSString * content;
//图文消息的原文地址，即点击“阅读原文”后的URL
@property (nonatomic,copy)NSString * content_source_url;

/*模型转字典*/
- (NSDictionary*)keyValues;

@end
