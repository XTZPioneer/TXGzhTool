//
//  TXAnalysisWXHTML.m
//  XPWGLQIANTAI
//
//  Created by  杭州信配iOS开发 on 2017/5/26.
//  Copyright © 2017年  杭州信配iOS开发. All rights reserved.
//

#import "TXAnalysisWXHTML.h"
#import "NSString+TXStringOperation.h"
@implementation TXAnalysisWXHTML
/*下载源代码*/
+ (void)downloadSourceCodeWithURL:(NSURL*)url returnValueBlock:(AHReturnValueBlock)returnValueBlock errorBlock:(AHErrorBlock)errorBlock{
    if (!url) {
        if (errorBlock) errorBlock((NSError*)@"没有URL");
    }else{
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDownloadTask *task = [session downloadTaskWithURL:url completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
            NSString * sourceCode=[NSString stringWithContentsOfURL:location encoding:NSUTF8StringEncoding error:nil];
            if (response) {
                if (returnValueBlock) returnValueBlock(sourceCode);
            }
            if (error) {
                if (errorBlock)  returnValueBlock(error);
            }
        }];
        [task resume];
    }
}
/*获取微信公众号图文内容*/
+ (NSString*)getWXNewsContentWithWXHTMLSourceCode:(NSString*)html{
    NSString * content=nil;
    if (html) {
        NSString * start=@"<div class=\"rich_media_content \" id=\"js_content\">";
        NSString * end=@"</div>";
        NSArray *htmls = [html componentsSeparatedFromString:start toString:end];
        if (htmls.count>0) {
            content=htmls[0];
        }
    }
    return content;
}
/*一键获取微信公众号图文内容*/
+ (void)getWXNewsContentWithWXURL:(NSURL*)url returnValueBlock:(AHReturnValueBlock)returnValueBlock errorBlock:(AHErrorBlock)errorBlock{
    if (!url) {
        if (errorBlock) errorBlock((NSError*)@"没有URL");
    }else{
        [self downloadSourceCodeWithURL:url returnValueBlock:^(id returnValue) {
            if (returnValueBlock) {
                returnValueBlock([self getWXNewsContentWithWXHTMLSourceCode:returnValue]);
            };
        } errorBlock:^(NSError *error) {
            if (errorBlock) {
                errorBlock(error);
            }
        }];
    }
}
@end
