//
//  MainController.m
//  MoKo
//
//  Created by 谭 颢 on 11-7-3.
//  Copyright 2011 天府学院. All rights reserved.
//

#import "MainController.h"
#import "GirlListModel.h"
#import "PhotoListModel.h"
#import "SDDataCache.h"

@interface MainController()
@property (nonatomic, retain) NSArray *photoArray;
//显示相片
- (void)photoShow;

@end

@implementation MainController
@synthesize photoArray;

- (id)init{
	self=[super init];
	if (self) {
//		designListModel=[[GirlListModel alloc] initWithKind:0];
//		modelListModel=[[GirlListModel alloc] initWithKind:1];
//		actorListModel=[[GirlListModel alloc] initWithKind:2];
//		modelListModel.delegate=self;
//		designListModel.delegate=self;
//		actorListModel.delegate=self;
		
		allListInfoDic=[[NSMutableDictionary alloc] init];
	}
	return self;
}

- (void)dealloc{
	modelListModel.delegate=nil;
	designListModel.delegate=nil;
    actorListModel.delegate=nil;
	[modelListModel release];
	[designListModel release];
	[actorListModel release];
	
	[allListInfoDic release];
	
	[super dealloc];
}

#pragma mark -
#pragma mark CustomMethod

- (void)photoShow
{
    NSString *imgUrlString=[self.photoArray objectAtIndex:photoIndex];
    NSURL *imgUrl=[NSURL URLWithString:imgUrlString];
    
    NSImage *temImg=[NSImage imageNamed:@"egopv_photo.png"];
    [photoImgView setImageWithURL:imgUrl refreshCache:NO placeholderImage:temImg];
    
    NSString *pageString=[NSString stringWithFormat:@"%2d/%2d",photoIndex+1,[photoArray count]];
    [pageField setStringValue:pageString];
}

- (IBAction)kindClick:(id)sender
{
    NSToolbarItem *item=(NSToolbarItem*)sender;
    GirlListModel *list=nil;
    switch (item.tag-100) {
        case kGroupKindDesign:
        {
            groupIndex=kGroupKindDesign;
            list=[[GirlListModel alloc] initWithKind:kGroupKindDesign];
            break; 
        }   
        case kGroupKindModel:
        {
            groupIndex=kGroupKindModel;
            list=[[GirlListModel alloc] initWithKind:kGroupKindModel];
            break; 
        }
        case kGroupKindActor:
        {
            groupIndex=kGroupKindActor;
            list=[[GirlListModel alloc] initWithKind:kGroupKindActor];
            break; 
        }
        case kGroupKindIllustration:
        {
            groupIndex=kGroupKindIllustration;
            list=[[GirlListModel alloc] initWithKind:kGroupKindIllustration];
            break; 
        }
        case kGroupKindMusic:
        {
            groupIndex=kGroupKindMusic;
            list=[[GirlListModel alloc] initWithKind:kGroupKindMusic];
            break; 
        }
        case kGroupKindMovie:
        {
            groupIndex=kGroupKindMovie;
            list=[[GirlListModel alloc] initWithKind:kGroupKindMovie];
            break; 
        }
        case kGroupKindMedia:
        {
            groupIndex=kGroupKindMedia;
            list=[[GirlListModel alloc] initWithKind:kGroupKindMedia];
            break; 
        }
        case kGroupKindArts:
        {
            groupIndex=kGroupKindArts;
            list=[[GirlListModel alloc] initWithKind:kGroupKindArts];
            break; 
        }
        case kGroupKindMore:
        {
            groupIndex=kGroupKindMore;
            list=[[GirlListModel alloc] initWithKind:kGroupKindMore];
            break; 
        }
        default:
            break;
    }
    list.delegate=self;
    
    [girlTableView reloadData];
    [girlTableView deselectAll:nil];
}

- (IBAction)designClick:(id)sender{
	groupIndex=kGroupKindDesign;
	[girlTableView reloadData];
    [girlTableView deselectAll:nil];
}

- (IBAction)modelClick:(id)sender{
	groupIndex=kGroupKindModel;
	[girlTableView reloadData];
    [girlTableView deselectAll:nil];
}

- (IBAction)actorClick:(id)sender{
	groupIndex=kGroupKindActor;
	[girlTableView reloadData];
    [girlTableView deselectAll:nil];
}

- (IBAction)photoPageClick:(NSSegmentedControl *)sender{	
	if ([sender selectedSegment]==0) 
    {
        if (photoIndex==0) 
        {
            return;
        }
		photoIndex--;
	}else 
    {
        if ([photoArray count]==0 || photoIndex==[photoArray count]-1) 
        {
            return;
        }
		photoIndex++;
	}	
    
    [self photoShow];
}

- (IBAction)saveClick:(id)sender{
    
    NSSavePanel *savePanel=[NSSavePanel savePanel];
    savePanel.delegate=self;
    savePanel.nameFieldStringValue=[NSString stringWithFormat:@"%d.jpg",arc4random()];
    [savePanel beginSheetModalForWindow:[girlTableView window] completionHandler:^(NSInteger result) {
        ;
    }];
}

- (IBAction)cleanCache:(id)sender{
    [[SDDataCache sharedDataCache] clearDisk];
}

