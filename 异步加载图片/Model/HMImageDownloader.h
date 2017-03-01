//
//  HMImageDownloader.h
//  异步加载图片
//
//  Created by 梁家伟 on 17/3/1.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HMImageDownloader : NSOperation

-(instancetype)initWithString:(NSString*)str andSuccessBlock:(void(^)(UIImage* image))callBackBlock;
@property(nonatomic,copy) void(^callBackBlock)(UIImage* image);
@property(nonatomic,strong)NSURL* url;
@property(nonatomic,copy)NSString* urlString;
@end
