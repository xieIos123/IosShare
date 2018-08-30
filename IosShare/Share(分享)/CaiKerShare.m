//
//  CaiKerShare.m
//  CaiKer
//
//  Created by pwyy on 2018/8/15.
//  Copyright © 2018年 qian. All rights reserved.
//

#import "CaiKerShare.h"
#import "ShareModel.h"
#import "AppDelegate.h"

@interface CaiKerShare()<QQShareDelegate,WeiXinShareDelegate,UIApplicationDelegate,WeiboShareDelegate,WBMediaTransferProtocol>
{
    AppDelegate *appdelegate;
}
@end

@implementation CaiKerShare
-(instancetype)init{
    self = [super init];
    if (self) {
       
        
    }
    
    return self;
}


-(void)lotteryShareActionWithURL:(NSString *)appUrl AndPitcurePath:(NSString *)pitcurePath AndShareTitle:(NSString *)title AndShareContent:(NSString *)content WithLastType:(NSInteger)type{
    
    if (type == ShareTypeWechat) {
        [self _XTWechatLotteryShareActionWithURL:appUrl AndPitcurePath:pitcurePath AndShareTitle:title AndShareContent:content WithLastType:type];
    }
    else if (type == ShareTypeWechatTimeLine){
        
        [self _XTWechatFriendLotteryShareActionWithURL:appUrl AndPitcurePath:pitcurePath AndShareTitle:title AndShareContent:content WithLastType:type];
    }
    else if (type == ShareTypeQQ){
        
        [self _XTQQchatLotteryShareActionWithURL:appUrl AndPitcurePath:pitcurePath AndShareTitle:title AndShareContent:content WithLastType:type];
    }
    else if (type == ShareTypeWeibo){
        [self _XTWeiBoLotteryShareActionWithURL:appUrl AndPitcurePath:pitcurePath AndShareTitle:title AndShareContent:content WithLastType:type];
    }
    else if (type == ShareTypeQQZone){
        
        [self _XTQQhomeLotteryShareActionWithURL:appUrl AndPitcurePath:pitcurePath AndShareTitle:title AndShareContent:content WithLastType:type];
    }
}

#pragma mark -分享微信


-(void)_XTWechatLotteryShareActionWithURL:(NSString *)appUrl AndPitcurePath:(NSString *)pitcurePath AndShareTitle:(NSString *)title AndShareContent:(NSString *)content WithLastType:(NSInteger)type{
    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
        
       
        //文本和链接分享方式
        
        SendMessageToWXReq *req1 = [[SendMessageToWXReq alloc]init];
        
        // 是否是文档
        req1.bText =  NO;
        
        req1.scene = WXSceneSession;
        
        //创建分享内容对象
        WXMediaMessage *urlMessage = [WXMediaMessage message];
        
        urlMessage.title = title;//分享标题
        urlMessage.description = content;//分享描述
        // [urlMessage setThumbImage:[UIImage imageNamed:@"60shuocai_logo.png"]];//分享图片,使用SDK的setThumbImage方法可压缩图片大小
        
        UIImage *shareImage = [UIImage imageNamed:@"more_logo"];
        [urlMessage setThumbImage:shareImage];
        
        //创建多媒体对象
        WXWebpageObject *webObj = [WXWebpageObject object];
        webObj.webpageUrl = appUrl;//分享链接
        
        //完成发送对象实例
        urlMessage.mediaObject = webObj;
        req1.message = urlMessage;
        
     
        //发送分享信息
        [WXApi sendReq:req1];
        
        
        
    } else {
        
        [self shareFailure:@"尚未安装微信，无法使用该功能"];
       
    }
    
    
    
}

#pragma mark -分享朋友圈


-(void)_XTWechatFriendLotteryShareActionWithURL:(NSString *)appUrl AndPitcurePath:(NSString *)pitcurePath AndShareTitle:(NSString *)title AndShareContent:(NSString *)content WithLastType:(NSInteger)type{
    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
        
        
        SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
        WXMediaMessage *message = [WXMediaMessage message];
        
        UIImage *shareImage = [UIImage imageNamed:@"more_logo"];
        [message setThumbImage:shareImage];
         title = [NSString stringWithFormat:@"%@",content];
        
        req.message = message;
        
        message.title = [NSString stringWithFormat:@"%@",title];
        
        message.description = [NSString stringWithFormat:@"%@",content];
        
        WXAppExtendObject *ext = [WXAppExtendObject object];
        NSString *url = [NSString stringWithFormat:@"%@",appUrl];
        
        ext.url = url;
       
        message.mediaObject = ext;
        
        req.scene = WXSceneTimeline;
        
        appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        appdelegate.weixinDelegate = self;
        appdelegate.model = self.model;
        
        [WXApi sendReq:req];
    } else {
        
       [self shareFailure:@"尚未安装微信，无法使用该功能"];
    }
}

