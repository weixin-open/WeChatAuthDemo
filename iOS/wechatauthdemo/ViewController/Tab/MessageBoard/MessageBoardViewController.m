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
#import "ADGetCommentListResp.h"
#import "MessageBoardCommentView.h"
#import "MessageBoardReplyCell.h"
#import "MessageBoardContentView.h"
#import "ADCommentList.h"
#import "ADUser.h"
#import "ADAddCommentResp.h"
#import "ADReplyList.h"
#import "NewCommentViewController.h"
#import "InputWithTextFeildBar.h"

static NSString *const kMessageBoardViewTitle = @"留言板";
static NSString *const kCommentViewIdentifier = @"kCommentViewIdentifier";
static NSString *const kReplyViewIdentifier = @"kReplyViewIdentifier";

@interface MessageBoardViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UITableView *messagesTable;
@property (nonatomic, strong) NSArray *commentsArray;
@property (nonatomic, strong) InputWithTextFeildBar *replyAccessoryView;
@property (nonatomic, strong) UITextView *keyBoardTool;
@property (nonatomic, strong) NSIndexPath *replyIndexPath;
@property (nonatomic, weak) UIView *replyView;

@end

@implementation MessageBoardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = kMessageBoardViewTitle;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"写留言"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(onClickNewComment:)];
    [self.view addSubview:self.messagesTable];
    [self.view addSubview:self.keyBoardTool];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    [self refreshComments];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (UIView *)inputAccessoryView {
    return self.replyAccessoryView;
}

#pragma mark - User Actions
- (void)onClickNewComment: (UIBarButtonItem *)sender {
    if (sender != self.navigationItem.rightBarButtonItem)
        return;
    NewCommentViewController *newCommentView = [[NewCommentViewController alloc] init];
    newCommentView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:newCommentView animated:YES];
}

- (void)onClickSendReply:(UIBarButtonItem *)sender {
    if (sender != self.replyAccessoryView.barButton)
        return;
    
    NSString *content = self.replyAccessoryView.textField.text;
    /* 检查字数 */
    if ([content length] == 0) {
        ADShowErrorAlert(@"内容不能为空");
        return;
    }
    
    /* 检查URL */
    NSDataDetector* detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:nil];
    NSArray* matchURL = [detector matchesInString:content
                                          options:0
                                            range:NSMakeRange(0, [content length])];
    if ([matchURL count] > 0) {
        ADShowErrorAlert(@"内容中不能包含链接");
        return;
    }

    
    AddReplyCallBack callBack = ^(ADAddReplyResp *resp) {
        [self.replyAccessoryView.textField resignFirstResponder];
        [self.messagesTable reloadData];
    };
    ADCommentList *comment = self.commentsArray[self.replyIndexPath.section];
    if (self.replyIndexPath.row == -1) {
        [[ADNetworkEngine sharedEngine] addReplyContent:content
                                              ToComment:comment.commentListIdentifier
                                              OrToReply:nil
                                                 ForUin:[ADUserInfo currentUser].uin
                                            LoginTicket:[ADUserInfo currentUser].loginTicket
                                         WithCompletion:callBack];
    } else {
        ADReplyList *reply = comment.replyList[self.replyIndexPath.row];
        [[ADNetworkEngine sharedEngine] addReplyContent:content
                                              ToComment:nil
                                              OrToReply:reply.replyListIdentifier
                                                 ForUin:[ADUserInfo currentUser].uin
                                            LoginTicket:[ADUserInfo currentUser].loginTicket
                                         WithCompletion:callBack];
    }
}

- (void)replyTextFinished:(UITextField *)sender {
    if (sender != self.replyAccessoryView.textField)
        return;
    
    [self resignFirstResponder];
}

