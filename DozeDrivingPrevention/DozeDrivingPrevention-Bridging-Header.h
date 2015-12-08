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
/*
struct FaceAndEyes {
    double xPosition;
    double yPosition;
    double width;
    double height;
    bool isDetected;
};
 */
@interface Detector: NSObject
- (id)init;
- (UIImage *)recognizeFace:(UIImage *)image;
//- (FaceLocationAndListOfEyesLocation)recognizeFace:(UIImage *)image;
@end