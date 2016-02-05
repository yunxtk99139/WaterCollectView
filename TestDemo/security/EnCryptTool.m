//
//  EnCryptTool.m
//  TestDemo
//
//  Created by zhuyun on 16/2/3.
//  Copyright © 2016年 codera. All rights reserved.
//

#import "EnCryptTool.h"
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonKeyDerivation.h>
#define  AESKey   @"bacdefghijklmnopqrstuvwxzy1023456798BACDEGF"
#import "PKCS7Encoding.h"
static const char encodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
@implementation EnCryptTool
- (NSString*)EncryptMsg:(NSString*)Msg timeStmap:(NSString*)time{
    return [self EncryptMsg:Msg key:AESKey timeStmap:time];
};
-(NSString*)EncryptMsg:(NSString*)Msg key:(NSString *)key timeStmap:(NSString*)time{
    //AESKey=Base64_Decode(EncodingAESKey + “=”)，EncodingAESKey尾部填充一个字符的“=”, 用Base64_Decode生成32个字节的AESKey；
    NSData *aeskey = [self Base64Decoding:key];
    //NSLog(@"\nAESKey is %@\n",aeskey);
    NSMutableString *pckMsg = [[NSMutableString alloc]initWithString:time];
    [pckMsg  appendString:Msg];
    //数据采用PKCS#7填充；PKCS#7：K为秘钥字节数（采用32），buf为待加密的内容，N为其
    //字节数。Buf需要被填充为K的整数倍。在buf的尾部填充(K-N%K)个字节，每个字节的内容
    //是(K- N%K)；
    NSData *PKCS7Msg = [PKCS7Encoding encoding:pckMsg];
    NSData * aesMsg =[self AESEncryptmsg:PKCS7Msg key:aeskey];
    NSMutableData* timeMsg = [[NSMutableData alloc]initWithData:[time dataUsingEncoding:NSUTF8StringEncoding]];
    [timeMsg appendData:aesMsg];
    NSData * newAesMsg = [[NSData alloc] initWithData:timeMsg];
    NSString *result =[self sha1:newAesMsg];
    return result;
}
- (NSString*) sha1:(NSData *)Msg
{
    const char *cstr = [Msg bytes];
    NSData *data = [NSData dataWithBytes:cstr length:Msg.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, [data length], digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}
-(NSData *)AESEncryptmsg:(NSData *)msg key:(NSData*)akey{
    char keyPtr[kCCKeySizeAES256];
    bzero(keyPtr, sizeof(keyPtr));
    memccpy(keyPtr, [akey bytes], 0, sizeof(akey));
    NSUInteger dataLength = [msg length];
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    NSData *iv =[[NSData alloc] initWithBytes:[akey bytes] length:16];
    // NSLog(@"Iv is %@",iv);
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding,
                                          [akey bytes], kCCKeySizeAES256,
                                          [iv bytes],
                                          [msg  bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesEncrypted);
    
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted-16];
    }
    
    free(buffer);
    return nil;
}

-(NSData *)Base64Decoding:(NSString *)key
{
    NSMutableString * akey = [[NSMutableString  alloc]initWithString:key];
    [akey appendString:@"="];
    if (akey == nil)
        [NSException raise:NSInvalidArgumentException format:nil];
    if ([akey length] == 0)
        return [NSData data];
    
    static char *decodingTable = NULL;
    if (decodingTable == NULL)
    {
        decodingTable = malloc(256);
        if (decodingTable == NULL)
            return nil;
        memset(decodingTable, CHAR_MAX, 256);
        NSUInteger i;
        for (i = 0; i < 64; i++)
            decodingTable[(short)encodingTable[i]] = i;
    }
    
    const char *characters = [akey cStringUsingEncoding:NSASCIIStringEncoding];
    if (characters == NULL)     //  Not an ASCII string!
        return nil;
    char *bytes = malloc((([akey length] + 3) / 4) * 3);
    if (bytes == NULL)
        return nil;
    NSUInteger length = 0;
    
    NSUInteger i = 0;
    while (YES)
    {
        char buffer[4];
        short bufferLength;
        for (bufferLength = 0; bufferLength < 4; i++)
        {
            if (characters[i] == '\0')
                break;
            if (isspace(characters[i]) || characters[i] == '=')
                continue;
            buffer[bufferLength] = decodingTable[(short)characters[i]];
            if (buffer[bufferLength++] == CHAR_MAX)      //  Illegal character!
            {
                free(bytes);
                return nil;
            }
        }
        
        if (bufferLength == 0)
            break;
        if (bufferLength == 1)      //  At least two characters are needed to produce one byte!
        {
            free(bytes);
            return nil;
        }
        
        //  Decode the characters in the buffer to bytes.
        bytes[length++] = (buffer[0] << 2) | (buffer[1] >> 4);
        if (bufferLength > 2)
            bytes[length++] = (buffer[1] << 4) | (buffer[2] >> 2);
        if (bufferLength > 3)
            bytes[length++] = (buffer[2] << 6) | buffer[3];
    }
    
    bytes = realloc(bytes, length);
    return [NSData dataWithBytesNoCopy:bytes length:length];
}

@end
