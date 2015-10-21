//
//  CommentReplyFooterView.h
//  wechatauthdemo
//
//  Created by Jeason on 20/10/2015.
//  Copyright © 2015 boshao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickFooterCallBack)(void);

@interface CommentReplyFooterView : UITableViewCell

@property (nonatomic, strong) ClickFooterCallBack onClick;

@property (weak, nonatomic) IBOutlet UIButton *button;

@end
