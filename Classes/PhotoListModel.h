//
//  PhotoListModel.h
//  Moko
//
//  Created by 谭 颢 on 11-7-3.
//  Copyright 2011 天府学院. All rights reserved.
//

/*
 取得某个女孩所有的图片信息
 */

#import <Cocoa/Cocoa.h>
#import "SDWebDataManager.h"

@protocol PhotoListModelDelegate;
@interface PhotoListModel : NSObject<SDWebDataManagerDelegate> {
	id<PhotoListModelDelegate> delegate;
}
@property (nonatomic,assign) id<PhotoListModelDelegate> delegate;

- (id)initWithUrlAddress:(NSString *)address;

@end


@protocol PhotoListModelDelegate<NSObject>

- (void)photoListRefreshFinish:(NSArray *)aPhotoArray withPhotoListModel:(PhotoListModel*)aPhotoModel;
- (void)photoListRefreshFailWithError:(NSError *)error withPhotoListModel:(PhotoListModel*)aPhotoModel;

@end
