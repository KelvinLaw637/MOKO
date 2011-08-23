//
//  GirlListModel.m
//  MoKo
//
//  Created by 谭 颢 on 11-7-3.
//  Copyright 2011 天府学院. All rights reserved.
//

#import "GirlListModel.h"

@implementation GirlListModel
@synthesize delegate;

@synthesize urlArray;
@synthesize imgArray;
@synthesize nameArray;
@synthesize jobArray;

- (id)initWithKind:(NSGroupKind)kind{
	self=[super init];
	if (self) {
		urlArray=[[NSMutableArray alloc] init];
		imgArray=[[NSMutableArray alloc] init];
		nameArray=[[NSMutableArray alloc] init];
		jobArray=[[NSMutableArray alloc] init];
		
		theKind=kind;
        
        NSURL *downUrl=[NSURL URLWithString:urlAddress[theKind]];
        [[SDWebDataManager sharedManager] downloadWithURL:downUrl delegate:self refreshCache:YES];
	}
	return self;
}

- (void)dealloc{
	[urlArray release];
	[imgArray release];
	[nameArray release];
	[jobArray release];
	
	[super dealloc];
}

#pragma mark -
#pragma mark SDWebDataManagerDelegate

- (void)webDataManager:(SDWebDataManager *)dataManager didFinishWithData:(NSData *)aData
{
    TFHpple *tfHpple=[[TFHpple alloc] initWithHTMLData:aData];
	
    NSArray *URLNodes=[tfHpple search:@"//a[@class='video-link']"];
	NSArray *ImgNodes=[tfHpple search:@"//img[@class='cover']"];
	NSArray *jobNodes=[tfHpple search:@"//p[@class='info gC1']"];
	
	for(TFHppleElement* node in URLNodes){
		[urlArray addObject:[node objectForKey:@"href"]];
	}
	for(TFHppleElement* node in ImgNodes){
		[imgArray addObject:[node objectForKey:@"src2"]];
		[nameArray addObject:[node objectForKey:@"title"]];
	}
	for(TFHppleElement* node in jobNodes){
		[jobArray addObject:[node content]];
	}
	[tfHpple release];
	
	NSMutableDictionary *girlDic=[[[NSMutableDictionary alloc] initWithObjectsAndKeys:urlArray,@"url",
                                   imgArray,@"img",nameArray,@"name",jobArray,@"job",nil] autorelease];
	if ([delegate respondsToSelector:@selector(girlListRefreshFinish:withKind:)]) {
		[delegate girlListRefreshFinish:girlDic withKind:theKind];
	}
}
- (void)webDataManager:(SDWebDataManager *)dataManager didFailWithError:(NSError *)error
{
    if ([delegate respondsToSelector:@selector(girlListRefreshFailWithError:withKind:)]) {
        [delegate girlListRefreshFailWithError:error withKind:theKind];
    }
}

@end
