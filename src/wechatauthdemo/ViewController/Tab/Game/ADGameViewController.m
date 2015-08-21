//
//  GameViewController.m
//  AuthSDKDemo
//
//  Created by Jeason on 14/08/2015.
//  Copyright (c) 2015 Jeason. All rights reserved.
//

#import "ADGameViewController.h"

@interface ADGameViewController ()

@end

static NSString *kGameTitle = @"游戏";

@implementation ADGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = kGameTitle;
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
