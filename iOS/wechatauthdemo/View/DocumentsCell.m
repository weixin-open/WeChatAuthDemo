//
//  DocumentsCell.m
//  wechatauthdemo
//
//  Created by WeChat on 15/10/2015.
//  Copyright © 2015 Tencent. All rights reserved.
//

#import "DocumentsCell.h"

static const CGFloat kDocumentsTitleFontSize = 16.0f;

@implementation DocumentsCell

- (void)awakeFromNib {
    // Initialization code
    self.documentsTitle.font = [UIFont fontWithName:kChineseFont
                                               size:kDocumentsTitleFontSize];
}

@end
