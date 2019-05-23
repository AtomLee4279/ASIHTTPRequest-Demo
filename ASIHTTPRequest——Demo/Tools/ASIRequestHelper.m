//
//  ASIRequestHelper.m
//  ASIHTTPRequest——Demo
//
//  Created by 李一贤 on 2019/5/23.
//  Copyright © 2019 atomlee. All rights reserved.
//

#import "ASIRequestHelper.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import <AdSupport/AdSupport.h>
#import <CommonCrypto/CommonDigest.h>

#define BaseURL @"http://duobaosdk-3.com"
#define signKey @"PS"
#define signValue @"d58ca1a03feab0b41dff5140358357ff"

@interface  ASIRequestHelper()

@property(strong,nonatomic) NSDictionary *postData;

@end


@implementation ASIRequestHelper

+ (instancetype)shareInstance {
    static ASIRequestHelper *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ASIRequestHelper alloc] init];
    });
    return instance;
}

-(void)post:(NSString*)urlString
           success: (void (^)(id result))success
           failure:(void (^)(id error)) failure{
    
    NSURL *url = [NSURL URLWithString:urlString];
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request appendPostData:[[self processParams] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setRequestMethod:@"POST"];
    [request setRequestHeaders:[NSMutableDictionary dictionaryWithObject:@"application/x-www-form-urlencoded" forKey:@"Content-Type"]];
//    [request setDelegate:self];
    [request setCompletionBlock:^{
        
        NSData *responseData = [request responseData];
        id responseObject = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:nil];
        NSLog(@"%@",[responseObject description]);
        
    }];
    
    [request setFailedBlock:^{
        
        NSError *error = [request error];
        NSLog(@"%@",error.localizedDescription);
    }];
    
    
    [request startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    // Use when fetching text data
    // Use when fetching binary data
    NSData *responseData = [request responseData];
    id responseObject = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:nil];
    NSLog(@"%@",[responseObject description]);
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"%@",error.localizedDescription);
}

-(NSString*)processParams{
    NSArray *sortedKeys = [[self.postData allKeys] sortedArrayUsingSelector:@selector(compare:)];
    NSMutableString *signString = [NSMutableString string];
    for (NSString *key in sortedKeys) {
        NSString *value = [self.postData objectForKey:key];
        NSString *keyAndValue = [NSString stringWithFormat:@"%@=%@",key,value];
        [signString appendString:keyAndValue];
    }
    [signString appendString:signValue];
    NSString *md5String = [self md5:signString];
    NSMutableString * keyAndValue = [NSMutableString string];
    for (NSString *key in sortedKeys) {
        NSString *value = [self.postData objectForKey:key];
        [keyAndValue appendString:[NSString stringWithFormat:@"%@=%@&",key,value]];
    }
    [keyAndValue appendString:[NSString stringWithFormat:@"PS=%@",md5String]];
    return keyAndValue;
}

- (NSString *)md5:(NSString *)str {
    const char *cStr = [str UTF8String];
    unsigned char result[32];
    CC_MD5( cStr, (unsigned)strlen(cStr), result );
    return [[NSString stringWithFormat:
             @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]] lowercaseString];
}

-(NSDictionary*)postData{
    if (_postData) {
        return _postData;
    }
    _postData = @{
                  @"AT":@"1",
                  @"DC":[[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString],
                  @"GN":[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"]
                  };
    
    return _postData;
    
}


@end
