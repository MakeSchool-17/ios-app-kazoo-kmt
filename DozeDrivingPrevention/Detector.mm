//
//  Detector.m
//  DozeDrivingPrevention
//
//  Created by 小林和宏 on 12/1/15.
//  Copyright © 2015 mycompany. All rights reserved.
//

#import "DozeDrivingPrevention-Bridging-Header.h"
#import <opencv2/opencv.hpp>
#import <opencv2/highgui/ios.h>

@interface Detector()
{
    cv::CascadeClassifier face_cascade;
    cv::CascadeClassifier eye1_cascade;
    cv::CascadeClassifier eye2_cascade;
}
@end

@implementation Detector: NSObject

- (id)init {
    self = [super init];
    
    // read the classifier
    NSBundle *face_bundle = [NSBundle mainBundle];
//    NSString *face_path = [face_bundle pathForResource:@"haarcascade_frontalface_alt" ofType:@"xml"];
    NSString *face_path = [face_bundle pathForResource:@"haarcascade_frontalface_alt2" ofType:@"xml"];
    std::string face_cascadeName = (char *)[face_path UTF8String];
    if(!face_cascade.load(face_cascadeName)) {
        return nil;
    }
    
    // Add cascade for eyes
    NSBundle *eye1_bundle = [NSBundle mainBundle];
//    NSString *eye1_path = [eye1_bundle pathForResource:@"haarcascade_eye" ofType:@"xml"];
    //    NSString *eye1_path = [eye1_bundle pathForResource:@"haarcascade_eye_tree_eyeglasses" ofType:@"xml"];
    NSString *eye1_path = [eye1_bundle pathForResource:@"haarcascade_righteye_2splits" ofType:@"xml"];
    std::string eye1_cascadeName = (char *)[eye1_path UTF8String];
    if(!eye1_cascade.load(eye1_cascadeName)) {
        return nil;
    }
    
    // Add cascade for eyes
    NSBundle *eye2_bundle = [NSBundle mainBundle];
    NSString *eye2_path = [eye2_bundle pathForResource:@"haarcascade_lefteye_2splits" ofType:@"xml"];
    std::string eye2_cascadeName = (char *)[eye2_path UTF8String];
    if(!eye2_cascade.load(eye2_cascadeName)) {
        return nil;
    }
    
    return self;
    
}

