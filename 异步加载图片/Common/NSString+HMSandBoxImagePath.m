//
//  NSString+HMSandBoxImagePath.m
//  异步加载图片
//
//  Created by 梁家伟 on 17/3/1.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "NSString+HMSandBoxImagePath.h"

@implementation NSString (HMSandBoxImagePath)

-(instancetype)hm_ImagePath{
    
    NSString* sandBoxPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    
    NSString* fileName = [self lastPathComponent];
    
    return [sandBoxPath stringByAppendingPathComponent:fileName];
}
@end
