//
//  NSURL+Extension.m
//  WCExtensions
//
//  Created by liguoliang on 2018/9/10.
//

#import "NSURL+Extension.h"
#import <netdb.h>
#import <arpa/inet.h>

@implementation NSURL (Extension)
- (NSDictionary *)querys {
    NSString *paramstr = self.query;
    NSArray *split = [paramstr componentsSeparatedByString:@"&"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [split enumerateObjectsUsingBlock:^(NSString *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        NSString *key = [obj substringToIndex:[obj rangeOfString:@"="].location];
        NSString *value = [obj substringFromIndex:[obj rangeOfString:@"="].location + 1];
        dic[key] = value;
    }];
    return [dic copy];
}

- (NSArray *)ipAdress {
    NSMutableArray *tempDNS = [[NSMutableArray alloc] init];
    CFHostRef hostRef = CFHostCreateWithName(kCFAllocatorDefault, (__bridge CFStringRef)[self host]);
    if (hostRef) {
        Boolean result = CFHostStartInfoResolution(hostRef, kCFHostAddresses, NULL);
        if (result == TRUE) {
            NSArray *addresses = (__bridge NSArray *)CFHostGetAddressing(hostRef, &result);
            if (addresses) {
                for (int i = 0; i < addresses.count; i++) {
                    CFDataRef saData = (CFDataRef)CFArrayGetValueAtIndex((__bridge CFArrayRef)addresses, i);
                    struct sockaddr_in6 *remoteAddr6 = (struct sockaddr_in6 *)CFDataGetBytePtr(saData);
                    struct sockaddr_in *remoteAddr4 = (struct sockaddr_in *)CFDataGetBytePtr(saData);
                    if (remoteAddr6 != NULL) {
                        char ip[INET6_ADDRSTRLEN] = { 0 };
                        const char *strIP61 = inet_ntop(PF_INET6, &remoteAddr6->sin6_addr, ip, sizeof(ip));
                        NSString *strDNS = [NSString stringWithCString:strIP61 encoding:NSASCIIStringEncoding];
                        if (strDNS && ![strDNS isEqualToString:@"::"]) [tempDNS addObject:strDNS];
                    }
                    if (remoteAddr4 != NULL) {
                        const char *strIP41 = inet_ntoa(remoteAddr4->sin_addr);
                        NSString *strDNS = [NSString stringWithCString:strIP41 encoding:NSASCIIStringEncoding];
                        if (strDNS && ![strDNS isEqualToString:@"0.0.0.0"]) [tempDNS addObject:strDNS];
                    }
                }
            }
        }
    }
    CFRelease(hostRef);
    return [tempDNS copy];
}

@end
