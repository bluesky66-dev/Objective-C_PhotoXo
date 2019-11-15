#import "GPUImageFilterGroup.h"

@class GPUImagePicture;

@interface GPUImageTenderFilter : GPUImageFilterGroup
{
    GPUImagePicture *lookupImageSource;
}

@end
