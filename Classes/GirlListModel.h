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
    kGroupKindDesign=0,
	kGroupKindModel,
	kGroupKindActor,
    kGroupKindIllustration,
    kGroupKindMusic,
    kGroupKindMovie,
    kGroupKindMedia,
    kGroupKindArts,
    kGroupKindMore
};
typedef NSInteger NSGroupKind;

//所以模特列表的URL地址
static NSString* const urlAddress[]={
	@"http://www.moko.cc/channels/second/post/28/3/1.html",
	@"http://www.moko.cc/channels/second/post/23/3/1.html",
	@"http://www.moko.cc/channels/second/post/143/3/1.html",
    @"http://www.moko.cc/channels/second/post/41/2/1.html",
    @"http://www.moko.cc/channels/second/post/13/3/1.html",
    @"http://www.moko.cc/channels/second/post/1/3/1.html",
    @"http://www.moko.cc/channels/second/post/53/3/1.html",
    @"http://www.moko.cc/channels/second/post/71/3/1.html",
    @"http://www.moko.cc/channels/second/post/94/3/1.html"
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
@property (nonatomic, assign) NSGroupKind theKind;

@property (nonatomic, readonly) NSMutableArray *urlArray;
@property (nonatomic, readonly) NSMutableArray *imgArray;
@property (nonatomic, readonly) NSMutableArray *nameArray;
@property (nonatomic, readonly) NSMutableArray *jobArray;

- (id)initWithKind:(NSGroupKind)kind;

@end

@protocol GirlListModelDelegate<NSObject>

- (void)girlListRefreshFinish:(GirlListModel *)listModel withInfo:(NSDictionary *)girlDic;
- (void)girlListRefreshFail:(GirlListModel *)listModel withError:(NSError *)error;

//- (void)girlListRefreshFinish:(NSMutableDictionary *)girlDic withKind:(NSGroupKind)kind;
//- (void)girlListRefreshFailWithError:(NSError *)error withKind:(NSGroupKind)kind;

@end
