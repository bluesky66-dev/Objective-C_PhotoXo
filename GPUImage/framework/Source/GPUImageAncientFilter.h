#import "GPUImageFilterGroup.h"

@class GPUImagePicture;

// Note: If you want to use this effect you have to add lookup_amatorka.png
//       from Resources folder to your application bundle.

@interface GPUImageAncientFilter : GPUImageFilterGroup
{
    GPUImagePicture *lookupImageSource;
}

@end
