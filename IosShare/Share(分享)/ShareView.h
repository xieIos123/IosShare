//
//  ShareView.h
//  CaiKer
//
//  Created by pwyy on 2018/8/16.
//  Copyright © 2018年 qian. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^reloadDataBlock)(NSString *title);

@class ShareModel;

@protocol ShareViewDelegate<NSObject>

@optional

-(void)showMessage:(NSString *)message;

@end

@interface ShareView : UIView
@property(strong,nonatomic)reloadDataBlock datablock;

@property(strong,nonatomic)ShareModel *model;

@property(copy,nonatomic)NSString *userAccount;

@property(weak,nonatomic)id<ShareViewDelegate>delegate;

@end
