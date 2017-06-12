//
//  TXAnalysisWXHTML.h
//  XPWGLQIANTAI
//
//  Created by  杭州信配iOS开发 on 2017/5/26.
//  Copyright © 2017年  杭州信配iOS开发. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef  void (^AHReturnValueBlock) (id returnValue);
typedef  void (^AHErrorBlock)       (NSError * error);


@interface TXAnalysisWXHTML : NSObject
/*下载源代码*/
+ (void)downloadSourceCodeWithURL:(NSURL*)url returnValueBlock:(AHReturnValueBlock)returnValueBlock errorBlock:(AHErrorBlock)errorBlock;

/*获取微信公众号图文内容*/
+ (NSString*)getWXNewsContentWithWXHTMLSourceCode:(NSString*)html;

/*一键获取微信公众号图文内容*/
+ (void)getWXNewsContentWithWXURL:(NSURL*)url returnValueBlock:(AHReturnValueBlock)returnValueBlock errorBlock:(AHErrorBlock)errorBlock;
@end
