//
//  RootViewController.m
//  wechatauthdemo
//
//  Created by Jeason on 16/09/2015.
//  Copyright © 2015 boshao. All rights reserved.
//

#import "RootViewController.h"
#import "LogTextViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (event.type == UIEventSubtypeMotionShake) {
        UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:[LogTextViewController sharedLogTextView]];
        [self presentViewController:navigation
                           animated:YES
                         completion:nil];
    }
}

@end
