//
//  DNAdJSONImageView.m
//  JSONToView
//
//  Created by donews on 2019/6/11.
//  Copyright © 2019年 donews. All rights reserved.
//

#import "DNAdJSONImageView.h"
#import "UIImageView+DNAdYYWebImage.h"
#import "DNAdJsonNotificationResultModel.h"

@implementation DNAdJSONImageView

- (void)setModel:(DNAdJSONImageModel *)model {
    _model = model;
    if (model == nil) {
        return;
    }
    NSString *url = @"";
    if(_model.url.length > 0) {
        url = _model.url;
    }
    if (_model.localImageName.length) {
        url = _model.localImageName;
    }
    if (_model.url.length > 0) {
        __weak typeof(self) _self = self;
        [self yy_setImageWithURL:[NSURL URLWithString:url]  placeholder:nil options:0 completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, DNAdYYWebImageFromType from, DNAdYYWebImageFromType stage, NSError * _Nullable error) {
            __strong typeof(_self) self = _self;
            if (image) {
                [self setImage:image];
            } else {
                [self setImage:[UIImage imageNamed:@"DNAdErrorPicFrame"]];
            }
            if (self.model.isNeedCallBack) {
                DNAdJsonNotificationResultModel *result = [self buildImageResultWith:image Url:url Error:error];
                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:result, @"imageView", nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"MDAsynchronousResourceData" object:nil userInfo:dic];
            }
        }];
        
    } else if (url.length > 0) {
        [self setImage:[UIImage imageNamed:url]];
    } else {
        [self setImage:[UIImage imageNamed:@"DNAdErrorPicFrame"]];
    }
    if (model.corner) {
        self.layer.cornerRadius = model.corner;
        self.layer.masksToBounds = YES;
    }
    if (model.border) {
        self.layer.borderWidth = model.border;
        self.layer.borderColor = model.borderColor?model.borderColor.CGColor:[UIColor blackColor].CGColor;
    }
    
    if (model.event) {
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(s_tapEvent)];
        [self addGestureRecognizer:tap];
    }
    
    [self sizeToFit];
}

- (void)s_tapEvent {
    NSLog(@"点击了ImageView");
}

- (DNAdJsonNotificationResultModel *)buildImageResultWith:(UIImage *)image Url:(NSURL *)imageUrl Error:(NSError *)error {
    DNAdJsonNotificationResultModel *model = [DNAdJsonNotificationResultModel new];
    model.imageURL = imageUrl;
    model.image = image;
    model.error = error;
    model.name = _model.url;
    return model;
}

@end