#pragma mark -
#pragma mark NSTableViewDataSource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
	NSDictionary *currentDic=[allListInfoDic objectForKey:[NSString stringWithFormat:@"%d",groupIndex]];
	if (currentDic) {
		return [[currentDic objectForKey:@"name"] count];
	}
	return 0;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
	NSDictionary *currentDic=[allListInfoDic objectForKey:[NSString stringWithFormat:@"%d",groupIndex]];
	
	if ([[tableView tableColumns] indexOfObject:tableColumn]==0) {
		NSArray *nameArray=[currentDic objectForKey:@"name"];
		NSString *girlName=[nameArray objectAtIndex:row];
		
		NSArray *jobArray=[currentDic objectForKey:@"job"];
		NSString *girlJob=[jobArray objectAtIndex:row];
		
		return [NSString stringWithFormat:@"%@\n%@",girlName,girlJob];
	}else {		                
        __block  NSInteger theRow=row;
        __block  NSString  *imgUrlStr=[[currentDic objectForKey:@"img"] objectAtIndex:row];
        __block  NSData    *imgData=[[SDDataCache sharedDataCache] dataFromKey:imgUrlStr];
        if (imgData)
        {
            NSImage *img=[[[NSImage alloc] initWithData:imgData] autorelease];
            return img;
        }
        else
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSData  *imgData=[[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:imgUrlStr]];
                if (imgData) 
                {
                    [[SDDataCache sharedDataCache] storeData:imgData forKey:imgUrlStr];
                    NSIndexSet *rowIndexes=[NSIndexSet indexSetWithIndex:theRow];
                    NSIndexSet *columnIndexes=[NSIndexSet indexSetWithIndex:1];	
                    [girlTableView reloadDataForRowIndexes:rowIndexes columnIndexes:columnIndexes];
                }	
            });
            return nil;
        }
	}
}

#pragma mark -
#pragma mark NSTableViewDelegate

- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row{
	NSDictionary *currentDic=[allListInfoDic objectForKey:[NSString stringWithFormat:@"%d",groupIndex]];
	//请求相册
	NSString *photoUrl=[[currentDic objectForKey:@"url"] objectAtIndex:row];
	
	if (photoList) {
		photoList.delegate=nil;
		[photoList release];
		photoList=nil;
	}
	photoList=[[PhotoListModel alloc] initWithUrlAddress:photoUrl];
	photoList.delegate=self;
	
	return YES;
}

#pragma mark -
#pragma mark GirlListModelDelegate

- (void)girlListRefreshFinish:(NSMutableDictionary *)girlDic withKind:(NSGroupKind)kind{
	[allListInfoDic setObject:girlDic forKey:[NSString stringWithFormat:@"%d",kind]];
	[girlTableView reloadData];
}

- (void)girlListRefreshFailWithError:(NSError *)error withKind:(NSGroupKind)kind{
	NSAssert(error==nil,@"第<%d>无法访问，错误信息:%@",kind,error);
}

#pragma mark -
#pragma mark PhotoListModelDelegate

- (void)photoListRefreshFinish:(NSArray *)aPhotoArray withPhotoListModel:(PhotoListModel*)aPhotoModel{
	
	self.photoArray=aPhotoArray;
	photoIndex=0;
    
    [self photoShow];
	
}

- (void)photoListRefreshFailWithError:(NSError *)error withPhotoListModel:(PhotoListModel*)aPhotoModel
{
    
}
	
#pragma mark -
#pragma mark NSOpenSavePanelDelegate

- (BOOL)panel:(id)sender shouldEnableURL:(NSURL *)url{
    NSLog(@"%@",url);
    return YES;
}

- (NSString *)panel:(id)sender userEnteredFilename:(NSString *)filename confirmed:(BOOL)okFlag{
    if ([filename hasSuffix:@".jpg"] || [filename hasSuffix:@".JPG"] || [filename hasSuffix:@".jpeg"] || [filename hasSuffix:@".JPEG"]) {
        return filename;
    }else{
        return [NSString stringWithFormat:@"%@.jpg",filename];
    }
}

- (BOOL)panel:(id)sender validateURL:(NSURL *)url error:(NSError **)outError{
    
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSImage *image=photoImgView.image;
    if (image) 
    {
        [image lockFocus];    
        //先设置 下面一个实例
        NSBitmapImageRep *bits = [[[NSBitmapImageRep alloc]initWithFocusedViewRect:NSMakeRect(0, 0, image.size.width, image.size.height)]autorelease];    
        [image unlockFocus];
        
        //再设置后面要用到得 props属性
        NSDictionary *imageProps = [NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:0.9] forKey:NSImageCompressionFactor];
        
        //之后 转化为NSData 以便存到文件中
        NSData *imageData = [bits representationUsingType:NSJPEGFileType properties:imageProps];
        
        NSDictionary *attributeDic=[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithUnsignedInteger:NSJPEGFileType],NSFileType,nil];
        [fileManager createFileAtPath:url.path contents:imageData attributes:attributeDic];
        //[imageData writeToFile:url.path atomically:YES];
    }
    [fileManager release];
    
    return YES;
}

@end
