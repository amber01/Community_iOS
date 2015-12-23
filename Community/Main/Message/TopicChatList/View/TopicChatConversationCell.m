//
//  TopicChatConversationCell.m
//  Community
//
//  Created by shlity on 15/12/23.
//  Copyright © 2015年 shlity. All rights reserved.
//

#import "TopicChatConversationCell.h"

@implementation TopicChatConversationCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        
        _imgHeader = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 40, 40)];
        [UIUtils setupViewRadius:_imgHeader cornerRadius:_imgHeader.height/2];
        _imgHeader.image = [UIImage imageNamed:@"mine_login.png"];
        [self addSubview:_imgHeader];
        
        _labName = [[UILabel alloc]initWithFrame:CGRectMake(60, 5, 250, 20)];
        _labName.text = @"amber";
        [self addSubview:_labName];
        
        _labMsg = [[UILabel alloc]initWithFrame:CGRectMake(60, 25, 250, 20)];
        _labMsg.text = @"hello";
        _labMsg.font = [UIFont systemFontOfSize:15];
        _labMsg.textColor = [UIColor grayColor];
        [self addSubview:_labMsg];
        
        _labTime = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth - 130, 5, 120, 20)];
        _labTime.textAlignment = NSTextAlignmentRight;
        _labTime.text = @"2001-12-11 09:23";
        _labTime.textColor = [UIColor grayColor];
        _labTime.font = [UIFont systemFontOfSize:14];
        [self addSubview:_labTime];
        
    }
    
    return self;
}

- (void)setDictInfo:(NSDictionary *)dictInfo
{
    
}
@end
