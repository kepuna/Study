//
//  RCGPUImageR101Filter.m
//  Renren-iOS-StickerCamera
//
//  Created by 0153-00503 on 15/10/22.
//  Copyright © 2015年 renren. All rights reserved.
//

#import "RCGPUImageR101Filter.h"
#import <GPUImage.h>

@implementation RCGPUImageR101Filter

- (id)init {
    if (!(self = [super init])){
        return nil;
    }
    
    NSBundle *resBundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"RRCameraRes" ofType:@"bundle"]];
    
    //ToneCurve1
    GPUImageToneCurveFilter *ToneCurveFilter1 = [[GPUImageToneCurveFilter alloc] initWithACVURL:[resBundle URLForResource:@"R101_1" withExtension:@"acv"]];
    [self addFilter:ToneCurveFilter1];
    
    self.initialFilters = [NSArray arrayWithObjects:ToneCurveFilter1,nil];
    self.terminalFilter = ToneCurveFilter1;
    return self;
}
@end
