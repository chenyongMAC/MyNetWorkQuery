//
//  ViewController.m
//  URLTest
//
//  Created by 陈勇 on 15/10/11.
//  Copyright © 2015年 陈勇. All rights reserved.
//

#import "ViewController.h"
#import "MyNetWorkQuery.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    [self _loadDataForJSON];
    
    [self _AFloadDataForJSON];

}

#pragma mark - NSURLConnection方法，JSON解析
-(void) _loadDataForJSON {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"600010000" forKey:@"city_id"];
    [params setObject:@"120.34917,30.320139" forKey:@"location"];
    [params setObject:@"1000" forKey:@"radius"];
    
    NSString *urlString = @"searchshops";
    
    [MyNetWorkQuery requestData:urlString HTTPMethod:@"GET" params:params completionHandle:^(id result, NSInteger responseCode) {
        if (result != nil) {
            NSLog(@"状态码：%ld", (long)responseCode);
            NSLog(@"获取到的数据：%@", result);
            
        }
    } errorHandle:^(NSError *error) {
        NSLog(@"error:%@", error);
    }];
}

-(void) _AFloadDataForJSON {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"600010000" forKey:@"city_id"];
    [params setObject:@"120.34917,30.320139" forKey:@"location"];
    [params setObject:@"1000" forKey:@"radius"];
    
    NSString *urlString = @"searchshops";
    
    [MyNetWorkQuery AFRequestData:urlString HTTPMethod:@"GET" params:params completionHandle:^(id result) {

        NSLog(@"%@", result);


    } errorHandle:^(NSError *error) {
        NSLog(@"获取附近推荐出错");
    }];
}


@end
