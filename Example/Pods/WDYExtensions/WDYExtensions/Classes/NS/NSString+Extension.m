//
//  NSString+Extension.m
//  WCExtensions_Example
//
//  Created by liguoliang on 2018/9/6.
//  Copyright © 2018年 liguoliang. All rights reserved.
//

#import "NSString+Extension.h"
#import <CommonCrypto/CommonDigest.h>

#define kURLEncodeCharters "?!@#$^&%*+,:;='\"`<>()[]{}/\\| "

@implementation NSString (Extension)

- (NSString *)trim {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString*)URLEncode { // mk_ prefix prevents a clash with a private api
    CFStringRef encodedCFString = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(__bridge CFStringRef) self,nil,CFSTR(kURLEncodeCharters),kCFStringEncodingUTF8);
    NSString *encodedString = [[NSString alloc] initWithString:(__bridge_transfer NSString*) encodedCFString];
    if(!encodedString)
        encodedString = @"";
    return encodedString;
}

- (NSString*)URLDecode {
    CFStringRef decodedCFString = CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault, (__bridge CFStringRef) self, CFSTR(""), kCFStringEncodingUTF8);
    if (decodedCFString) {
        NSString *decodedString = [[NSString alloc] initWithString:(__bridge_transfer NSString*) decodedCFString];
        if (decodedString) {
            decodedString = [decodedString stringByReplacingOccurrencesOfString:@"+" withString:@" "];
            decodedString = [decodedString stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
            return decodedString;
        }
    }
    return @"";
}

-(BOOL)isContain:(NSString*)str {
    NSRange range = [self rangeOfString:str];
    return (range.location==NSNotFound?NO:YES);
}

- (BOOL)hasChinese {
    for(int i=0; i< [self length];i++) {
        int a = [self characterAtIndex:i];
        if(a > 0x4e00 && a < 0x9fff){
            return YES;
        }
    }
    return NO;
}

- (NSString*)md5 {
    const char * cStr = [self UTF8String];
    unsigned char result[32];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), result );
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

- (NSData *)base64Decode{
    unsigned long ixtext, lentext;
    unsigned char ch, inbuf[4], outbuf[4];
    short i, ixinbuf;
    Boolean flignore, flendtext = false;
    const unsigned char *tempcstring;
    NSMutableData *theData;
    ixtext = 0;
    tempcstring = (const unsigned char *)[self UTF8String];
    lentext = [self length];
    theData = [NSMutableData dataWithCapacity: lentext];
    ixinbuf = 0;
    while (true) {
        if (ixtext >= lentext){break;}
        ch = tempcstring [ixtext++];
        flignore = false;
        if ((ch >= 'A') && (ch <= 'Z')) {
            ch = ch - 'A';
        } else if ((ch >= 'a') && (ch <= 'z')) {
            ch = ch - 'a' + 26;
        } else if ((ch >= '0') && (ch <= '9')) {
            ch = ch - '0' + 52;
        } else if (ch == '+') {
            ch = 62;
        } else if (ch == '=') {
            flendtext = true;
        } else if (ch == '/') {
            ch = 63;
        } else {
            flignore = true;
        }
        if (!flignore) {
            short ctcharsinbuf = 3;
            Boolean flbreak = false;
            if (flendtext) {
                if (ixinbuf == 0) {break;}
                if ((ixinbuf == 1) || (ixinbuf == 2))
                    ctcharsinbuf = 1;
                else
                    ctcharsinbuf = 2;
                ixinbuf = 3;
                flbreak = true;
            }
            inbuf [ixinbuf++] = ch;
            if (ixinbuf == 4) {
                ixinbuf = 0;
                outbuf[0] = (inbuf[0] << 2) | ((inbuf[1] & 0x30) >> 4);
                outbuf[1] = ((inbuf[1] & 0x0F) << 4) | ((inbuf[2] & 0x3C) >> 2);
                outbuf[2] = ((inbuf[2] & 0x03) << 6) | (inbuf[3] & 0x3F);
                for (i = 0; i < ctcharsinbuf; i++)
                    [theData appendBytes: &outbuf[i] length: 1];
            }
            if (flbreak) {break;}
        }
    }
    return theData;
}

- (NSString *)stringForRegular:(NSString *)regular {
    return [self itemForPattern:regular captureGroupIndex:0];
}

- (NSString *)itemForPattern:(NSString *)pattern captureGroupIndex:(NSUInteger)index {
    if (!pattern)
        return nil;
    NSError *error = nil;
    NSRegularExpression *regx = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    if (!error){
        NSRange searchRange = NSMakeRange(0, [self length]);
        NSTextCheckingResult *result = [regx firstMatchInString:self options:NSMatchingReportCompletion range:searchRange];
        if(result){
            NSRange groupRange = [result rangeAtIndex:index];
            NSString *match = [self substringWithRange:groupRange];
            return match;
        }
    }
    return nil;
}
/** 表情符号的判断 */
- (BOOL)stringContainsEmoji{
    __block BOOL returnValue = NO;
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar hs = [substring characterAtIndex:0];
                                if (0xd800 <= hs && hs <= 0xdbff) {
                                    if (substring.length > 1) {
                                        const unichar ls = [substring characterAtIndex:1];
                                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                        if (0x1d000 <= uc && uc <= 0x1f77f) {
                                            returnValue = YES;
                                        }
                                    }
                                } else if (substring.length > 1) {
                                    const unichar ls = [substring characterAtIndex:1];
                                    if (ls == 0x20e3) {
                                        returnValue = YES;
                                    }
                                } else {
                                    if (0x2100 <= hs && hs <= 0x27ff) {
                                        returnValue = YES;
                                    } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                        returnValue = YES;
                                    } else if (0x2934 <= hs && hs <= 0x2935) {
                                        returnValue = YES;
                                    } else if (0x3297 <= hs && hs <= 0x3299) {
                                        returnValue = YES;
                                    } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                        returnValue = YES;
                                    }
                                }
                            }];
    if (!returnValue) {//限制第三方键盘的表情
        NSString *pattern = @"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
        returnValue = [pred evaluateWithObject:self];
    }
    return returnValue;
}
/** 判断是不是九宫格拼音键盘 */
- (BOOL)isNineKeyBoard{
    NSString *other = @"➋➌➍➎➏➐➑➒";
    if(!([other rangeOfString:self].location != NSNotFound)){
        return NO;
    }
    return YES;
}

/*** 去掉html标签*/
- (NSString *)removeHtmlTag{
    NSRegularExpression *regularExpretion = [NSRegularExpression regularExpressionWithPattern:@"<[^>]*>|\n|&nbsp"
                                                                                    options:0
                                                                                      error:nil];
   NSString *string = [regularExpretion stringByReplacingMatchesInString:self options:NSMatchingReportProgress range:NSMakeRange(0, self.length) withTemplate:@""];
    return string;
}
/** 计算字符串size */
- (CGSize)boundingRectWithSize:(CGSize)size withFont:(UIFont *)font{
    CGSize titleSize = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    return titleSize;
}
@end