#pragma mark - 分享QQ

-(void)_XTQQchatLotteryShareActionWithURL:(NSString *)appUrl AndPitcurePath:(NSString *)pitcurePath AndShareTitle:(NSString *)title AndShareContent:(NSString *)content WithLastType:(NSInteger)type{
    
    if ([TencentOAuth iphoneQQInstalled]) {
        
        NSURL *previewURL = [NSURL URLWithString:@"http://baidu.com"];
       // NSURL *previewURL = [NSURL URLWithString:@"http://scw.866hs.com/news/newsDetail/152"];
        
        NSString *path = [[NSBundle mainBundle] bundlePath];
        NSData *previeImgData;
        
        NSString *name = [NSString stringWithFormat:@"more_logo"];
        NSString *finalPath = [path stringByAppendingPathComponent:name];
        previeImgData = [NSData dataWithContentsOfFile:finalPath];
        
        
        if (content.length > 200) {
            
            NSString *contentS = [content substringToIndex:200];
            
            content = [NSString stringWithFormat:@"%@",contentS];
        }
        
        QQApiNewsObject *imgObj = [QQApiNewsObject objectWithURL:previewURL title:title description:content previewImageData:previeImgData];
        
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:imgObj];
        QQApiSendResultCode sent = [QQApiInterface sendReq:req];
        
        appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        appdelegate.weixinDelegate = self;
        appdelegate.model = self.model;
        
        [self handleSendResult:sent];
        
       
    }
    else{
        
       [self shareFailure:@"尚未安装QQ，无法使用该功能"];
    }
    
}

#pragma mark - 分享空间

-(void)_XTQQhomeLotteryShareActionWithURL:(NSString *)appUrl AndPitcurePath:(NSString *)pitcurePath AndShareTitle:(NSString *)title AndShareContent:(NSString *)content WithLastType:(NSInteger)type{
    
    if ([TencentOAuth iphoneQQInstalled]) {
        
        NSURL *previewURL = [NSURL URLWithString:appUrl];
        
        NSString *path = [[NSBundle mainBundle] bundlePath];
        NSString *name = [NSString stringWithFormat:@"120shuocai_logo.png"];
        NSString *finalPath = [path stringByAppendingPathComponent:name];
        NSData *previeImgData ;//= [NSData dataWithContentsOfFile:finalPath];
        
        NSString *contentS = @"";
        if (content.length > 50) {
            contentS = [content substringToIndex:50];
        }
        else{
            contentS = content;
        }
        
        NSData *iamgeData = [NSData dataWithContentsOfURL:[NSURL URLWithString:pitcurePath]];
        // imageObject.imageData = UIImageJPEGRepresentation(shareMedailImage, 0.2);
        
        previeImgData = iamgeData;
        
        QQApiNewsObject *imgObj = [QQApiNewsObject objectWithURL:previewURL title:title description:contentS previewImageData:previeImgData];
        
        [imgObj setCflag:kQQAPICtrlFlagQZoneShareOnStart];
        
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:imgObj];
        QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
        
        [self handleSendResult:sent];
        
        
        

    }
    else{
       
        [self shareFailure:@"尚未安装QQ，无法使用该功能"];
    }
    
    
    
}


#pragma mark - 微博分享

