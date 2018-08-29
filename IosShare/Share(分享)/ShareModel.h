//
//  ShareModel.h
//  CaiKer
//
//  Created by pwyy on 2018/8/14.
//  Copyright © 2018年 qian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareModel : NSObject
/**
 * 分享标题
 */
@property(nonatomic, copy) NSString *shareTitle;

/**
 * 分享内容
 */
@property(nonatomic,copy) NSString *content;

/**
 * 分享图片地址
 */
@property(nonatomic,copy) NSString *picturePath;

/**
 * 分享链接
 */
@property(nonatomic,copy) NSString *url;

@end
