//
//  PHPayUtils.m
//  PayTest
//
//  Created by user on 16/8/16.
//  Copyright © 2016年 phxiang. All rights reserved.
//

#import "PHPayUtils.h"
#include <sys/sysctl.h>
#import <CommonCrypto/CommonDigest.h>

@implementation PHPayUtils


+ (NSString *)MD5:(NSString *)sender
{
    const char*cStr =[sender UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    return[[NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ] lowercaseString];
}


+ (BOOL)validString:(NSString *)sender {
    if (!sender) {
        return NO;
    }
    if (![sender isKindOfClass:[NSString class]]) {
        return NO;
    }
    if (sender.length == 0) {
        return NO;
    }
    if ([sender isEqualToString:@"(null)"] || [sender isEqualToString:@"null"]) {
        return NO;
    }
    return YES;
}

+ (NSString*)doRsa:(NSString *)orderInfo {
    id<DataSigner> signer;
    signer = CreateRSADataSigner(@"MIICdQIBADANBgkqhkiG9w0BAQEFAASCAl8wggJbAgEAAoGBAKLfMdEnNOcwi8ExwhO9Qp9uhU2uUeSi8XPZBd5Ub24E3eCCpwy9Ye0v9NVUBQWbUpNIho7KIsDCQCrYnk2ktZ+df1aNJn0Xz9E6D7cB+USlN5slwm1eXbMg5081skFJiQKapQKDPf9r2DSMBkcpvHeGdILb6ISExP09k2Nu7EXjAgMBAAECgYBXkhPx9dee+l4aGQvVmywIFt97nd+QQ//4ntZl7RYgnGNDxFvXILhXVDKaxNsSYanrYNJgUdSPuaHQp7mt24J/HRXnUNLJNZ2sMu0cN+K8oJiWVgLW6dHSFPNc9LboPBB0EkRlAwe+SY1eOoiFi1rie+SaYmB0itKM5Scp5yXgqQJBAMzRo0RHU6Wr5+qLGJMHWpwo+SkgxNabx+rTnQkbo63mWDFTanmiLL80oaIpZPEbTSxu+5N42ULhQp7KjK3r+N8CQQDLki88gXxO/hzJZRvwFu0VlKNKS0UJkJbsXo5g5eKrjFiozDZKOAq47xp1g6OEYSlBmIGo8IfNPZfLJuoEx199AkAsenoSIcswdxxt+rbjdv1eXCd/nvYgBMRtYnb/u1jYMuWEELFWqLk+7JcNOCALm/ouZAuOAvhrZa+p/CKAwnXRAkBGNZ3bBWGlMNkm0JtpG88bEU+cEQe3e8nBrf73BnI97kKpvPzAbkGsdLKwcv1Ta9s5x2p4pLSBocuXgk1V5plVAkBQte+JmbqBY3D44N4D3QlRR4fcTW4oB14eLYnpM/enBB3z4zExlyxA3kCw65XE/6vgWpfYOaj4li7xXEB849kW");
    NSString *signedString = [signer signString:orderInfo];
    return signedString;
}



@end
