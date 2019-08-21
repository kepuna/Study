//
//  DNAdJSONStackView.m
//  JSONToView
//
//  Created by donews on 2019/6/28.
//  Copyright © 2019年 donews. All rights reserved.
//

#import "DNAdJSONStackView.h"
#import "DNAdJSONStackViewModel.h"
#import "DNAdJSONLabel.h"
#import "DNAdJSONImageView.h"
#import "DNAdJSONView.h"

@implementation DNAdJSONStackView

- (void)setModel:(DNAdJSONStackViewModel *)model {
    _model = model;
    if (_model){
        self.axis = model.layout;
        self.spacing = model.spacing;
        self.distribution = UIStackViewDistributionFillEqually;
        self.alignment = UIStackViewAlignmentFill;
        
        if (model.backgroundColor) {
            self.backgroundColor = model.backgroundColor;
        }
        if (model.corner) {
            self.layer.cornerRadius = model.corner;
        }
        if (model.border) {
            self.layer.borderWidth = model.border;
            self.layer.borderColor = model.borderColor?model.borderColor.CGColor:[UIColor blackColor].CGColor;
        }
        
        for (DNAdJSONModel *subModel in model.subViews) {
            if ([subModel isKindOfClass:[DNAdJSONViewModel class]]) {
                DNAdJSONView *view = [DNAdJSONView new];
                view.model = (DNAdJSONViewModel *)subModel;
                [self addArrangedSubview:view];
            }
            if ([subModel isKindOfClass:[DNAdJSONImageModel class]]) {
                DNAdJSONImageView *imgView = [DNAdJSONImageView new];
                imgView.model = (DNAdJSONImageModel *)subModel;
                [self addArrangedSubview:imgView];
            }
            if ([subModel isKindOfClass:[DNAdJSONLabelModel class]]) {
                DNAdJSONLabel *label = [DNAdJSONLabel new];
                label.model = (DNAdJSONLabelModel *)subModel;
                [self addArrangedSubview:label];
            }
        }
    }
}

@end