-(void)_XTWeiBoLotteryShareActionWithURL:(NSString *)appUrl AndPitcurePath:(NSString *)pitcurePath AndShareTitle:(NSString *)title AndShareContent:(NSString *)content WithLastType:(NSInteger)type{
    
     NSData *iamgeData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://s12.mogujie.cn/b7/bao/131011/1jix9_kqywmrcdkfbg26dwgfjeg5sckzsew_400x540.jpg_200x999.jpg"]];
    
    NSString *contentS = @"";
    if (content.length > 50) {
        contentS = [content substringToIndex:50];
    }
    else{
        contentS = content;
    }
    
    //授权
    WBAuthorizeRequest *wbRequest = [WBAuthorizeRequest request];
    wbRequest.redirectURI =  appUrl;
    wbRequest.scope = @"all";
    
    
    //UIImage* image2 = [UIImage imageNamed:@"120shuocai_logo.png"];//分享图片
    WBMessageObject *messageObject = [WBMessageObject message];
    
    
    WBImageObject *imageObject = [WBImageObject object];
    imageObject.delegate = self;
   // NSData *iamgeData = [NSData dataWithContentsOfURL:[NSURL URLWithString:pitcurePath]];
    // imageObject.imageData = UIImageJPEGRepresentation(shareMedailImage, 0.2);
    
    imageObject.imageData = iamgeData;
    messageObject.imageObject = imageObject;
    
    
    messageObject.text = [NSString stringWithFormat:@"%@ %@ %@", title,contentS,appUrl];
    
    
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:messageObject authInfo:wbRequest access_token:nil];
    //[WeiboSDK sendRequest:request];
    
    
    request.userInfo = nil;
    
    appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appdelegate.weixinDelegate = self;
    appdelegate.model = self.model;
    
    BOOL isSuccess =  [WeiboSDK sendRequest:request];
    NSLog(@"分享是否成功 %d",isSuccess);
    
    
}


#pragma mark - qq响应
- (void)handleSendResult:(QQApiSendResultCode)sendResult {
    
    switch (sendResult) {
        case EQQAPIAPPNOTREGISTED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"发送失败" message:@"App未注册" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPIMESSAGECONTENTINVALID:
        case EQQAPIMESSAGECONTENTNULL:
        case EQQAPIMESSAGETYPEINVALID:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"发送失败" message:@"发送参数错误" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            
            break;
        }
        case EQQAPIQQNOTINSTALLED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"发送失败" message:@"尚未安装QQ，无法使用该功能" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPIQQNOTSUPPORTAPI:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"发送失败" message:@"API接口不支持" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            
            break;
        }
        case EQQAPISENDFAILD:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"发送失败" message:@"发送失败" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            
            break;
        }
            
        default:
            
            
            break;
    }
    
    
}


//qq响应

- (void)shareSuccssWithQQCode:(NSString *)code {
    
    if (code == 0) {
       
        [self _shareResultWithLottery];
    }else{
        UIAlertView *aler = [[UIAlertView alloc]initWithTitle:@"提示" message:@"分享失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [aler show];
    }
}


-(void)shareSuccessWithWeiboCode:(NSInteger)code{
   
    [self _shareResultWithLottery];
}

- (void)wbsdk_TransferDidFailWithErrorCode:(WBSDKMediaTransferErrorCode)errorCode andError:(NSError *)error {
    
}

- (void)wbsdk_TransferDidReceiveObject:(id)object {
    
}

#pragma mark - 分享成功回调后台

-(void)_shareResultWithLottery{
    
}

#pragma mark - 联系客服

-(void)sendMessageWithQQNumber:(NSString *)qq{
    if ([TencentOAuth iphoneQQInstalled]) {
        QQApiWPAObject *wpaObj = [QQApiWPAObject objectWithUin:qq];
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:wpaObj];
        QQApiSendResultCode sent = [QQApiInterface sendReq:req];
        [self handleSendResult:sent];
    }
    else{
        
        [self shareFailure:@"尚未安装QQ，无法使用该功能"];
       
    }
   
}

#pragma makr - 分享失败回调

-(void)shareFailure:(NSString *)message{
    if (self.delegate && [self.delegate respondsToSelector:@selector(showMessageWithShareFailure:)]) {
        [self.delegate showMessageWithShareFailure:message];
    }
}

- (void)loginSuccessByCode:(NSString *)code {
    [self _shareResultWithLottery];
}

- (void)shareSuccessWithWeixinCode:(NSInteger)code {
    
    [self _shareResultWithLottery];
}

-(void)shareSuccess:(NSInteger)code{
   
    [self _shareResultWithLottery];
}

-(void)showTheShareStatusMessage:(NSString *)message{
    [self shareFailure:message];
}

@end
