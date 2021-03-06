//
//  ViewController.m
//  IosShare
//
//  Created by pwyy on 2018/8/29.
//  Copyright © 2018年 pwyy. All rights reserved.
//

#import "ViewController.h"
#import "ShareView.h"
#import "ShareModel.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake((self.view.frame.size.width - 100)/2, self.view.frame.size.height/2 - 50, 100, 100);
    button.backgroundColor = [UIColor purpleColor];
    [button setTitle:@"分 享" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button];
}


-(void)shareAction:(UIButton *)button{
    
    ShareModel *model = [[ShareModel alloc]init];
    model.shareTitle = [NSString stringWithFormat:@"hello world"];//分享标题
    model.content = [NSString stringWithFormat:@"今天天气真好..."];//分享内容
    model.url = [NSString stringWithFormat:@"https://www.baidu.com"];//分享链接
    model.picturePath = [NSString stringWithFormat:@"https://www.baidu.com"];//图片地址
    
    ShareView *shareView = [[ShareView alloc]initWithFrame:self.view.frame];
    shareView.model = model;
    
    [self.view addSubview:shareView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
