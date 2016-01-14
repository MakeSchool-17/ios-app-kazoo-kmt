//
//  Use this file to import your target's public headers that you would like to expose to Swift.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef struct {
    CGRect featureRect; // this includes x, y, width and height
    bool isDetected;
}Feature;

typedef struct {
    Feature face;
    Feature eye1;
    Feature eye2;
}FacialFeatures;

@interface Detector: NSObject
- (id)init;
- (FacialFeatures)recognizeFace:(UIImage *)image;
@end