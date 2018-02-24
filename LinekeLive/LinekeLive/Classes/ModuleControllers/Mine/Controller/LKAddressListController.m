//
//  LKAddressListViewController.m
//  LinekeLive
//
//  Created by Original_TJ on 2018/2/23.
//  Copyright © 2018年 CODER_TJ. All rights reserved.
//



#import "LKAddressListController.h"
#import <ContactsUI/ContactsUI.h>
#import <Contacts/Contacts.h>

@interface LKAddressListController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView    *addressTable;
@property (nonatomic, strong) NSMutableArray *addressGroup;

@end

@implementation LKAddressListController

#pragma mark - Lazy
- (NSMutableArray *)addressGroup {
    
    if (!_addressGroup) {
        _addressGroup = [[NSMutableArray alloc] init];
    }
    return _addressGroup;
}

- (UITableView *)addressTable {
    
    if (!_addressTable) {
        _addressTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
        _addressTable.dataSource = self;
        _addressTable.delegate = self;
        _addressTable.showsVerticalScrollIndicator = NO;
        _addressTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return _addressTable;
}

#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.title = @"通讯录";
    
    [self initSubview];
    [self addContacts];
}

- (void)initSubview
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.addressTable];
}

- (void)addContacts
{
    CNAuthorizationStatus authorizationStatus = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    
    if (authorizationStatus == CNAuthorizationStatusAuthorized) {
        CNContactStore *store = [[CNContactStore alloc] init];
        
        [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                NSLog(@"授权成功");
                // 2. 获取联系人仓库
                CNContactStore * store = [[CNContactStore alloc] init];
                
                // 3. 创建联系人信息的请求对象
                NSArray * keys = @[CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey];
                
                // 4. 根据请求Key, 创建请求对象
                CNContactFetchRequest * request = [[CNContactFetchRequest alloc] initWithKeysToFetch:keys];
                
                // 5. 发送请求
                [store enumerateContactsWithFetchRequest:request error:nil usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
                    
                    // 6.1 获取姓名
                    NSString * givenName  = contact.givenName;
                    NSString * familyName = contact.familyName;
                    NSLog(@"%@--%@", givenName, familyName);
                    
                    NSMutableDictionary *addressDict = [NSMutableDictionary dictionary];
                    [addressDict setObject:[NSString stringWithFormat:@"%@%@", familyName, givenName] forKey:@"name"];
                    
                    // 6.2 获取电话
                    NSArray *results = contact.phoneNumbers;
                    for (CNLabeledValue *labelValue in results) {
                        CNPhoneNumber * number = labelValue.value;
                        NSLog(@"%@--%@", number.stringValue, labelValue.label);
                        
                        [addressDict setObject:number.stringValue forKey:@"phone"];
                    }
                    
                    [self.addressGroup addObject:addressDict];
                }];
            }
        }];
    }
    
    [self.addressTable reloadData];
}

#pragma mark - <UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.addressGroup.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *titleFromCellIdentifier = @"titleFromCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:titleFromCellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:titleFromCellIdentifier];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        if (self.addressGroup.count > indexPath.row) {
            NSDictionary *dict        = self.addressGroup[indexPath.row];
            cell.textLabel.text       = dict[@"name"];
            cell.detailTextLabel.text = dict[@"phone"];
        }
    }
    return cell;
}

@end
