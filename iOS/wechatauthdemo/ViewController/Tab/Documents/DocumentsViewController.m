//
//  DocumentsViewController.m
//  wechatauthdemo
//
//  Created by Jeason on 15/10/2015.
//  Copyright © 2015 Tencent. All rights reserved.
//

#import "DocumentsViewController.h"
#import "DocumentsCell.h"
#import "ADShareViewController.h"
#import "ADNetworkEngine.h"
#import "ADGetUserInfoResp.h"
#import "ADUserInfo.h"
#import "WXApiManager.h"

/* Title Message */
static NSString *const kDocumentsViewTitle = @"开发文档";
static NSString *const kDocumentsDescription = @"WeChat Demo提供微信登录、微信分享功能demo及开发文档。请选择一个功能详细了解。";
static NSString *const kDocumentsCellIdentifier = @"kDocumentsCellIdentifier";

/* Font */
static const CGFloat kDescriptionFontSize = 14.0f;

/* Size */
static const CGFloat kDocumentsItemSize = 112.0f;
static const CGFloat kDescriptionHeight = 100;

@interface DocumentsViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UITextView *titleDescriptionText;
@property (nonatomic, strong) UICollectionView *documentsCollection;
@property (nonatomic, strong) UICollectionViewFlowLayout *documentsLayout;
@property (nonatomic, strong) NSArray *documentsArray;
@property (nonatomic, strong) ADGetUserInfoResp *userInfoResp;

@end

@implementation DocumentsViewController

#pragma mark - UIViewController Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = kDocumentsViewTitle;
    self.view.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.96 alpha:1.0];
    
    [self.view addSubview:self.titleDescriptionText];
    [self.view addSubview:self.documentsCollection];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.titleDescriptionText.frame = CGRectMake(inset, inset * 2, ScreenWidth-inset*2, kDescriptionHeight);
    
    self.documentsCollection.frame = CGRectMake(4*inset, kDescriptionHeight, ScreenWidth-inset*8, ScreenHeight-kDescriptionHeight);
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.documentsArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DocumentsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kDocumentsCellIdentifier
                                                                    forIndexPath:indexPath];
    NSDictionary *cellModel = self.documentsArray[indexPath.row];
    cell.documentsIcon.image = [UIImage imageNamed:cellModel[@"documentIcon"]];
    cell.documentsTitle.text = cellModel[@"documentTitle"];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *cellModel = self.documentsArray[indexPath.row];
    if ([cellModel[@"documentUrl"] length] > 0) {
        ADShareViewController *shareView = [[ADShareViewController alloc] init];
        shareView.urlString = cellModel[@"documentUrl"];
        shareView.title = cellModel[@"documentTitle"];
        shareView.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:shareView
                                             animated:YES];
    } else {
        ADShowErrorAlert(@"暂无");
    }
}

#pragma mark - Lazy Initializer
- (UITextView *)titleDescriptionText {
    if (_titleDescriptionText == nil) {
        _titleDescriptionText = [[UITextView alloc] init];
        _titleDescriptionText.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.96 alpha:1.0];
        _titleDescriptionText.textColor = [UIColor lightGrayColor];
        _titleDescriptionText.text = kDocumentsDescription;
        _titleDescriptionText.font = [UIFont fontWithName:kChineseFont
                                                     size:kDescriptionFontSize];
        _titleDescriptionText.editable = NO;
    }
    return _titleDescriptionText;
}

- (UICollectionView *)documentsCollection {
    if (_documentsCollection == nil) {
        _documentsCollection = [[UICollectionView alloc] initWithFrame:CGRectZero
                                                  collectionViewLayout:self.documentsLayout];
        _documentsCollection.backgroundColor = [UIColor clearColor];
        [_documentsCollection registerNib:[UINib nibWithNibName:@"DocumentsCell" bundle:nil]
               forCellWithReuseIdentifier:kDocumentsCellIdentifier];
        _documentsCollection.dataSource = self;
        _documentsCollection.delegate = self;
    }
    return _documentsCollection;
}

- (UICollectionViewFlowLayout *)documentsLayout {
    if (_documentsLayout == nil) {
        _documentsLayout = [[UICollectionViewFlowLayout alloc] init];
        _documentsLayout.itemSize = CGSizeMake(kDocumentsItemSize, kDocumentsItemSize);
    }
    return _documentsLayout;
}

- (NSArray *)documentsArray {
    return @[@{
                 @"documentIcon": @"weChatLoginDocumentIcon",
                 @"documentTitle": @"登录授权",
                 @"documentUrl": @"http://mp.weixin.qq.com/s?__biz=MjM5NDAxMDg4MA==&mid=208833692&idx=1&sn=daa41a5b34ce7ffeb48985964e613941&scene=1&srcid=TnXuoDUuLCjDSJoLqkdG&from=singlemessage&isappinstalled=0#rd",
                 },
             @{
                 @"documentIcon": @"weChatShareDocumentIcon",
                 @"documentTitle": @"微信分享",
                 @"documentUrl": @"",
                 },
             @{
                 @"documentIcon": @"weChatPayDocumentIcon",
                 @"documentTitle": @"微信支付",
                 @"documentUrl": @"",
                },
             @{
                 @"documentIcon": @"weChatMoreDocumentIcon",
                 @"documentTitle": @"其他",
                 @"documentUrl": @"",
                 }];
}

@end