//
//  LogTextViewController.m
//  wechatauthdemo
//
//  Created by Jeason on 16/09/2015.
//  Copyright © 2015 boshao. All rights reserved.
//

#import "LogTextViewController.h"

@interface LogTextViewController ()

@property (nonatomic, strong) UITextView *textView;

@end

@implementation LogTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.textView];
    self.view.backgroundColor = [UIColor blackColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"退出"
                                                                             style:UIBarButtonItemStyleDone
                                                                            target:self
                                                                            action:@selector(onClickDismiss:)];
}

- (void)viewWillLayoutSubviews {
    self.textView.frame = self.view.frame;
}

#pragma mark - User Actions
- (void)onClickDismiss:(UIBarButtonItem *)sender {
    if (sender != self.navigationItem.leftBarButtonItem)
        return;
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Public Methods
+ (instancetype)sharedLogTextView {
    static dispatch_once_t onceToken;
    static LogTextViewController *instance;
    dispatch_once(&onceToken, ^{
        instance = [[LogTextViewController alloc] init];
    });
    return instance;
}

- (void)insertLog:(NSString *)log {
    self.textView.text = [self.textView.text stringByAppendingFormat:@"%@\n", log];
}

#pragma mark - Lazy Initializers
- (UITextView *)textView {
    if (_textView == nil) {
        _textView = [[UITextView alloc] init];
        _textView.font = [UIFont fontWithName:kEnglishNumberFont size:12];
        _textView.backgroundColor = [UIColor blackColor];
        _textView.textColor = [UIColor whiteColor];
        _textView.editable = NO;
    }
    return _textView;
}


@end
