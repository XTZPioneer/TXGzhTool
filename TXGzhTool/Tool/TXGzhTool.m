//
//  TXGzhTool.m
//  WX_GZH_Demo
//
//  Created by  杭州信配iOS开发 on 2017/5/5.
//  Copyright © 2017年  张天雄. All rights reserved.
//

#import "TXGzhTool.h"
@implementation TXGzhTool

#pragma mark- 2017.5.26 新增接口
/* 上传图片到微信
 *
 * AccessToken     微信AccessToken
 * isPermanent     是否为永久素材
 * uploadImageType 上传Image的类型
 * image           需要上传的image
 *
 */
+ (void)uploadImageToWXWithAccessToken:(NSString*)accessToken isPermanent:(BOOL)isPermanent uploadImageType:(WXUploadImageType)uploadType  image:(UIImage*)image progressBlock:(WXProgressBlock)progressBlock returnValueBlock:(WXReturnValueBlock)returnValueBlock  errorBlock:(WXErrorBlock)errorBlock{
    if (!accessToken) {
        if (errorBlock) errorBlock((NSError*)@"没有accessToken");
    }else if (!image){
        if (errorBlock) errorBlock((NSError*)@"没有image");
    }else{
        NSString * url=nil;
        NSString * imageType=nil;
        NSData   * imageData=nil;
        CGFloat    maxDataSizeKB=0.0;
        NSDictionary * dict=nil;
        if (isPermanent) {
            url=[NSString stringWithFormat:@"https://api.weixin.qq.com/cgi-bin/material/add_material?access_token=%@",accessToken];
        }else{
            url=[NSString stringWithFormat:@"https://api.weixin.qq.com/cgi-bin/media/uploadimg?access_token=%@",accessToken];
        }
        if (image.size.width>=2144 && image.size.height>=1424) {
            image=[self imageWithImage:image scaledToSize:CGSizeMake(image.size.width/2.0, image.size.height/2.0)];
        }
        maxDataSizeKB = uploadType==WXImageType ? 1024 : 64;
        imageType= uploadType==WXImageType ? @"image": @"thumb";
        imageData=[self compressOriginalImage:image toMaxDataSizeKB:maxDataSizeKB];
        dict = @{@"type" : imageType};
        [TXWXNetWorking uploadWithUrl:url parameters:dict filename:[NSString stringWithFormat:@"%@.png",self.today] mimeType:@"png" fileData:imageData progressBlock:^(NSProgress *progress) {
            if (progressBlock) progressBlock(progress);
        } returnValueBlock:^(id returnValue) {
            //永久素材/非永久素材
            if (returnValue[@"media_id"] || returnValue[@"url"] ) {
                return returnValueBlock(returnValue);
            }else{
                if (errorBlock) errorBlock(returnValue);
            }
        } errorBlock:^(NSError *error) {
            if (errorBlock) errorBlock(error);
        }];
    }
}
/*获取时间*/
+ (NSString*)today{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    NSString * today = [formatter stringFromDate:date];
    return today;
}
#pragma mark- 2017.5.27 新增接口
/* 获取ImageMedia_ids
 *
 * AccessToken 微信AccessToken
 * images      图片容器
 */
+ (void)getImageMedia_idsWithAccessToken:(NSString*)accessToken images:(NSArray <UIImage*> *)images returnValueBlock:(WXReturnValueBlock)returnValueBlock errorBlock:(WXErrorBlock)errorBlock{
    if (!accessToken) {
        if (errorBlock) errorBlock ((NSError*)@"没有accessToken");
    }else if (!images){
        if (errorBlock) errorBlock ((NSError*)@"没有images");
    }
    NSMutableArray * media_ids=[NSMutableArray array];
    for (int index=0; index<images.count; index++) {
        [self uploadImageToWXWithAccessToken:accessToken isPermanent:YES uploadImageType:WXImageType image:images[index] progressBlock:^(NSProgress *progress) {
        } returnValueBlock:^(id returnValue) {
            [media_ids addObject:returnValue[@"media_id"]];
            if (media_ids.count==images.count) {
                if (returnValueBlock) returnValueBlock(media_ids);
            }
        } errorBlock:^(NSError *error) {
            if (errorBlock)  errorBlock (error);
        }];
    }
}
/* 获取文章Contents
 *
 * AccessToken 微信AccessToken
 * urls      url容器
 */