- (FacialFeatures)recognizeFace:(UIImage *)image {
     // get the screen & bar data for image size adjustment (this time, width gonna be the restriction, so rescale based on the width, not height)
     CGRect screenSize = [[UIScreen mainScreen] bounds]; // for iphone 5, 320
    int sessionImageWidth = 288;
    float scaleRatioWidth = screenSize.size.width / sessionImageWidth;

    FacialFeatures facialFeatures;

    facialFeatures.face.isDetected = false;
    facialFeatures.eye1.isDetected = false;
    facialFeatures.eye2.isDetected = false;
    
    // Transfer UIImage -> cv::Mat
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
    CGFloat cols = image.size.width;
    CGFloat rows = image.size.height;
    
    cv::Mat mat(rows, cols, CV_8UC4); // 8 bits per component, 4 channels (color channels + alpha)
    
    CGContextRef contextRef = CGBitmapContextCreate(mat.data, // Pointer to data
                                                    cols, // Width of bitmap
                                                    rows, // height of bitmap
                                                    8, // Bits per component
                                                    mat.step[0], // Bytes per row
                                                    colorSpace, // Colorspace
                                                    kCGImageAlphaNoneSkipLast |
                                                    kCGBitmapByteOrderDefault); // Bitmap info flags
    
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
    CGContextRelease(contextRef);
    
    // Face detection (image, output rectangle, scale for size reduction, minimum number of rectungle, flag, mimimum size of rectungle)
    std::vector<cv::Rect> face1; // Rect is defined by position of rectungle and length of row and column
    std::vector<cv::Rect> face2; // Rect is defined by position of rectungle and length of row and column
    face_cascade.detectMultiScale(mat,
                                  face1,
                                  1.1, 2,
                                  CV_HAAR_SCALE_IMAGE,
                                  cv::Size(80, 80)); // FIXME: You can choose appropriate frame size
    face2 = face1;
    std::cout << "number of faces: " << face1.size() << std::endl;
    
    std::vector<cv::Rect>::iterator r1 = face1.begin();
    
    for(; r1 != face1.end(); ++r1) {
        // Insert value to structure
        facialFeatures.face.featureRect.origin.x = r1->x * scaleRatioWidth;
        facialFeatures.face.featureRect.origin.y = r1->y;
        facialFeatures.face.featureRect.size.width = r1->width * scaleRatioWidth;
        facialFeatures.face.featureRect.size.height = r1->height * scaleRatioWidth;
        facialFeatures.face.isDetected = true;
        
        // Cut a lower half part in face
        r1->y = r1->y + r1->height * 0.2; // FIXME: Cut off 20% area from the top
        r1->height = r1->height * 0.3; // FIXME: Use 30% from top20% to top50%
        r1->x = r1->x + r1->width * 0.1; // FIXME: Cut off 10% area from the left
        r1->width = r1->width * 0.4; // FIXME: Use 40% from left10% to left50%
    // In each face, detect eyes
        cv::Mat faceROI1 = mat(*r1);
         // When changing the factor, you need to change const_iterator to interator
        std::vector<cv::Rect> eye1;
        eye1_cascade.detectMultiScale(faceROI1, eye1,
                                      1.1, 2,
                                      CV_HAAR_SCALE_IMAGE,
                                      cv::Size(10,10)); //FIXME: You can choose adjust frame size
        
        std::cout << "number of eye1: " << eye1.size() << std::endl;
        std::cout << "eye1 are closed?: " << eye1.empty() << std::endl; // Detect eyes are open or not
        
        // draw eyes' positions
        std::vector<cv::Rect>::const_iterator nr1 = eye1.begin(); // n means nested
//        int counterForEye = 0; // to store eyes value to both eye1Status and eye2Status
        for(; nr1 != eye1.end(); ++nr1) {
            std::cout << "eye1 rect: " << *nr1 << std::endl;
            
            // Insert value to structure
            facialFeatures.eye1.featureRect.origin.x = (r1->x + nr1->x) * scaleRatioWidth;
            facialFeatures.eye1.featureRect.origin.y = r1->y + nr1->y;
            facialFeatures.eye1.featureRect.size.width = nr1->width * scaleRatioWidth;
            facialFeatures.eye1.featureRect.size.height = nr1->height * scaleRatioWidth;
            facialFeatures.eye1.isDetected = true;
        }
    }
    
    std::vector<cv::Rect>::iterator r2 = face2.begin();
    
    for(; r2 != face2.end(); ++r2) {
        // Cut a lower half part in face
        r2->y = r2->y + r2->height * 0.2; // FIXME
        r2->height = r2->height * 0.3; // FIXME
        r2->x = r2->x + r2->width * 0.5; // FIXME: Use right half area
        r2->width = r2->width * 0.4; // FIXME: Cut off the last 10% area at right
        // In each face, detect eyes
        cv::Mat faceROI2 = mat(*r2);
        
        // When changing the factor, you need to change const_iterator to interator
        std::vector<cv::Rect> eye2;
        eye2_cascade.detectMultiScale(faceROI2, eye2,
                                      1.1, 2,
                                      CV_HAAR_SCALE_IMAGE,
                                        cv::Size(10,10));
//                                      cv::Size(5,5));
        
        std::cout << "number of eye2: " << eye2.size() << std::endl;
        std::cout << "eye2 are closed?: " << eye2.empty() << std::endl; // Detect eyes are open or not
        
        // draw eyes' positions
        std::vector<cv::Rect>::const_iterator nr2 = eye2.begin(); // n means nested
        //        int counterForEye = 0; // to store eyes value to both eye1Status and eye2Status
        for(; nr2 != eye2.end(); ++nr2) {
            std::cout << "eye2 rect: " << *nr2 << std::endl;
            
            // Insert value to structure
            facialFeatures.eye2.featureRect.origin.x = (r2->x + nr2->x) * scaleRatioWidth;
            facialFeatures.eye2.featureRect.origin.y = r2->y + nr2->y;
            facialFeatures.eye2.featureRect.size.width = nr2->width * scaleRatioWidth;
            facialFeatures.eye2.featureRect.size.height = nr2->height * scaleRatioWidth;
            facialFeatures.eye2.isDetected = true;
        }
    }
    return facialFeatures;
}

@end