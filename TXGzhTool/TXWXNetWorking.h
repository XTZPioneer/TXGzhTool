//
//  TXWXNetWorking.h
//  WX_GZH_Demo
//
//  Created by  杭州信配iOS开发 on 2017/5/4.
//  Copyright © 2017年  杭州信配iOS开发. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface TXWXNetWorking : NSObject
/*微信POST请求*/
+ (void)POST:(NSString*)url parameters:(id)parameters progressBlock:(void (^)(NSProgress * progress))progressBlock returnValueBlock:(void (^) (id returnValue))returnValueBlock errorBlock:(void (^) (NSError*error))errorBlock;
/*微信上传*/
+ (void)uploadWithUrl:(NSString*)url parameters:(id)parameters filename:(NSString*)filename mimeType:(NSString*)mimeType fileData:(NSData*)fileData progressBlock:(void (^)(NSProgress * progress))progressBlock returnValueBlock:(void (^) (id returnValue))returnValueBlock errorBlock:(void (^) (NSError*error))errorBlock;

@end
