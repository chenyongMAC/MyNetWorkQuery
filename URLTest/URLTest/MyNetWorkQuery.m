//
//  MyNetWorkQuery.m
//  天气预报
//
//  Created by kangkathy on 15/8/28.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "MyNetWorkQuery.h"

//#define BaseURL @"http://apis.baidu.com/baidunuomi/openapi/cities"

#define BaseURL @"http://apis.baidu.com/baidunuomi/openapi/"


@implementation MyNetWorkQuery

+ (void)requestData:(NSString *)urlString HTTPMethod:(NSString *)method params:(NSMutableDictionary *)params completionHandle:(void (^)(id result, NSInteger responseCode))completionblock errorHandle:(void (^)(NSError *))errorblock{
    
    //1.拼接URL
    NSString *requestString = [BaseURL stringByAppendingString:urlString];
    NSURL *url = [NSURL URLWithString:requestString];
    
    
    //2.创建网络请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.timeoutInterval = 60;
    request.HTTPMethod = method;
    //添加请求头，即apikey
    [request addValue: @"f09adfd8d8e174bb6c56d6defbfcbccf" forHTTPHeaderField: @"apikey"];
    
    //3.处理请求参数
    //形式：key1=value1&key2=value2
    NSMutableString *paramString = [NSMutableString string];
    NSArray *allKeys = params.allKeys;
    for (NSInteger i = 0; i < params.count; i++) {
        NSString *key = allKeys[i];
        NSString *value = params[key];
        
        [paramString appendFormat:@"%@=%@",key,value];
        
        if (i < params.count - 1) {
            [paramString appendString:@"&"];
        }
        
    }
    
    //4.GET和POST分别处理
    if ([method isEqualToString:@"GET"]) {
        
        NSString *seperate = url.query ? @"&" : @"?";
        NSString *paramsURLString = [NSString stringWithFormat:@"%@%@%@",requestString,seperate,paramString];
        
        //根据拼接好的URL进行修改
        request.URL = [NSURL URLWithString:paramsURLString];
        
        
    }
    else if([method isEqualToString:@"POST"]) {
        //POST请求则把参数放在请求体里
        NSData *bodyData = [paramString dataUsingEncoding:NSUTF8StringEncoding];
        request.HTTPBody = bodyData;
    }
    
    //5.发送异步网络请求
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        //1.出现错误时回调block
        if (connectionError) {
            errorblock(connectionError);
            return;
        }
        NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
        //2.如果数据不是json格式，进行转化
        if (data) {

            //解析JSON
            NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            //把JSON解析后的数据返回给调用者,回调block
            completionblock(jsonDic, responseCode);
            
        }
    }];
}



+ (void)AFRequestData:(NSString *)urlString HTTPMethod:(NSString *)method params:(NSMutableDictionary *)params completionHandle:(void (^)(id))completionblock errorHandle:(void (^)(NSError *))errorblock {
    
    //拼接URL
    urlString = [BaseURL stringByAppendingString:urlString];
    
    //请求参数格式化对象，会根据类型拼接好给定格式
    AFHTTPRequestSerializer *requestSer = [AFHTTPRequestSerializer serializer];
    //使用请求参数格式化对象来构造一个request对象
    NSMutableURLRequest *request = [requestSer requestWithMethod:method URLString:urlString parameters:params error:nil];
    
    //PS：本人试验使用的是百度API超市的接口，需要在请求头添加秘钥，这个不是必要内容
    [request addValue:@"5f6dcec6916a464d57fbb3e984201937" forHTTPHeaderField:@"apikey"];
    
    //构造线程对象
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    //设置从服务器返回到客户端数据的解析方式，默认为JSON解析
    operation.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers];
    
    //网络请求事件的监听,成功和失败返回的block
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        completionblock(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"网络请求失败");
        errorblock(error);
        
    }];
    
    
    //发送网络请求，把网络请求任务添加到任务队列中执行
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:operation];
    
}


@end
