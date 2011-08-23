//
//  GirlListModel.h
//  MoKo
//
//  Created by 谭 颢 on 11-7-3.
//  Copyright 2011 天府学院. All rights reserved.
//

/*
 取得该类别中所以女孩的列表信息
 */

#import <Cocoa/Cocoa.h>
#import "SDWebDataManager.h"
#import "TFHpple.h"

enum GroupKind {
    kGroupKindDesign,
	kGroupKindModel,
	kGroupKindActor
};
typedef NSInteger NSGroupKind;

//所以模特列表的URL地址
static NSString* const urlAddress[]={
	@"http://www.moko.cc/channels/second/post/28/3/1.html",
	@"http://www.moko.cc/channels/second/post/23/3/1.html",
	@"http://www.moko.cc/channels/second/post/143/3/1.html"
};

@protocol GirlListModelDelegate;
@interface GirlListModel : NSObject<SDWebDataManagerDelegate> {
	id<GirlListModelDelegate> delegate;
	
	NSGroupKind theKind;
	
	NSMutableArray *urlArray;
	NSMutableArray *imgArray;
	NSMutableArray *nameArray;
	NSMutableArray *jobArray;
}
@property (nonatomic, assign) id<GirlListModelDelegate> delegate;

@property (nonatomic, readonly) NSMutableArray *urlArray;
@property (nonatomic, readonly) NSMutableArray *imgArray;
@property (nonatomic, readonly) NSMutableArray *nameArray;
@property (nonatomic, readonly) NSMutableArray *jobArray;

- (id)initWithKind:(NSGroupKind)kind;

@end

@protocol GirlListModelDelegate<NSObject>

- (void)girlListRefreshFinish:(NSMutableDictionary *)girlDic withKind:(NSGroupKind)kind;
- (void)girlListRefreshFailWithError:(NSError *)error withKind:(NSGroupKind)kind;

@end
