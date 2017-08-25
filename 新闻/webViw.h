//
//  webViw.h
//  新闻
//
//  Created by 谢风 on 2017/8/11.
//  Copyright © 2017年 Pyrrha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface webViw : UIViewController<UIWebViewDelegate>
{
    UIWebView *_webView;
    UIActivityIndicatorView *_indicatorView;
    UIImageView *_imageView;
    UIButton *_button;
}
@property(nonatomic,retain)NSString *URL;
@end
