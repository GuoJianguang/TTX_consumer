//
//  ImageViewer.m
//  Tourguide
//
//  Created by inphase on 15/7/1.
//  Copyright (c) 2015年 inphase. All rights reserved.
//

#import "ImageViewer.h"
#import "ZLPhoto.h"

@interface ImageViewer()<ZLPhotoPickerBrowserViewControllerDataSource,ZLPhotoPickerBrowserViewControllerDelegate>

@end
@implementation ImageViewer

static ImageViewer *_instance = nil;

+(ImageViewer*) sharedImageViewer {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[ImageViewer alloc] init];
    });
    return _instance;
}

- (void)showImageViewer:(NSMutableArray *)array withIndex:(NSInteger)index andView:(UIView *)view
{
    self.imagearay = array;
    // 图片游览器
    ZLPhotoPickerBrowserViewController *pickerBrowser = [[ZLPhotoPickerBrowserViewController alloc] init];
    // 传入点击图片View的话，会有微信朋友圈照片的风格
//    pickerBrowser.toView = view;
    // 数据源/delegate
    pickerBrowser.delegate = self;
    pickerBrowser.dataSource = self;
    // 是否可以删除照片
    pickerBrowser.editing = NO;
    // 当前选中的值
    pickerBrowser.currentIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
//    pickerBrowser.currentIndexPath.item = index;
    // 展示控制器
//    [[[[[UIApplication sharedApplication] windows]. presentViewController:pickerBrowser animated:YES completion:nil];
    [self.controller presentViewController:pickerBrowser animated:YES completion:NULL];
//    [pickerBrowser show];
}

- (NSInteger)numberOfSectionInPhotosInPickerBrowser:(ZLPhotoPickerBrowserViewController *)pickerBrowser
{
    return 1;
}

- (NSInteger)photoBrowser:(ZLPhotoPickerBrowserViewController *)photoBrowser numberOfItemsInSection:(NSUInteger)section
{
    return self.imagearay.count;
}

#pragma mark - 每个组展示什么图片,需要包装下ZLPhotoPickerBrowserPhoto
- (ZLPhotoPickerBrowserPhoto *) photoBrowser:(ZLPhotoPickerBrowserViewController *)pickerBrowser photoAtIndexPath:(NSIndexPath *)indexPath{
//    ZLPhotoAssets *imageObj = [self.imagearay objectAtIndex:indexPath.row];
    // 包装下imageObj 成 ZLPhotoPickerBrowserPhoto 传给数据源
    ZLPhotoPickerBrowserPhoto *photo = [ZLPhotoPickerBrowserPhoto photoAnyImageObjWith:self.imagearay[indexPath.row]];
    photo.photoURL = [NSURL URLWithString:self.imagearay[indexPath.row]];
//    photo.thumbImage = self.imagearay[indexPath.row];
    return photo;
}

@end
