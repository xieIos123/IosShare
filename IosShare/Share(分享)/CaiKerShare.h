//
//  CaiKerShare.h
//  CaiKer
//
//  Created by pwyy on 2018/8/15.
//  Copyright © 2018年 qian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/QQApiInterfaceObject.h>
#import "WeiboSDK.h"

typedef enum : NSUInteger {
    ShareTypeWechat,
    ShareTypeWechatTimeLine,
    ShareTypeQQ,
    ShareTypeQQZone,
    ShareTypeWeibo
    
    
} ShareType;

@class ShareModel;

@protocol CaiKersDelegate<NSObject>

@optional

-(void)showMessageWithShareFailure:(NSString *)message;

@end

@interface CaiKerShare : NSObject

//用户账号
@property(copy,nonatomic)NSString *userAccount;

/**
 *
 * appUrl分享链接
 *
 * pitcurePath 分享图片
 *
 * title 分享标题
 *
 * content 分享内容
 *
 * type 分享类型
 *
 **/

-(void)lotteryShareActionWithURL:(NSString *)appUrl
                  AndPitcurePath:(NSString *)pitcurePath
                   AndShareTitle:(NSString *)title
                 AndShareContent:(NSString *)content
                    WithLastType:(NSInteger )type;

@property(strong,nonatomic)ShareModel *model;


@property(weak,nonatomic)id<CaiKersDelegate>delegate;


-(void)showTheShareStatusMessage:(NSString *)message;

-(void)sendMessageWithQQNumber:(NSString *)qq;

@end