+ (void)getContentsWithUrls:(NSArray <NSURL*> *)urls returnValueBlock:(WXReturnValueBlock)returnValueBlock errorBlock:(WXErrorBlock)errorBlock{
    if (!urls) {
        if (errorBlock) errorBlock ((NSError*)@"没有urls");
    }
    NSMutableArray * contents=[NSMutableArray array];
    for (int index=0; index<urls.count; index++) {
        [TXAnalysisWXHTML getWXNewsContentWithWXURL:urls[index] returnValueBlock:^(id returnValue) {
            [contents addObject:returnValue];
            if (contents.count==urls.count) {
                if (returnValueBlock) returnValueBlock(contents);
            }
        } errorBlock:^(NSError *error) {
            if (errorBlock)  errorBlock (error);
        }];
    }
}
/* 获取完整Articles
 *
 * ImageMedia_ids ImageMedia_id容器
 * contents       内容容器
 * oldArticles    旧的articles
 */
+ (void)getNewArticlesWithImageMedia_ids:(NSArray <NSString*> *)media_ids contents:(NSArray <NSString*> *)contents oldArticles:(NSArray <TXArticle*> *)oldArticles returnValueBlock:(WXReturnValueBlock)returnValueBlock errorBlock:(WXErrorBlock)errorBlock{
    if (!media_ids) {
        if (errorBlock) errorBlock ((NSError*)@"没有media_ids");
    }else if (!contents){
        if (errorBlock) errorBlock ((NSError*)@"没有contents");
    }else if (!oldArticles){
        if (errorBlock) errorBlock ((NSError*)@"没有oldArticles");
    }else{
        NSMutableArray * newArticles=[NSMutableArray array];
        for (int index=0; index<media_ids.count; index++) {
            TXArticle * newArticle = oldArticles[index];
            NSString  * thumb_media_id=media_ids[index];
            NSString  * content=contents[index];
            newArticle.thumb_media_id=thumb_media_id;
            newArticle.content=content;
            [newArticles addObject:newArticle];
            if (newArticles.count==oldArticles.count) {
                if (returnValueBlock) returnValueBlock(newArticles);
            }
        }
        if (newArticles.count<=0) {
            if (errorBlock) {
                if (errorBlock) errorBlock ((NSError*)@"无数据");
            }
        }
    }
}
/* 添加到素材库
 *
 * AccessToken 微信AccessToken
 * newArticles 新的文章容器
 */
+ (void)addPicturesAndArticlesToWXWithAccessToken:(NSString*)accessToken newArticles:(NSArray <TXArticle*> *)newArticles returnValueBlock:(WXReturnValueBlock)returnValueBlock  errorBlock:(WXErrorBlock)errorBlock{
    if (!accessToken) {
        if (errorBlock) {
            errorBlock((NSError*)@"没有accessToken");
        }
    }else if (!newArticles){
        if (errorBlock) {
            errorBlock((NSError*)@"没有newArticles");
        }
    }else{
        NSDictionary * dict=@{
                              @"articles":[self articleModelsToArray:newArticles]
                              };
        [TXWXNetWorking POST:[NSString stringWithFormat:@"https://api.weixin.qq.com/cgi-bin/material/add_news?access_token=%@",accessToken] parameters:dict progressBlock:^(NSProgress *progress) {
        } returnValueBlock:^(id returnValue) {
            if (returnValue[@"media_id"]) {
                if (returnValueBlock) returnValueBlock(returnValue);
            }else{
                if (errorBlock)errorBlock(returnValue);
            }
        } errorBlock:^(NSError *error) {
            if (errorBlock) errorBlock(error);
        }];
    }
}
/*articleModels转数据*/
+ (NSArray*)articleModelsToArray:(NSArray <TXArticle *>*)array{
    if (!array) return  nil;
    NSMutableArray * muarray=[NSMutableArray array];
    for (TXArticle * article in array) {
        [muarray addObject:article.keyValues];
    }
    return muarray;
}
#pragma mark- 2017.6.1 新增接口
/* 发布文章
 *
 * AccessToken 微信AccessToken
 * media_id    media_id
 *
 */
