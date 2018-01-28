//
//  PHKeyChainHelper.m
//  App
//
//  Created by Alex on 2017/6/19.
//  Copyright © 2017年 項普華. All rights reserved.
//

#import "PHKeyChainHelper.h"
#import <UIKit/UIKit.h>

@implementation PHKeyChainHelper

PH_ShareInstance(PHKeyChainHelper);

- (void)ph_init {
}

+ (NSMutableDictionary *)ph_getKeychainQuery:(NSString *)service{
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (__bridge_transfer id)kSecClassGenericPassword,
            (__bridge_transfer id)kSecClass,service,
            (__bridge_transfer id)kSecAttrService,service,
            (__bridge_transfer id)kSecAttrAccount,
            (__bridge_transfer id)kSecAttrAccessibleAfterFirstUnlock,
            (__bridge_transfer id)kSecAttrAccessible,
            nil];
}

+ (void)ph_saveKeychainValue:(NSString *)aValue key:(NSString *)aKey{
    if (!aKey) {
        return ;
    }
    if(!aValue) {
        aValue = @"";
    }
    NSMutableDictionary * keychainQuery = [self ph_getKeychainQuery:aKey];
    SecItemDelete((__bridge_retained CFDictionaryRef)keychainQuery);
    
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:aValue] forKey:(__bridge_transfer id)kSecValueData];
    
    SecItemAdd((__bridge_retained CFDictionaryRef)keychainQuery, NULL);
    if (keychainQuery) {
        CFRelease((__bridge CFTypeRef)(keychainQuery));
    }
}

+ (NSString *)ph_readValueWithKeychain:(NSString *)aKey
{
    NSString *ret = nil;
    NSMutableDictionary *keychainQuery = [self ph_getKeychainQuery:aKey];
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(__bridge_transfer id)kSecReturnData];
    [keychainQuery setObject:(__bridge_transfer id)kSecMatchLimitOne forKey:(__bridge_transfer id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((__bridge CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            ret = (NSString *)[NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
        } @catch (NSException *e) {
            PHLogWarn(@"Unarchive of %@ failed: %@", aKey, e);
        } @finally {
        }
    }
    if (keyData)
        CFRelease(keyData);
    return ret;
}

+ (void)ph_deleteKeychainValue:(NSString *)aKey {
    NSMutableDictionary *keychainQuery = [self ph_getKeychainQuery:aKey];
    SecItemDelete((__bridge CFDictionaryRef)keychainQuery);
}

+ (NSString *)ph_uuid {
    NSString *deviceId = [PHKeyChainHelper ph_readValueWithKeychain:@"Key_DeviceUUIDString"];
    if (!deviceId || !deviceId.length) {
        deviceId = [[UIDevice currentDevice].identifierForVendor UUIDString];
        [PHKeyChainHelper ph_saveKeychainValue:deviceId key:@"Key_DeviceUUIDString"];
    }
    return deviceId;
}

@end
