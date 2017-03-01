//
//  ViewController.m
//  异步加载图片
//
//  Created by 梁家伟 on 17/3/1.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "ViewController.h"
#import "AFHTTPSessionManager.h"
#import "HMModel.h"
#import "YYModel.h"
#import "UIImageView+WebCache.h"
#import "HMImageDownloader.h"
#import "NSString+HMSandBoxImagePath.h"

@interface ViewController ()
@property(nonatomic,strong)NSArray<HMModel*>* modelList;
@property(nonatomic,strong)NSOperationQueue* queue;
@property(nonatomic,strong)NSMutableDictionary* cacheImgList;
@property(nonatomic,strong)NSMutableDictionary* operationList;
@end

//"https://raw.githubusercontent.com/luowenqi/SZiOS09/master/apps.json" 

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSLog(@"%@",NSHomeDirectory());
    
    _cacheImgList = [NSMutableDictionary dictionary];
    _operationList = [NSMutableDictionary dictionary];
    
    [self loadData];
}

-(NSOperationQueue *)queue{
    
    if (_queue == nil) {
        _queue = [[NSOperationQueue alloc]init];
    }
    return _queue;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _modelList.count;
}


#pragma mark:1 - 加载图片
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HMModel* model = _modelList[indexPath.row];
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"app" forIndexPath:indexPath];
    
    cell.textLabel.text = _modelList[indexPath.row].name;
    cell.detailTextLabel.text = _modelList[indexPath.row].download;
    
    //如果有缓存图片就不回去网络加载图片
    if(_cacheImgList[model.icon]){
        cell.imageView.image = _cacheImgList[model.icon];
        return cell;
    }
    

    UIImage* sandBoxImg = [UIImage imageWithContentsOfFile:[model.icon hm_ImagePath]];
    
    //如果有图片持久化操作，就不会去加载网络图片
    if(sandBoxImg){
        cell.imageView.image = sandBoxImg;
        return cell;
    }
    
#pragma mark:2 占位图片
    cell.imageView.image = [UIImage imageNamed:@"user_default"];

    
    if(_operationList[model.icon]){
        return cell;
    }
    
    HMImageDownloader* downloader = [[HMImageDownloader alloc]initWithString:model.icon andSuccessBlock:^(UIImage *image) {
        [_cacheImgList setObject:image forKey:model.icon];
        
        //所以不能直接设置图片
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }];

    
    //把操作添加进去字典中，缓存起来
    [_operationList setObject:downloader forKey:model.icon];
    
    //如果没有对图片进行缓存，每次都会去网络加载图片
    [self.queue addOperation:downloader];
    
    return cell;
}

-(void)loadData{
    
    AFHTTPSessionManager* manager = [[AFHTTPSessionManager alloc]init];
    
    [manager GET:@"https://raw.githubusercontent.com/luowenqi/SZiOS09/master/apps.json" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        self.modelList = [NSArray yy_modelArrayWithClass:[HMModel class] json:responseObject];
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
