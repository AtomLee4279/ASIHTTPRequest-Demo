//
//  ASIRequestHelper.h
//  ASIHTTPRequest——Demo
//
//  Created by 李一贤 on 2019/5/23.
//  Copyright © 2019 atomlee. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASIRequestHelper : NSObject

+ (instancetype)shareInstance;

-(void)post:(NSString*)urlString
    success: (void (^)(id result))success
    failure:(void (^)(id error)) failure;

@end

NS_ASSUME_NONNULL_END
