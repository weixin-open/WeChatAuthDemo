//
//  MessageBoardViewController.m
//  wechatauthdemo
//
//  Created by Jeason on 15/10/2015.
//  Copyright © 2015 boshao. All rights reserved.
//

#import "MessageBoardViewController.h"
#import "ADNetworkEngine.h"
#import "ADUserInfo.h"

static NSString *const kMessageBoardViewTitle = @"留言板";

@interface MessageBoardViewController ()

@end

@implementation MessageBoardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = kMessageBoardViewTitle;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[ADNetworkEngine sharedEngine] addCommentContent:@"lalala"
                                               ForUin:[ADUserInfo currentUser].uin
                                          LoginTicket:[ADUserInfo currentUser].loginTicket
                                       WithCompletion:^(ADAddCommentResp *resp) {
                                           
                                       }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
