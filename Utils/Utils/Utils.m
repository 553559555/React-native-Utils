//
//  Utils.m
//  Utils
//
//  Created by 王壮 on 2017/6/23.
//  Copyright © 2017年 Arther. All rights reserved.
//

#import "Utils.h"
#import "SAMKeychain.h"
#import <UIKit/UIDevice.h>


@implementation Utils

RCT_EXPORT_MODULE();

- (NSString *)getDeviceId {
    
    NSString * currentDeviceUUIDStr = [SAMKeychain passwordForService:@"com.neoby.BY" account:@"uuid"];
    if (currentDeviceUUIDStr == nil || [currentDeviceUUIDStr isEqualToString:@""])
    {
        NSUUID * currentDeviceUUID  = [UIDevice currentDevice].identifierForVendor;
        currentDeviceUUIDStr = currentDeviceUUID.UUIDString;
        currentDeviceUUIDStr = [currentDeviceUUIDStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
        currentDeviceUUIDStr = [currentDeviceUUIDStr lowercaseString];
        [SAMKeychain setPassword: currentDeviceUUIDStr forService:@"com.neoby.BY" account:@"uuid"];
    }
    return currentDeviceUUIDStr;
}

- (NSDictionary<NSString *,id> *)constantsToExport {
    return @{
             //版本号
             @"versionCode" : [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"],
             @"versionName" : [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"],
             @"deviceId":[self getDeviceId],
             };
}

@end
