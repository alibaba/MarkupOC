//
//  alipayMarkup.h
//  DataTest
//
//  Created by hesanyuan on 15/1/9.
//  Copyright (c) 2015年 hesanyuan. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface WKMarkup : NSObject


/**
 *  把模版数据和业务数据合并
 *
 *  @param template 模版类型是NSString
 *  @param context  内容数据，必须是NSDictionary
 *  @param options 参数
 *
 *  @return 返回NSString 类型的字符串
 */
-(NSString*) markupWithTemp:(id)tpContent withContent:(id)context withOption:(id)options;


//-(id) pipefunction:(id)val withexp:(id)expressions;


@end
