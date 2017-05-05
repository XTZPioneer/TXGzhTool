//
//  TXGzhTool.m
//  WX_GZH_Demo
//
//  Created by  杭州信配iOS开发 on 2017/5/5.
//  Copyright © 2017年  张天雄. All rights reserved.
//

#import "TXGzhTool.h"
@implementation TXGzhTool
/*上传素材*/
+ (void)uploadMaterialWithAccessToken:(NSString*)accessToken image:(UIImage*)image article:(TXArticle*)article completionBlock:(CompletionBlock)completionBlock  errorBlock:(ErrorBlock)errorBlock{
    if (!accessToken) {
        if (errorBlock) {
            errorBlock((NSError*)@"没有accessToken");
        }
    }else if(!image) {
        if (errorBlock) {
            errorBlock((NSError*)@"没有image");
        }
    }else if (!article){
        if (errorBlock) {
            errorBlock((NSError*)@"没有article");
        }
    }else{
        NSData *imageData=UIImagePNGRepresentation(image);
        [self uploadImageWithWithAccessToken:accessToken imageData:imageData article:article completionBlock:completionBlock errorBlock:errorBlock];
        
    }
}
/*上传图片*/
+ (void)uploadImageWithWithAccessToken:(NSString*)accessToken imageData:(NSData*)imageData article:(TXArticle*)article completionBlock:(CompletionBlock)completionBlock  errorBlock:(ErrorBlock)errorBlock{
    NSDate * date = [NSDate date];//给定的时间
    NSDate * today = [NSDate dateWithTimeInterval:24*60*60 sinceDate:date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString * today_time=[formatter stringFromDate:today];
    [TX_WXNetWork uploadWithUrl:[NSString stringWithFormat:@"https://api.weixin.qq.com/cgi-bin/material/add_material?access_token=%@",accessToken] parameters:@{@"type" : @"image"} filename:[NSString stringWithFormat:@"%@.png",today_time] mimeType:@"png" fileData:imageData progressBlock:^(NSProgress *progress) {
    } returnValueBlock:^(id returnValue) {
        if (returnValue) {
            [article setThumb_media_id:returnValue[@"media_id"]];
            [self uploadArticleWithAccessToken:accessToken article:article completionBlock:completionBlock errorBlock:errorBlock];
        }
    } errorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    }];
}
/*上传图文*/
+ (void)uploadArticleWithAccessToken:(NSString*)accessToken article:(TXArticle*)article completionBlock:(CompletionBlock)completionBlock  errorBlock:(ErrorBlock)errorBlock{
    
    NSString * title= article.title ? article.title:@"";
    NSString * thumb_media_id=article.thumb_media_id ? article.thumb_media_id:@"";
    NSString * author=article.author ? article.author : @"";
    NSString * digest=article.digest ? article.digest : @"";
    NSNumber * show_cover_pic =article.show_cover_pic ? article.show_cover_pic : @1;
    NSString * content=article.content ? article.content : @" ";
    NSString * content_source_url=article.content_source_url ? article.content_source_url : @"";
    NSDictionary * dict=@{
                          @"articles":@[
                                  @{
                                      @"title":title,
                                      @"thumb_media_id":thumb_media_id,
                                      @"author":author,
                                      @"digest":digest,
                                      @"show_cover_pic":show_cover_pic,
                                      @"content":content,
                                      @"content_source_url":content_source_url
                                      }
                                  ]
                          };
    [TX_WXNetWork POST:[NSString stringWithFormat:@"https://api.weixin.qq.com/cgi-bin/material/add_news?access_token=%@",accessToken] parameters:dict progressBlock:^(NSProgress *progress) {
    } returnValueBlock:^(id returnValue) {
        if (returnValue) {
            if (completionBlock) {
                completionBlock(returnValue);
            }
        }
    } errorBlock:^(NSError *error) {
        if (error) {
            if (errorBlock) {
                errorBlock(error);
            }
        }
    }];
}
@end