+ (void)releaseArticleWithAccessToken:(NSString*)accessToken media_id:(NSString *)media_id returnValueBlock:(WXReturnValueBlock)returnValueBlock  errorBlock:(WXErrorBlock)errorBlock{
    if (!media_id) {
        if (errorBlock) errorBlock((NSError*)@"没有media_id");
    }else{
        NSString *str=[NSString stringWithFormat:@"{\"filter\":{\"is_to_all\":true},\"mpnews\":{\"media_id\":\"%@\"},\"msgtype\":\"mpnews\"}",media_id];
        [TXWXNetWorking POST:[NSString stringWithFormat:@"https://api.weixin.qq.com/cgi-bin/message/mass/sendall?access_token=%@",accessToken] parameters:str progressBlock:^(NSProgress *progress) {
        } returnValueBlock:^(id returnValue) {
            if ([returnValue[@"errcode"] intValue]==0) {
                if (returnValueBlock){
                    returnValueBlock(returnValue);
                }else{
                    if (errorBlock) errorBlock((NSError*)returnValue);
                }
            }
        } errorBlock:^(NSError *error) {
            if (errorBlock)  errorBlock(error);
        }];
    }
}
/* 新->发布更多图片和文章
 *
 * AccessToken 微信AccessToken
 * isReleaseEnvironment 是否是发布版本
 * images      图片容器
 * wxURLs      微信图文URL容器
 * articles    图文模型容器
 */
+ (void)publishMorePicturesAndArticlesWithAccessToken:(NSString*)accessToken isReleaseEnvironment:(BOOL)isReleaseEnvironment images:(NSArray <UIImage*> *)images wxURLs:(NSArray <NSURL*> *)wxURLs articles:(NSArray <TXArticle*> *)articles returnValueBlock:(WXReturnValueBlock)returnValueBlock  errorBlock:(WXErrorBlock)errorBlock{
    if (!accessToken) {
        if (errorBlock) errorBlock((NSError*)@"没有accessToken");
    }else if (!images){
        if (errorBlock) errorBlock((NSError*)@"没有images");
    }else if (!wxURLs){
        if (errorBlock) errorBlock((NSError*)@"没有wxURLs");
    }else if (!articles){
        if (errorBlock) errorBlock((NSError*)@"没有articles");
    }else{
        [self getImageMedia_idsWithAccessToken:accessToken images:images returnValueBlock:^(id returnValue) {
            NSArray * media_ids=returnValue;
            [self getContentsWithUrls:wxURLs returnValueBlock:^(id returnValue) {
                NSArray * contents=returnValue;
                [self getNewArticlesWithImageMedia_ids:media_ids contents:contents oldArticles:articles returnValueBlock:^(id returnValue) {
                    NSArray * newArticles=returnValue;
                    [self addPicturesAndArticlesToWXWithAccessToken:accessToken newArticles:newArticles returnValueBlock:^(id returnValue) {
                        if (isReleaseEnvironment) {
                          [self releaseArticleWithAccessToken:accessToken media_id:returnValue[@"media_id"] returnValueBlock:returnValueBlock errorBlock:errorBlock];
                        }else{
                            if (returnValueBlock) returnValueBlock(returnValue);
                        }
                    } errorBlock:^(NSError *error) {
                        if (errorBlock)  errorBlock (error);
                    }];
                } errorBlock:^(NSError *error) {
                    if (errorBlock)  errorBlock (error);
                }];
            } errorBlock:^(NSError *error) {
                if (errorBlock)  errorBlock (error);
            }];
        } errorBlock:^(NSError *error) {
            if (errorBlock)  errorBlock (error);
        }];
    }
}
+ (void)publishSeparatePicturesAndArticlesWithAccessToken:(NSString*)accessToken isReleaseEnvironment:(BOOL)isReleaseEnvironment image:(UIImage*)image wxURL:(NSURL*)wxURL article:(TXArticle*)article returnValueBlock:(WXReturnValueBlock)returnValueBlock  errorBlock:(WXErrorBlock)errorBlock{
    if (!accessToken) {
        if (errorBlock) errorBlock((NSError*)@"没有accessToken");
    }else if (!image){
        if (errorBlock) errorBlock((NSError*)@"没有image");
    }else if (!wxURL){
        if (errorBlock) errorBlock((NSError*)@"没有wxURL");
    }else if (!article){
        if (errorBlock) errorBlock((NSError*)@"没有article");
    }else{
        [self getImageMedia_idsWithAccessToken:accessToken images:@[image] returnValueBlock:^(id returnValue) {
            NSArray * media_ids=returnValue;
            [self getContentsWithUrls:@[wxURL] returnValueBlock:^(id returnValue) {
                NSArray * contents=returnValue;
                [self getNewArticlesWithImageMedia_ids:media_ids contents:contents oldArticles:@[article] returnValueBlock:^(id returnValue) {
                    NSArray * newArticles=returnValue;
                    [self addPicturesAndArticlesToWXWithAccessToken:accessToken newArticles:newArticles returnValueBlock:^(id returnValue) {
                        if (isReleaseEnvironment) {
                            [self releaseArticleWithAccessToken:accessToken media_id:returnValue[@"media_id"] returnValueBlock:returnValueBlock errorBlock:errorBlock];
                        }else{
                            if (returnValueBlock) returnValueBlock(returnValue);
                        }
                    } errorBlock:^(NSError *error) {
                        if (errorBlock)  errorBlock (error);
                    }];
                } errorBlock:^(NSError *error) {
                    if (errorBlock)  errorBlock (error);
                }];
            } errorBlock:^(NSError *error) {
                if (errorBlock)  errorBlock (error);
            }];
        } errorBlock:^(NSError *error) {
            if (errorBlock)  errorBlock (error);
        }];
    }
}
/* 新->发布编辑图片和文章
 *
 * AccessToken 微信AccessToken
 * isReleaseEnvironment 是否是发布版本
 * images      图片容器
 * wxURLs      微信图文URL容器
 * articles    图文模型容器
 */
