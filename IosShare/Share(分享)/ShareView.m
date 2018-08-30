//
//  ShareView.m
//  CaiKer
//
//  Created by pwyy on 2018/8/16.
//  Copyright © 2018年 qian. All rights reserved.
//

#import "ShareView.h"
#import "CaiKerShare.h"
#import "ShareModel.h"
#define ScreenW  [[UIScreen mainScreen] bounds].size.width

#define ScreenH [[UIScreen mainScreen] bounds].size.height

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define UIColorFromRGB2(rgbValue,b) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:b/10]

@interface ShareView()<CaiKersDelegate>{
    UIView *_remBlackView;
    NSArray *_iamgeArr;
    NSArray *_titleArr;
}

@end

@implementation ShareView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        _iamgeArr = @[@"share_fre_icon",@"share_wechat_icon",@"share_qq_icon",@"share_sina_icon"];
        
        _titleArr = @[@"朋友圈",@"微信",@"QQ",@"新浪微博"];
        
        [self _creatView];
    }
    
    return self;
}

-(void)_creatView{
   
    _remBlackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
    
    _remBlackView.backgroundColor = [[UIColor colorWithRed:53/255.0 green:53/255.0 blue:53/255.0 alpha:1]colorWithAlphaComponent:0.4f];
    
    _remBlackView.userInteractionEnabled = YES;
    
    UIView *remV = [[UIView alloc]initWithFrame:CGRectMake(0,ScreenH - 290 ,ScreenW, 290)];
    remV.backgroundColor = UIColorFromRGB(0xffffff);
    
    
    UILabel *sureLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,25, remV.frame.size.width,17)];
    // sureLabel.backgroundColor = UIColorFromRGB(0xf6f6f6);
    sureLabel.textAlignment = NSTextAlignmentCenter;
    //sureLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    sureLabel.font = [UIFont systemFontOfSize:17];
    sureLabel.textColor = UIColorFromRGB(0x333333);
    sureLabel.text = @"分享给好友";
    
    float buttonWidth = ScreenW/3;
    NSInteger line = 1;
    for (int i = 0; i < _titleArr.count; i++) {
        NSInteger row = i/3;
        if (i == 3) {
            line = 0;
        }
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(i * buttonWidth*line,CGRectGetMaxY(sureLabel.frame)+15 + 81*row, buttonWidth, 76)];
        view.backgroundColor = [UIColor clearColor];
        
        UIImageView *shareImage = [[UIImageView alloc]initWithFrame:CGRectMake((buttonWidth - 52)/2, 0, 52, 52)];
        shareImage.image = [UIImage imageNamed:_iamgeArr[i]];
        
        UILabel *shareLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(shareImage.frame)+5, buttonWidth, 13)];
        shareLabel.textAlignment = NSTextAlignmentCenter;
        shareLabel.font = [UIFont systemFontOfSize:12];
        shareLabel.textColor = UIColorFromRGB(0x333333);
        shareLabel.text = [NSString stringWithFormat:@"%@",_titleArr[i]];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(_selectShareAction:)];
        tap.numberOfTapsRequired = 1;
        
        [view addGestureRecognizer:tap];
        tap.view.tag = 909+i;
        
        [view addSubview:shareLabel];
        [view addSubview:shareImage];
        [remV addSubview:view];
    }
    
    UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(sureLabel.frame)+76+33+32, ScreenW, 0.5)];
    lineLabel.backgroundColor = UIColorFromRGB(0xdddddd);
    // lineLabel.backgroundColor = [UIColor redColor];
    
    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sureButton.frame = CGRectMake(0, CGRectGetMaxY(lineLabel.frame)+50,ScreenW, 47);
    sureButton.titleLabel.font = [UIFont systemFontOfSize:18];
    sureButton.backgroundColor = [UIColor clearColor];
    
    [sureButton setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    [sureButton addTarget:self action:@selector(_closeviewSucess:) forControlEvents:UIControlEventTouchUpInside];
    [sureButton setTitle:@"取消" forState:UIControlStateNormal];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(_cloasActionWithSelf:)];
    tap.numberOfTapsRequired = 1;
    
    [_remBlackView addGestureRecognizer:tap];
    [remV addSubview:sureButton];
    [remV addSubview:sureLabel];
   // [remV addSubview:lineLabel];
    [_remBlackView addSubview:remV];
    [self addSubview:_remBlackView];
}

-(void)_closeviewSucess:(UIButton *)btn{
    [_remBlackView removeFromSuperview];
    [self removeFromSuperview];
    
    if (self.datablock) {
        self.datablock(@"ga");
    }
}


-(void)_selectShareAction:(UITapGestureRecognizer *)tap{
    [_remBlackView removeFromSuperview];
    [self removeFromSuperview];
    NSInteger row = tap.view.tag - 909;
    
    CaiKerShare *share = [[CaiKerShare alloc]init];
    share.delegate = self;
    ShareModel *model = [[ShareModel alloc] init];
    model.shareTitle = [NSString stringWithFormat:@"hello world"];//分享标题
    model.content = [NSString stringWithFormat:@"今天天气真好..."];//分享内容
    model.url = [NSString stringWithFormat:@"https://www.baidu.com"];//分享链接
    model.picturePath = [NSString stringWithFormat:@"https://www.baidu.com"];//图片地址
    share.model = model;
    self.model = model;
    
    if (row == 0) {
        [share lotteryShareActionWithURL:self.model.url AndPitcurePath:self.model.picturePath AndShareTitle:self.model.shareTitle AndShareContent:self.model.content WithLastType:ShareTypeWechatTimeLine];
    }
    else if (row == 1){
        [share lotteryShareActionWithURL:self.model.url AndPitcurePath:self.model.picturePath AndShareTitle:self.model.shareTitle AndShareContent:self.model.content WithLastType:ShareTypeWechat];
    }
    else if (row == 2){
        [share lotteryShareActionWithURL:self.model.url AndPitcurePath:self.model.picturePath AndShareTitle:self.model.shareTitle AndShareContent:self.model.content WithLastType:ShareTypeQQ];
    }
    else if (row == 3){
        [share lotteryShareActionWithURL:self.model.url AndPitcurePath:self.model.picturePath AndShareTitle:self.model.shareTitle AndShareContent:self.model.content WithLastType:ShareTypeWeibo];
    }
}

#pragma mark - 显示信息

-(void)showMessageWithShareFailure:(NSString *)message{
    if (self.delegate && [self.delegate respondsToSelector:@selector(showMessage:)]) {
        [self.delegate showMessage:message];
    }
}

#pragma mark - 关闭窗口
-(void)_cloasActionWithSelf:(UITapGestureRecognizer *)tap{
    [_remBlackView removeFromSuperview];
    [self removeFromSuperview];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
