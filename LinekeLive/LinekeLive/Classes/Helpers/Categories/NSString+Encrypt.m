//
//  NSString+Encrypt.m
//  Encrypt
//
//  Created by 马康旭 on 16/10/31.
//  Copyright © 2016年 马康旭. All rights reserved.
//

#import "NSString+Encrypt.h"
#import <CommonCrypto/CommonCrypto.h>
#import "GTMBase64.h"
#import "Base64.h"

@implementation NSString (Encrypt)

-(NSString *)desKey{
    
    return @"LKLiveEncrypted";
}

-(NSString *)DesEncrypt{

    NSString * key = self.desKey;
    
    NSData * dKey = [key dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *ciphertext = nil;
    NSData *textData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [textData length];
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    
    unsigned char buffer[bufferSize];
    memset(buffer, 0, sizeof(char));
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding,
                                          [key UTF8String], kCCKeySizeDES,
                                          [dKey bytes],
                                          [textData bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
        ciphertext = [Base64 encode:data];
    }
    return ciphertext;
}

-(NSString *)DESDecrypt{
    
    NSString * key = self.desKey;
    
    NSData * dKey = [key dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *plaintext = nil;
    NSData *cipherdata = [Base64 decode:self];
    
    NSUInteger dataLength = [cipherdata length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    
    unsigned char buffer[bufferSize];
    memset(buffer, 0, sizeof(char));
    size_t numBytesDecrypted = 0;
    // kCCOptionPKCS7Padding|kCCOptionECBMode 最主要在这步
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding,
                                          [key UTF8String],
                                          kCCKeySizeDES,
                                          [dKey bytes],
                                          [cipherdata bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesDecrypted);
    if(cryptStatus == kCCSuccess) {
        NSData *plaindata = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesDecrypted];
        plaintext = [[NSString alloc]initWithData:plaindata encoding:NSUTF8StringEncoding];
    }
    return plaintext;
}

-(NSString *)MD5Encryption{
    
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    return [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X"
            ,result[0],result[1],result[2],result[3]
            ,result[4],result[5],result[6],result[7]
            ,result[8],result[9],result[10],result[11]
            ,result[12],result[13],result[14],result[15]];
}

+(NSString *)encodeBase64String:(NSString *)input{
    NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    data = [GTMBase64 encodeData:data];
    NSString *base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return base64String;
}
+(NSString *)decodeBase64String:(NSString *)input{
    NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    data = [GTMBase64 decodeData:data];
    NSString *base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return base64String;
}
+(NSString *)encodeBase64Data:(NSData *)data{
    data = [GTMBase64 encodeData:data];
    NSString *base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return base64String;
}
+(NSString *)decodeBase64Data:(NSData *)data{
    data = [GTMBase64 decodeData:data];
    NSString *base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return base64String;
}


@end
