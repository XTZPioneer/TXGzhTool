//
//  TXGzhTool.h
//  WX_GZH_Demo
//
//  Created by  杭州信配iOS开发 on 2017/5/5.
//  Copyright © 2017年  张天雄. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TXArticle.h"
#import "TXWXNetWorking.h"
#import "TXAnalysisWXHTML.h"
#pragma mark- 2017.5.26 新增类型
/*进度块*/
typedef void (^WXProgressBlock)    (NSProgress * progress);
/*返回块*/
typedef void (^WXReturnValueBlock) (id returnValue);
/*错误块*/
typedef void (^WXErrorBlock)       (NSError * error);
/*上传Image的类型*/
typedef NS_ENUM(NSInteger,WXUploadImageType){
    WXImageType=0,//图片
    WXThumbType=1,//缩略图
};

@interface TXGzhTool : NSObject
#pragma mark- 2017.5.26 新增接口
/* 上传图片到微信
 *
 * AccessToken     微信AccessToken
 * isPermanent     是否为永久素材
 * uploadImageType 上传Image的类型
 * image           需要上传的image
 *
 */
+ (void)uploadImageToWXWithAccessToken:(NSString*)accessToken isPermanent:(BOOL)isPermanent uploadImageType:(WXUploadImageType)uploadType  image:(UIImage*)image progressBlock:(WXProgressBlock)progressBlock returnValueBlock:(WXReturnValueBlock)returnValueBlock  errorBlock:(WXErrorBlock)errorBlock;


#pragma mark- 2017.5.27 新增接口
/* 获取ImageMedia_ids
 *
 * AccessToken 微信AccessToken
 * images      图片容器
 */
+ (void)getImageMedia_idsWithAccessToken:(NSString*)accessToken images:(NSArray <UIImage*> *)images returnValueBlock:(WXReturnValueBlock)returnValueBlock errorBlock:(WXErrorBlock)errorBlock;

/* 获取文章Contents
 *
 * AccessToken 微信AccessToken
 * urls      url容器
 */
+ (void)getContentsWithUrls:(NSArray <NSURL*> *)urls returnValueBlock:(WXReturnValueBlock)returnValueBlock errorBlock:(WXErrorBlock)errorBlock;

/* 获取完整Articles
 *
 * ImageMedia_ids ImageMedia_id容器
 * contents       内容容器
 * oldArticles    旧的articles
 */
+ (void)getNewArticlesWithImageMedia_ids:(NSArray <NSString*> *)media_ids contents:(NSArray <NSString*> *)contents oldArticles:(NSArray <TXArticle*> *)oldArticles returnValueBlock:(WXReturnValueBlock)returnValueBlock errorBlock:(WXErrorBlock)errorBlock;


/* 添加到素材库
 *
 * AccessToken 微信AccessToken
 * newArticles 新的文章容器
 */
+ (void)addPicturesAndArticlesToWXWithAccessToken:(NSString*)accessToken newArticles:(NSArray <TXArticle*> *)newArticles returnValueBlock:(WXReturnValueBlock)returnValueBlock  errorBlock:(WXErrorBlock)errorBlock;

/*articleModels转数据*/
+ (NSArray*)articleModelsToArray:(NSArray <TXArticle *>*)array;

#pragma mark- 2017.6.1 新增接口
/* 发布文章
 *
 * AccessToken 微信AccessToken
 * media_id    media_id
 *
 */
+ (void)releaseArticleWithAccessToken:(NSString*)accessToken media_id:(NSString *)media_id returnValueBlock:(WXReturnValueBlock)returnValueBlock  errorBlock:(WXErrorBlock)errorBlock;

/* 新->发布多图片和文章
 *
 * AccessToken 微信AccessToken
 * isReleaseEnvironment 是否是发布版本
 * images      图片容器
 * wxURLs      微信图文URL容器
 * articles    图文模型容器
 */
+ (void)publishMorePicturesAndArticlesWithAccessToken:(NSString*)accessToken isReleaseEnvironment:(BOOL)isReleaseEnvironment images:(NSArray <UIImage*> *)images wxURLs:(NSArray <NSURL*> *)wxURLs articles:(NSArray <TXArticle*> *)articles returnValueBlock:(WXReturnValueBlock)returnValueBlock  errorBlock:(WXErrorBlock)errorBlock;

/* 新->发布单图片和文章
 *
 * AccessToken 微信AccessToken
 * isReleaseEnvironment 是否是发布版本
 * images      图片容器
 * wxURLs      微信图文URL容器
 * articles    图文模型容器
 */
+ (void)publishSeparatePicturesAndArticlesWithAccessToken:(NSString*)accessToken isReleaseEnvironment:(BOOL)isReleaseEnvironment image:(UIImage*)image wxURL:(NSURL*)wxURL article:(TXArticle*)article returnValueBlock:(WXReturnValueBlock)returnValueBlock  errorBlock:(WXErrorBlock)errorBlock;

/* 新->发布编辑图片和文章
 *
 * AccessToken 微信AccessToken
 * isReleaseEnvironment 是否是发布版本
 * images      图片容器
 * wxURLs      微信图文URL容器
 * articles    图文模型容器
 */
+ (void)publishEditPicturesAndArticlesWithAccessToken:(NSString*)accessToken isReleaseEnvironment:(BOOL)isReleaseEnvironment article:(TXArticle*)article returnValueBlock:(WXReturnValueBlock)returnValueBlock  errorBlock:(WXErrorBlock)errorBlock;

#pragma mark- 压缩图片
/*将图片压缩到指定大小*/
+(NSData *)compressOriginalImage:(UIImage *)image toMaxDataSizeKB:(CGFloat)kb;
//重新绘制imageSize
+ (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;
@end
