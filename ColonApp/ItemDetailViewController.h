//
//  ItemDetailViewController.h
//  ColonApp
//
//  Created by Manuel Ruiz on 7/7/14.
//  Copyright (c) 2014 Ruitzei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemDetailViewController : UIViewController
<UIWebViewDelegate>

@property (strong, nonatomic) NSString* link;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic,strong) UIActivityIndicatorView *spinner;


@end
