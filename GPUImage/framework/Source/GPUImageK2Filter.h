#import "GPUImageFilterGroup.h"

@class GPUImagePicture;

@interface GPUImageK2Filter : GPUImageFilterGroup
{
    GPUImagePicture *lookupImageSource;
}

@end
