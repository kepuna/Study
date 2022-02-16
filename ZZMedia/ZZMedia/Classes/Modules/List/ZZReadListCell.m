//
//  ZZReadListCell.m
//  ZZMedia
//
//  Created by MOMO on 2020/8/26.
//

#import "ZZReadListCell.h"
#import "ZZMediaPublic.h"

NSString * const ZZFONT_PF_MEDIUM = @"PingFangSC-Medium";
NSString * const ZZFONT_PF_BOLD = @"PingFangSC-Semibold";

@interface ZZReadListCell ()

@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) YYLabel *titleLabel;

@end

@implementation ZZReadListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.avatarImageView];
        [self.contentView addSubview:self.titleLabel];
        self.titleLabel.text = @"Read a new papper";
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.centerY.equalTo(self.contentView);
        make.width.height.mas_equalTo(self.mas_height).multipliedBy(0.8);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarImageView.mas_right).offset(10);
        make.centerY.equalTo(self.avatarImageView.mas_centerY);
    }];
}

- (UIImageView *)avatarImageView {
    if (_avatarImageView == nil) {
        _avatarImageView = [[UIImageView alloc] init];
        _avatarImageView.backgroundColor = [UIColor yellowColor];
        _avatarImageView.layer.cornerRadius = 5;
    }
    return _avatarImageView;
}

- (YYLabel *)titleLabel {
    if(!_titleLabel) {
        _titleLabel = [[YYLabel alloc] init];
        _titleLabel.font = [UIFont fontWithName:ZZFONT_PF_MEDIUM size:16];
        _titleLabel.textColor = rgb(43,43,44);
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabel;
}

@end
