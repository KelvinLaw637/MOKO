//
//  PhotoListModel.m
//  Moko
//
//  Created by 谭 颢 on 11-7-3.
//  Copyright 2011 天府学院. All rights reserved.
//

#import "PhotoListModel.h"
#import "TFHpple.h"

@implementation PhotoListModel
@synthesize delegate;

- (id)initWithUrlAddress:(NSString *)address{
	self=[super init];
	if (self) {
		NSString *urlString=[NSString stringWithFormat:@"http://www.moko.cc%@",address];
        NSURL *downUrl=[NSURL URLWithString:urlString];
        [[SDWebDataManager sharedManager] downloadWithURL:downUrl delegate:self refreshCache:YES];
	}
	return self;
}

- (void)dealloc{
	[super dealloc];
}

#pragma mark -
#pragma mark SDWebDataManagerDelegate

- (void)webDataManager:(SDWebDataManager *)dataManager didFinishWithData:(NSData *)aData
{
    TFHpple *tfHpple=[[TFHpple alloc] initWithHTMLData:aData];
	
	NSMutableArray *photoArray=[[[NSMutableArray alloc] init] autorelease];
	
	NSArray *ImgNodes=[tfHpple search:@"//p[@class='picBox']/img"];
	for(TFHppleElement* node in ImgNodes){
		[photoArray addObject:[node objectForKey:@"src2"]];
	}
	if ([delegate respondsToSelector:@selector(photoListRefreshFinish:withPhotoListModel:)]) {
		[delegate photoListRefreshFinish:photoArray withPhotoListModel:self];
	}
}
- (void)webDataManager:(SDWebDataManager *)dataManager didFailWithError:(NSError *)error
{
    if ([delegate respondsToSelector:@selector(photoListRefreshFailWithError:withPhotoListModel:)]) {
		[delegate photoListRefreshFailWithError:error withPhotoListModel:self];
	}
}

@end