+ (void)publishEditPicturesAndArticlesWithAccessToken:(NSString*)accessToken isReleaseEnvironment:(BOOL)isReleaseEnvironment article:(TXArticle*)article returnValueBlock:(WXReturnValueBlock)returnValueBlock  errorBlock:(WXErrorBlock)errorBlock{
    if (!accessToken) {
        if (errorBlock) errorBlock ((NSError*)@"没有accessToken");
    }else if (!article){
        if (errorBlock) errorBlock ((NSError*)@"没有article");
    }else if ([article.thumb_media_id isEqualToString:@""]){
        if (errorBlock) errorBlock ((NSError*)@"没有封面");
    }else if ([article.title isEqualToString:@""]){
        if (errorBlock) errorBlock ((NSError*)@"没有标题");
    }else if ([article.content isEqualToString:@""]){
        if (errorBlock) errorBlock ((NSError*)@"没有内容");
    }else{
        [self addPicturesAndArticlesToWXWithAccessToken:accessToken newArticles:@[article] returnValueBlock:^(id returnValue) {
            if (isReleaseEnvironment) {
                [self releaseArticleWithAccessToken:accessToken media_id:returnValue[@"media_id"] returnValueBlock:returnValueBlock errorBlock:errorBlock];
            }else{
                if (returnValueBlock) returnValueBlock(returnValue);
            }
        } errorBlock:^(NSError *error) {
            if (errorBlock) errorBlock(error);
        }];
    }
}
#pragma mark- 压缩图片
/*将图片压缩到指定大小*/
+(NSData *)compressOriginalImage:(UIImage *)image toMaxDataSizeKB:(CGFloat)kb{
    if (!image) return nil;
    kb*=1024.0;
    CGFloat compression = 0.9f;
    CGFloat maxCompression = 0.1f;
    NSData *imageData = UIImageJPEGRepresentation(image, compression);
    while ([imageData length] > kb && compression > maxCompression) {
        compression -= 0.1;
        imageData = UIImageJPEGRepresentation(image, compression);
    }
    return imageData;
}
//重新绘制imageSize
+ (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
@end
