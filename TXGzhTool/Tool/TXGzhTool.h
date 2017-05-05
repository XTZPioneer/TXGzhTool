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
/*完成块*/
typedef void (^CompletionBlock)(id returnValue);
/*错误块*/
typedef void (^ErrorBlock)       (NSError * error);

@interface TXGzhTool : NSObject
/*上传素材*/
+ (void)uploadMaterialWithAccessToken:(NSString*)accessToken image:(UIImage*)image article:(TXArticle*)article completionBlock:(CompletionBlock)completionBlock  errorBlock:(ErrorBlock)errorBlock;
@end
