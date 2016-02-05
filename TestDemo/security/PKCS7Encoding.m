//
//  PKCS7Encoding.m
//  TestDemo
//
//  Created by zhuyun on 16/2/3.
//  Copyright © 2016年 codera. All rights reserved.
//

#import "PKCS7Encoding.h"
static int bloc_size = 32;
@implementation PKCS7Encoding
+(NSData *)encoding:(NSString *)Msg{
    NSInteger leng = [Msg dataUsingEncoding:NSUTF8StringEncoding].length;
    int countPad = bloc_size - (leng%bloc_size);
    if (countPad ==0)
        countPad = bloc_size;
    NSMutableData *result =[[NSMutableData alloc] initWithData:[Msg dataUsingEncoding:NSUTF8StringEncoding]];
    NSString *data = [NSString stringWithFormat:@"%c",countPad];
    for(int i =0;i<countPad;i++){
        [result appendData:[data dataUsingEncoding:NSUTF8StringEncoding]];
    }
    return result;
};
@end
