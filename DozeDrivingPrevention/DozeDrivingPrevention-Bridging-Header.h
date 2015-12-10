//
//  Use this file to import your target's public headers that you would like to expose to Swift.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//#import <opencv2/opencv.hpp>
//#import <opencv2/highgui/ios.h>
//#import <list>
/*
typedef struct {
    std::vector<cv::Rect> faceLocation;
    std::list<std::vector<cv::Rect>> listOfEyesLocation;
}FaceLocationAndListOfEyesLocation;
*/



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
//- (UIImage *)recognizeFace:(UIImage *)image;
- (FacialFeatures)recognizeFace:(UIImage *)image;
@end