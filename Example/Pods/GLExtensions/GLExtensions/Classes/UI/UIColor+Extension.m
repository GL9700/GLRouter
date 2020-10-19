//
//  UIColor+Extension.m
//  WCExtensions
//
//  Created by liguoliang on 2018/9/10.
//

#import "UIColor+Extension.h"

@implementation UIColor (Extension)
+ (instancetype)colorFromHexValue:(uint32_t)hex {
    uint8_t r = (hex & 0xff0000) >> 16;
    uint8_t g = (hex & 0x00ff00) >> 8;
    uint8_t b = hex & 0x0000ff;
    return  [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}
+ (instancetype)colorFromHexStr:(NSString *)hexStr {
    NSString *sp = [hexStr hasPrefix:@"0x"] ? @"0x" : [hexStr hasPrefix:@"0X"] ? @"0X": [hexStr hasPrefix:@"#"] ? @"#" : nil;
    return [self colorFromHexStr:hexStr headStr:sp];
}
+ (instancetype)colorFromHexStr:(NSString *)hexStr headStr:(NSString *)str {
    NSString *sp = str ? str : @"";
    NSString *colorString = [[hexStr stringByReplacingOccurrencesOfString:sp withString:@""] uppercaseString];
    CGFloat alpha, red, blue, green;
    switch ([colorString length]) {
        case 3: // #RGB
            alpha = 1.0f;
            red = [self colorComponentFrom:colorString start:0 length:1 Case:1];
            green = [self colorComponentFrom:colorString start:1 length:1 Case:2];
            blue = [self colorComponentFrom:colorString start:2 length:1 Case:3];
            break;
        case 4: // #ARGB
            alpha = [self colorComponentFrom:colorString start:0 length:1 Case:0];
            red = [self colorComponentFrom:colorString start:1 length:1 Case:1];
            green = [self colorComponentFrom:colorString start:2 length:1 Case:2];
            blue = [self colorComponentFrom:colorString start:3 length:1 Case:3];
            break;
        case 6: // #RRGGBB
            alpha = 1.0f;
            red = [self colorComponentFrom:colorString start:0 length:2 Case:1];
            green = [self colorComponentFrom:colorString start:2 length:2 Case:2];
            blue = [self colorComponentFrom:colorString start:4 length:2 Case:3];
            break;
        case 8: // #AARRGGBB
            alpha = [self colorComponentFrom:colorString start:0 length:2 Case:0];
            red = [self colorComponentFrom:colorString start:2 length:2 Case:1];
            green = [self colorComponentFrom:colorString start:4 length:2 Case:2];
            blue = [self colorComponentFrom:colorString start:6 length:2 Case:3];
            break;
        default:
            return nil;
            break;
    }
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}
+ (CGFloat)colorComponentFrom:(NSString *)string start:(NSUInteger)start length:(NSUInteger)length Case:(int)ARGB {
    NSString *substring = [string substringWithRange:NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat:@"%@%@", substring, substring];
    unsigned hexComponent;
    [[NSScanner scannerWithString:fullHex] scanHexInt:&hexComponent];
    switch (ARGB) {
        case 0://alpha
            return hexComponent / 255.0;
            break;
        case 1://red
            return (hexComponent) / 255.0;
            break;
        case 2://green
            return (hexComponent) / 255.0;
            break;
        case 3://blue
            return (hexComponent) / 255.0;
            break;
        default:
            break;
    }
    return 0;
}

@end
