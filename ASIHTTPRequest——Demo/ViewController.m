//
//  ViewController.m
//  ASIHTTPRequest——Demo
//
//  Created by 李一贤 on 2019/5/23.
//  Copyright © 2019 atomlee. All rights reserved.
//

#import "ViewController.h"
#import "ASIRequestHelper.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[ASIRequestHelper shareInstance] post:@"http://duobaosdk-3.com" success:^(id  _Nonnull result) {
        
    } failure:^(id  _Nonnull error) {
        
    }];
    // Do any additional setup after loading the view.
}


@end
