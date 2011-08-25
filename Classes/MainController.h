//
//  MainController.h
//  MoKo
//
//  Created by 谭 颢 on 11-7-3.
//  Copyright 2011 天府学院. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "GirlListModel.h"
#import "PhotoListModel.h"
#import "DownLoadData.h"
#import "SDImageView+SDWebCache.h"

@interface MainController : NSObject<GirlListModelDelegate,NSTableViewDelegate,NSTableViewDataSource
,PhotoListModelDelegate,NSOpenSavePanelDelegate>{
	IBOutlet NSTableView *girlTableView;
	IBOutlet NSView *girlInfoView;
    IBOutlet NSImageView *photoImgView;
    IBOutlet NSTextField *pageField;
	
	NSInteger groupIndex;                     //大类的index
	
	GirlListModel *designListModel;         //”摄影造型“模块数据模型
	GirlListModel *modelListModel;          //“模特儿”模块数据的模型
	GirlListModel *actorListModel;          //"演员主持"模块数据的模型
	
	NSMutableDictionary *allListInfoDic;    //所有列表中的信息	
	
	NSArray *photoArray;                  //相册的相片
	NSUInteger photoIndex;                 //当前相册是第几张
    
	PhotoListModel *photoList;            //用来下载某位模特图册列表
	
	DownLoadData *photoDown;              //用来下载图片的
}

- (IBAction)kindClick:(id)sender;

- (IBAction)modelClick:(id)sender;
- (IBAction)designClick:(id)sender;
- (IBAction)actorClick:(id)sender;

//翻页
- (IBAction)photoPageClick:(NSSegmentedControl *)sender;
//保存
- (IBAction)saveClick:(id)sender;
//清理缓存
- (IBAction)cleanCache:(id)sender;

@end
