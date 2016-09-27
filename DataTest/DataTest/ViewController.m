//
//  ViewController.m
//  DataTest
//
//  Created by hesanyuan on 15/1/8.
//  Copyright (c) 2015年 hesanyuan. All rights reserved.
//

#import "ViewController.h"
#import "WKMarkup.h"
//#import <NSJSONSerialization.h>
#import <Foundation/NSJSONSerialization.h>



@interface ViewController ()

@property NSString* dataContent;//业务数据
@property NSString* templateStr;//业务模板

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self testValue];//值类测试用例
//    [self testArray];//数组和循环的测试。
    [self testPipe];
    
    WKMarkup * markup = [[WKMarkup alloc] init];
    NSError *err;
    
    NSDictionary *reDic = [NSJSONSerialization JSONObjectWithData:[self.dataContent dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&err];
    NSLog(@"%@",reDic);
    double sencode = CFAbsoluteTimeGetCurrent();

    id value = nil;
    
    //调用markup。
    value = [markup markupWithTemp:self.templateStr withContent:reDic withOption:nil];


    double third = CFAbsoluteTimeGetCurrent();
    NSLog(@"%@",value);
    NSLog(@"时间开销=%f",third-sencode);
    
}

//值类型的测试
- (void)testValue
{
    [self readFile:@"DataContent" tplFile:@"ValueTest"];
}

//数组类型的测试
- (void)testArray
{
    [self readFile:@"ArrayData" tplFile:@"ArrayTest"];
}

- (void)testPipe
{
    [self readFile:@"PipeData" tplFile:@"PipeTest"];
}

-(void)readFile:(NSString*)dataContent tplFile:(NSString*)srcContent
{
    NSString *datapath = [[NSBundle mainBundle] pathForResource:dataContent ofType:@"js"];
    NSString *temppath2 = [[NSBundle mainBundle] pathForResource:srcContent ofType:@"html"];
    
    self.dataContent = [[NSString alloc] initWithContentsOfFile:datapath encoding:NSUTF8StringEncoding error:nil];
    
    self.templateStr= [[NSString alloc] initWithContentsOfFile:temppath2 encoding:NSUTF8StringEncoding error:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
