//
//  TXWXNetWorking.m
//  WX_GZH_Demo
//
//  Created by  杭州信配iOS开发 on 2017/5/4.
//  Copyright © 2017年  杭州信配iOS开发. All rights reserved.
//

#import "TXWXNetWorking.h"
#import <AFNetworking.h>

#define TXFileBoundary @"media"
#define TXNewLine @"\r\n"
#define TXEncode(str) [str dataUsingEncoding:NSUTF8StringEncoding]

@implementation TXWXNetWorking
/*微信POST请求*/
+ (void)POST:(NSString*)url parameters:(id)parameters progressBlock:(void (^)(NSProgress * progress))progressBlock returnValueBlock:(void (^) (id returnValue))returnValueBlock errorBlock:(void (^) (NSError*error))errorBlock{
    if (!url) {
        if (errorBlock) {
            errorBlock((NSError*)@"没有url");
        }
    }else if (!parameters){
        if (errorBlock) {
            errorBlock((NSError*)@"没有parameters");
        }
    }else{
        
        //创建AFHTTPSessionManager
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        //设置contentType
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html,",@"text/plain", nil];
        //创建 URL
        NSURL * URL=[NSURL URLWithString:url];
        // 2. 创建请求
        NSMutableURLRequest *mulRequest = [NSMutableURLRequest requestWithURL:URL];
        // 2.5 规定请求方式为POST请求
        [mulRequest setHTTPMethod:@"POST"];
        NSData  * jsonData;
        NSError * error;
        jsonData= [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:&error];
        // 设置请求头，01 - 设置请求数据的长度
        [mulRequest setValue:[NSString stringWithFormat:@"%lu",jsonData.length] forHTTPHeaderField:@"Content-Length"];
        /*
         * 重点
         */
        [mulRequest setHTTPBody:jsonData];
        NSURLSessionUploadTask *uploadTask;
        uploadTask = [manager
                      uploadTaskWithStreamedRequest:mulRequest
                      progress:^(NSProgress * _Nonnull uploadProgress) {
                          if (progressBlock) {
                              progressBlock(uploadProgress);
                          }
                      }
                      completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                          if (errorBlock) {
                              errorBlock(error);
                          }
                          if (returnValueBlock) {
                              returnValueBlock(responseObject);
                          }
                      }
                      ];
        [uploadTask resume];
    }
}
/*微信上传*/
+ (void)uploadWithUrl:(NSString*)url parameters:(id)parameters filename:(NSString*)filename mimeType:(NSString*)mimeType fileData:(NSData*)fileData progressBlock:(void (^)(NSProgress * progress))progressBlock returnValueBlock:(void (^) (id returnValue))returnValueBlock errorBlock:(void (^) (NSError*error))errorBlock{
    if (!url) {
        if (errorBlock) {
            errorBlock((NSError*)@"没有url");
        }
    }else if (!parameters){
        if (errorBlock) {
            errorBlock((NSError*)@"没有parameters");
        }
    }else if (!filename){
        if (errorBlock) {
            errorBlock((NSError*)@"没有filename");
        }
    }else if (!mimeType){
        if (errorBlock) {
            errorBlock((NSError*)@"没有mimeType");
        }
    }else if (!fileData){
        if (errorBlock) {
            errorBlock((NSError*)@"没有fileData");
        }
    }else{
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html,",@"text/plain", nil];
        NSURL * URL = [NSURL URLWithString:url];
        // 2.创建一个POST请求
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
        request.HTTPMethod = @"POST";
        // 3.设置请求体
        NSMutableData *body = [NSMutableData data];
        // 3.1.文件参数
        [body appendData:TXEncode(@"--")];
        [body appendData:TXEncode(TXFileBoundary)];
        [body appendData:TXEncode(TXNewLine)];
        /*
         * 注意 ：name="file" 改为：name="media"
         */
        NSString *disposition = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"", TXFileBoundary,filename];
        [body appendData:TXEncode(disposition)];
        [body appendData:TXEncode(TXNewLine)];
        
        NSString *type = [NSString stringWithFormat:@"Content-Type:%@",mimeType];
        [body appendData:TXEncode(type)];
        [body appendData:TXEncode(TXNewLine)];
        
        [body appendData:TXEncode(TXNewLine)];
        [body appendData:fileData];
        [body appendData:TXEncode(TXNewLine)];
        
        // 3.2.非文件参数
        [parameters enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [body appendData:TXEncode(@"--")];
            [body appendData:TXEncode(TXFileBoundary)];
            [body appendData:TXEncode(TXNewLine)];
            
            NSString *disposition = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"", key];
            [body appendData:TXEncode(disposition)];
            [body appendData:TXEncode(TXNewLine)];
            
            [body appendData:TXEncode(TXNewLine)];
            [body appendData:TXEncode([obj description])];
            [body appendData:TXEncode(TXNewLine)];
        }];
        
        // 3.3.结束标记
        [body appendData:TXEncode(@"--")];
        [body appendData:TXEncode(TXFileBoundary)];
        [body appendData:TXEncode(@"--")];
        [body appendData:TXEncode(TXNewLine)];
        
        request.HTTPBody = body;
        
        // 4.设置请求头(告诉服务器这次传给你的是文件数据，告诉服务器现在发送的是一个文件上传请求)
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", TXFileBoundary];
        [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
        NSURLSessionUploadTask *uploadTask;
        uploadTask = [manager
                      uploadTaskWithStreamedRequest:request
                      progress:^(NSProgress * _Nonnull uploadProgress) {
                          
                      }
                      completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                          if (errorBlock) {
                              errorBlock(error);
                          }
                          if (returnValueBlock) {
                              returnValueBlock(responseObject);
                          }
                      }];
        [uploadTask resume];
    }
}
@end
