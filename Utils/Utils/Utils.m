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
#import <ContactsUI/ContactsUI.h>

@implementation Utils

RCT_EXPORT_MODULE();

#pragma mark - 获取app唯一id 保存到钥匙串中
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

#pragma mark - 获取app信息
- (NSDictionary<NSString *,id> *)constantsToExport {
    return @{
             //版本号
             @"versionCode" : [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"],
             @"versionName" : [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"],
             @"deviceId":[self getDeviceId],
             };
}

#pragma mark -  退出app
RCT_EXPORT_METHOD(exitApp) {
    exit(0);
}

#pragma mark -  图片转base64
RCT_EXPORT_METHOD(imageToBase64:(NSString *)imageName
                  Success:(RCTResponseSenderBlock)success
                  Error:(RCTResponseSenderBlock)error) {
    
    NSArray *tempArray = [imageName componentsSeparatedByString:@"/tmp/"];
    NSString *path = [NSString stringWithFormat:@"%@%@", NSTemporaryDirectory(), tempArray[1]];
    @try {
        UIImage *image = [UIImage imageWithContentsOfFile:path];
        UIImage *newImage = [self imageWithImage:image scaledToSize:CGSizeMake(1000, 1333)];
        NSData *imageData = UIImageJPEGRepresentation(newImage, 0.3);//这句话就是压缩图片的比例
        NSString *imageBase64Str = [imageData base64EncodedStringWithOptions:0];
        success(@[imageBase64Str]);
    } @catch (NSException *exception) {
        error(@[@"图片转码失败"]);
    } @finally {
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        if ([fileMgr fileExistsAtPath:path]) {
            NSError *err;
            [fileMgr removeItemAtPath:path error:&err];
        }
    }
}

- (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize {
    
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
    
}

#pragma mark -  打电话
RCT_EXPORT_METHOD(callPhone:(NSString *)phoneNum) {
    NSString *str = [[NSString alloc] initWithFormat:@"telprompt://%@", phoneNum];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

@end
