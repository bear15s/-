
//
//  HMImageDownloader.m
//  异步加载图片
//
//  Created by 梁家伟 on 17/3/1.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "HMImageDownloader.h"
#import "NSString+HMSandBoxImagePath.h"
@interface HMImageDownloader ()

@end
@implementation HMImageDownloader

-(instancetype)initWithString:(NSString*)str andSuccessBlock:(void(^)(UIImage* image))callBackBlock{
    
    HMImageDownloader* downloader = [[HMImageDownloader alloc]init];
    downloader.callBackBlock = callBackBlock;
    
    downloader.urlString = str;
    
    return downloader;
}

-(void)main{
    
    //加载图片更新界面
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.urlString]];
    
    UIImage* image = [UIImage imageWithData:data];
    
    //如果加载到图片了，才保存到沙盒里面
    if(image){
    [data writeToFile:[self.urlString hm_ImagePath] atomically:NO];
    }
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        self.callBackBlock(image);
    }];

}


@end