#pragma mark - Notification
// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification {
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.messagesTable.contentInset = contentInsets;
    self.messagesTable.scrollIndicatorInsets = contentInsets;
    
    // If active cell is hidden by keyboard, scroll it so it's visible
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, self.replyView.frame.origin) ) {
        [self.messagesTable scrollRectToVisible:self.replyView.frame
                                       animated:YES];
    }
    [self.replyAccessoryView.textField becomeFirstResponder];
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.messagesTable.contentInset = contentInsets;
    self.messagesTable.scrollIndicatorInsets = contentInsets;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.commentsArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.commentsArray[section] replyList] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageBoardReplyCell *cell = [tableView dequeueReusableCellWithIdentifier:kReplyViewIdentifier];
    if (cell == nil) {
        cell = [[MessageBoardReplyCell alloc] initWithStyle:UITableViewCellStyleDefault
                                            reuseIdentifier:kReplyViewIdentifier];
    }
    ADReplyList *reply = [self.commentsArray[indexPath.section] replyList][indexPath.row];
    [cell.replyContentView configureViewWithReply:reply];
    
    __block typeof (self) weakSelf = self;
    __block MessageBoardReplyCell* weakCell = cell;
    cell.replyContentView.clickCallBack = ^{
        [weakSelf.keyBoardTool becomeFirstResponder];
        weakSelf.replyIndexPath = indexPath;
        weakSelf.replyView = weakCell;
        weakSelf.replyAccessoryView.textField.placeholder = [NSString stringWithFormat:@"回复%@: ", reply.user.nickname];
    };
    
    return cell;
}

#pragma mark - UITabelViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MessageBoardCommentView *commentView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kCommentViewIdentifier];
    if (commentView == nil) {
        commentView = [[MessageBoardCommentView alloc] initWithReuseIdentifier:kCommentViewIdentifier];
    }
    ADCommentList *comment = self.commentsArray[section];
    [commentView.commentContent configureViewWithComment:comment];
    
    __block typeof(self) weakSelf = self;
    __block typeof(commentView) weakCommentView = commentView;
    commentView.commentContent.clickCallBack = ^{
        [weakSelf.keyBoardTool becomeFirstResponder];
        weakSelf.replyIndexPath = [NSIndexPath indexPathForRow:-1 inSection:section];
        weakSelf.replyAccessoryView.textField.placeholder = [NSString stringWithFormat:@"回复%@: ", comment.user.nickname];
        weakSelf.replyView = weakCommentView;
    };
    
    return commentView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [MessageBoardContentView calcHeightForComment:self.commentsArray[section]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [MessageBoardContentView calcHeightForReply:[self.commentsArray[indexPath.section] replyList][indexPath.row]];
}

#pragma mark -Private Methods
- (void)refreshComments {
    [[ADNetworkEngine sharedEngine] getCommentListForUin:[ADUserInfo currentUser].uin
                                                    From:nil
                                          WithCompletion:^(ADGetCommentListResp *resp) {
                                              self.commentsArray = resp.commentList;
                                              [self.messagesTable reloadData];
                                          }];
}

#pragma mark -Lazy Initializer
- (UITableView *)messagesTable {
    if (_messagesTable == nil) {
        CGRect frame = self.view.frame;
        frame.size.height -= navigationBarHeight+statusBarHeight;
        _messagesTable = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        _messagesTable.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [_messagesTable registerClass:[MessageBoardCommentView class] forHeaderFooterViewReuseIdentifier:kCommentViewIdentifier];
        [_messagesTable registerClass:[MessageBoardReplyCell class] forCellReuseIdentifier:kReplyViewIdentifier];
        _messagesTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _messagesTable.dataSource = self;
        _messagesTable.delegate = self;
    }
    return _messagesTable;
}

- (InputWithTextFeildBar *)replyAccessoryView {
    if (_replyAccessoryView == nil) {
        _replyAccessoryView = [[[NSBundle mainBundle] loadNibNamed:@"InputWithTextFieldBar"
                                                            owner:nil
                                                          options:nil] firstObject];
        [_replyAccessoryView.textField addTarget:self
                                          action:@selector(replyTextFinished:) forControlEvents:UIControlEventEditingDidEndOnExit];
        _replyAccessoryView.textField.returnKeyType = UIReturnKeyDone;
        _replyAccessoryView.barButton.target = self;
        _replyAccessoryView.barButton.action = @selector(onClickSendReply:);
    }
    return _replyAccessoryView;
}

- (UITextView *)keyBoardTool {
    if (_keyBoardTool == nil) {
        _keyBoardTool = [[UITextView alloc] init];
    }
    return _keyBoardTool;
}

@end
