//
//  NSString+TXStringOperation.m
//  XPWGLQIANTAI
//
//  Created by  杭州信配iOS开发 on 2017/5/26.
//  Copyright © 2017年  杭州信配iOS开发. All rights reserved.
//

#import "NSString+TXStringOperation.h"

@implementation NSString (TXStringOperation)
/*字符串截取*/
- (NSArray *)componentsSeparatedFromString:(NSString *)fromString toString:(NSString *)toString{
    if (!fromString || !toString || fromString.length == 0 || toString.length == 0) {
        return nil;
    }
    NSMutableArray *subStringsArray = [[NSMutableArray alloc] init];
    NSString *tempString = self;
    NSRange range = [tempString rangeOfString:fromString];
    while (range.location != NSNotFound) {
        tempString = [tempString substringFromIndex:(range.location + range.length)];
        range = [tempString rangeOfString:toString];
        if (range.location != NSNotFound) {
            [subStringsArray addObject:[tempString substringToIndex:range.location]];
            range = [tempString rangeOfString:fromString];
        }else{
            break;
        }
    }
    return subStringsArray;
}
@end
