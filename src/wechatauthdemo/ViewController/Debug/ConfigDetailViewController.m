//
//  ConfigDetailViewController.m
//  wechatauthdemo
//
//  Created by Jeason on 15/09/2015.
//  Copyright © 2015 boshao. All rights reserved.
//

#import "ButtonColor.h"
#import "InputWithTextFieldCell.h"
#import "ConfigDetailViewController.h"
#import "ADNetworkConfigManager.h"
#import "ADNetworkConfigItem.h"

@interface ConfigDetailViewController ()

@property (nonatomic, strong) NSArray* configItemNameArray;
@property (nonatomic, strong) NSMutableDictionary *configTextFieldDict;
@end

@implementation ConfigDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"配置详情";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存"
                                                                             style:UIBarButtonItemStyleDone
                                                                            target:self
                                                                            action:@selector(onClickSave:)];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.tableFooterView.backgroundColor = [UIColor clearColor];
    [self.tableView registerNib:[UINib nibWithNibName:@"InputWithTextFieldCell"
                                               bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:@"configCell"];
    self.configTextFieldDict = [NSMutableDictionary dictionary];
    self.configItemNameArray = [[self.configItem dictionaryRepresentation] allKeys];
}

#pragma mark - User Actions
- (void)onClickSave:(UIButton *)sender {
    
    self.configItem.cgiName = [[self.configTextFieldDict objectForKey:self.configItemNameArray[0]] text];
    self.configItem.encryptKeyPath = [[self.configTextFieldDict objectForKey:self.configItemNameArray[1]] text];
    self.configItem.encryptAlgorithm = [[[self.configTextFieldDict objectForKey:self.configItemNameArray[2]] text] intValue];
    self.configItem.decryptAlgorithm = [[[self.configTextFieldDict objectForKey:self.configItemNameArray[3]] text] intValue];
    self.configItem.requestPath = [[self.configTextFieldDict objectForKey:self.configItemNameArray[4]] text];
    self.configItem.httpMethod = [[self.configTextFieldDict objectForKey:self.configItemNameArray[5]] text];
    self.configItem.decryptKeyPath = [[self.configTextFieldDict objectForKey:self.configItemNameArray[6]] text];
    
    [[ADNetworkConfigManager sharedManager] registerConfig:self.configItem
                                                forKeyPath:self.configItem.cgiName];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.configItemNameArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    InputWithTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"configCell"
                                                                   forIndexPath:indexPath];
    // Configure the cell...
    NSString *configName = self.configItemNameArray[indexPath.row];
    cell.descLabel.text = configName;
    cell.descLabel.font = [UIFont fontWithName:kEnglishNumberFont
                                          size:11];
    cell.descLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.descLabel.textColor = [UIColor linkButtonColor];
    if (indexPath.row == 0) {
        cell.textField.textColor = [UIColor lightGrayColor];
        cell.textField.userInteractionEnabled = NO;
    }
    cell.textField.text = [[[self.configItem dictionaryRepresentation] objectForKey:configName] description];
    cell.textField.font = [UIFont fontWithName:kEnglishNumberFont
                                          size:11];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.configTextFieldDict setObject:cell.textField
                                 forKey:configName];
    return cell;
}

@end
