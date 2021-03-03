//
//  Tools.m
//  ObjCDemo
//
//  Created by liguoliang on 2021/3/3.
//

#import "Tools.h"

@implementation Tools

/* 计算 多件商品的价格 */
+ (NSString *)priceForProduct:(NSString *)productID Count:(int)count {
    count = count>0 ?: 1;
    double productPrice = 0;
    if([productID isEqualToString:@"01001"]) {
        productPrice = 7999 * count;
    }
    return [NSString stringWithFormat:@"¥%.2f", productPrice];
}

@end
