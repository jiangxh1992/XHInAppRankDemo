//
//  ViewController.m
//  ApplestoreUserComment
//
//  Created by xinhou on 2018/9/30.
//  Copyright © 2018年 xinhou. All rights reserved.
//

#import "ViewController.h"
#import <StoreKit/StoreKit.h>
#define APPID @"*****"

@interface ViewController ()<SKStoreProductViewControllerDelegate>
@property(nonatomic,strong) SKStoreProductViewController *storeProductViewController;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _storeProductViewController =[[SKStoreProductViewController alloc]init];
    _storeProductViewController.delegate =self;
    
    UIButton *inapprank = [UIButton buttonWithType:UIButtonTypeCustom];
    inapprank.frame = CGRectMake(0, 0, 200, 50);
    inapprank.center = self.view.center;
    [inapprank setTitle:@"应用内评价" forState:UIControlStateNormal];
    inapprank.backgroundColor = UIColor.orangeColor;
    [inapprank addTarget:self action:@selector(InAppRank:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:inapprank];
}


- (void)InAppRank:(id)sender {
    // 1. iOS 10.3之后的版本可以在app内部进行星级评价，但每个应用每年只能弹出3次，测试期间不受限制
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 10.3){
        [SKStoreReviewController requestReview];
    }
    // 2. iOS 6.0之后
    else if([[UIDevice currentDevice].systemVersion doubleValue] >= 6.0)
    {
        [_storeProductViewController loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier:APPID} completionBlock:^(BOOL result, NSError * _Nullable error) {
            if (error)
                NSLog(@"error: %@ userInfo: %@",error,[error userInfo]);
            else
                [self presentViewController:self->_storeProductViewController animated:YES completion:nil];
        }];
    }
    // 3. 早期版本只能跳转到appstore去给应用评价
    else{
        NSString *str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@?action=write-review", APPID];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
}
@end
