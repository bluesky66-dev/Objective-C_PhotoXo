#import "GPUImageFilterGroup.h"

@class GPUImagePicture;

@interface GPUImageGoblinFilter : GPUImageFilterGroup
{
    GPUImagePicture *lookupImageSource;
}

@end
