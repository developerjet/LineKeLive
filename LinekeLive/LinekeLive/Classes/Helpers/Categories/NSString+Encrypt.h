//
//  NSString+Encrypt.h
//  Encrypt
//
//  Created by 马康旭 on 16/10/31.
//  Copyright © 2016年 马康旭. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Encrypt)

/** Des加密方法 */
-(NSString *) DesEncrypt;
/** Des解密方法 */
-(NSString *) DESDecrypt;

-(NSString *)desKey;

/** MD5加密 */
- (NSString *)MD5Encryption;

+(NSString *)encodeBase64String:(NSString *)input;
+(NSString *)decodeBase64String:(NSString *)input;
+(NSString *)encodeBase64Data:(NSData *)data;
+(NSString *)decodeBase64Data:(NSData *)data;

@end
