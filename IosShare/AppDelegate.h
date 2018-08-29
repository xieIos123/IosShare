//
//  AppDelegate.h
//  IosShare
//
//  Created by pwyy on 2018/8/29.
//  Copyright © 2018年 pwyy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QQShareDelegate <NSObject>

-(void)shareSuccssWithQQCode:(NSString *)code;

@end

@protocol WeiXinShareDelegate <NSObject>

-(void)loginSuccessByCode:(NSString *)code;

-(void)shareSuccessWithWeixinCode:(NSInteger)code;



@end

@protocol WeiboShareDelegate <NSObject>

-(void)shareSuccessWithWeiboCode:(NSInteger)code;

@end

@protocol chosyLotteryDelegate<NSObject>

-(void)shareSuccess:(NSInteger)code;

@end


@class ShareModel;
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (weak  , nonatomic) id<QQShareDelegate> qqDelegate;

@property (weak , nonatomic) id<WeiXinShareDelegate> weixinDelegate;

@property (weak , nonatomic) id<WeiboShareDelegate> weiboDelegate;

@property (weak ,nonatomic) id<chosyLotteryDelegate> delegate;

@property(strong,nonatomic)ShareModel *model;


@end

