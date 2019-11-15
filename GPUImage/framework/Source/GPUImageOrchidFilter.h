#import "GPUImageFilterGroup.h"

@class GPUImagePicture;

@interface GPUImageOrchidFilter : GPUImageFilterGroup
{
    GPUImagePicture *lookupImageSource;
}

@end
