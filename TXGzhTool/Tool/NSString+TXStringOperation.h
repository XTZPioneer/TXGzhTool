//
//  NSString+TXStringOperation.h
//  XPWGLQIANTAI
//
//  Created by  杭州信配iOS开发 on 2017/5/26.
//  Copyright © 2017年  杭州信配iOS开发. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (TXStringOperation)
/*字符串截取*/
- (NSArray *)componentsSeparatedFromString:(NSString *)fromString toString:(NSString *)toString;
@end
