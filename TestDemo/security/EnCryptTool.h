//
//  EnCryptTool.h
//  TestDemo
//
//  Created by zhuyun on 16/2/3.
//  Copyright © 2016年 codera. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EnCryptTool : NSObject
- (NSString*)EncryptMsg:(NSString*)Msg timeStmap:(NSString*)time;
- (NSData *)Base64Decoding:(NSString *)key;
- (NSData *)AESEncryptmsg:(NSData *)msg key:(NSData*)akey;
- (NSString*) sha1:(NSData *)Msg;
- (NSString*)EncryptMsg:(NSString*)Msg key:(NSString *)aesKey timeStmap:(NSString*)time;
@end
