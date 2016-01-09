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
    cv::CascadeClassifier eyes_cascade;
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
    NSBundle *eyes_bundle = [NSBundle mainBundle];
    NSString *eyes_path = [eyes_bundle pathForResource:@"haarcascade_eye" ofType:@"xml"];
//    NSString *eyes_path = [eyes_bundle pathForResource:@"M. Rezaei- Closed Eye Classifier" ofType:@"xml"];
    //    NSString *eyes_path = [eyes_bundle pathForResource:@"haarcascade_eye_tree_eyeglasses" ofType:@"xml"];
//        NSString *eyes_path = [eyes_bundle pathForResource:@"haarcascade_righteye_2splits" ofType:@"xml"];
    std::string eyes_cascadeName = (char *)[eyes_path UTF8String];
    
    if(!eyes_cascade.load(eyes_cascadeName)) {
        return nil;
    }
    
    return self;
    
}

- (FacialFeatures)recognizeFace:(UIImage *)image {
//- (UIImage *)recognizeFace:(UIImage *)image { // for debugging

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
 
    // transform to gray scale
//    cv::Mat gray_mat(rows, cols, CV_8UC4);
//    cv::cvtColor(mat, gray_mat, CV_BGR2GRAY);
    // decrease image size in order to decrease processing time
//    double scale = 1.0;
//    cv::Mat smallImg(cv::saturate_cast<int>(gray_mat.rows/scale), cv::saturate_cast<int>(gray_mat.cols/scale), CV_8UC1);
//    cv::resize(gray_mat, smallImg, smallImg.size(), 0, 0, cv::INTER_LINEAR);
//    cv::equalizeHist(smallImg, smallImg);
    
    // Face detection (image, output rectangle, scale for size reduction, minimum number of rectungle, flag, mimimum size of rectungle)
    std::vector<cv::Rect> faces; // Rect is defined by position of rectungle and length of row and column
//    face_cascade.detectMultiScale(smallImg,
    face_cascade.detectMultiScale(mat,
                                  faces,
                                  1.1, 2,
                                  CV_HAAR_SCALE_IMAGE,
                                  cv::Size(80, 80)); // ここは最終的にスマホの設置位置を決めたうえで調整が必要
//    cv::Size(60, 60)); // ここは最終的にスマホの設置位置を決めたうえで調整が必要
    //                                cv::Size(30, 30));
    std::cout << "number of faces: " << faces.size() << std::endl;
    
    std::vector<cv::Rect>::iterator r = faces.begin();
//    std::vector<cv::Rect>::const_iterator r = faces.begin();
    for(; r != faces.end(); ++r) {
        // for debugging
        /*
        cv::Point face_center;
        int face_radius;
        face_center.x = cv::saturate_cast<int>((r->x + r->width*0.5));
        face_center.y = cv::saturate_cast<int>((r->y + r->height*0.5));
        face_radius = cv::saturate_cast<int>((r->width + r->height) / 2);
//        cv::circle(mat, face_center, face_radius, cv::Scalar(80,80,255), 3, 8, 0 );
        cv::circle(smallImg, face_center, face_radius, cv::Scalar(80,80,255), 3, 8, 0 );
        std::cout << "faces rect: " << *r << std::endl;
        */
        // Insert value to structure
        facialFeatures.face.featureRect.origin.x = r->x;
        facialFeatures.face.featureRect.origin.y = r->y;
        facialFeatures.face.featureRect.size.width = r->width;
        facialFeatures.face.featureRect.size.height = r->height;
        facialFeatures.face.isDetected = true;
        
        // Cut a lower half part in face
        r->y = r->y + r->height * 0.2; // 上から20％のところには目は無いとしてカット
        r->height = r->height * 0.3; // これでノイズが取れなければ、目の数でスクリーニングする予定.数値は別に宣言すべきか。
    // In each face, detect eyes
        cv::Mat faceROI = mat(*r);
        
         // When changing the factor, you need to change const_iterator to interator
        std::vector<cv::Rect> eyes;
        eyes_cascade.detectMultiScale(faceROI, eyes,
                                      1.1, 3,
                                      CV_HAAR_SCALE_IMAGE,
//                                      cv::Size(30,30));
//                                      cv::Size(10,10));
                                      cv::Size(5,5));
        
        std::cout << "number of eyes: " << eyes.size() << std::endl;
        std::cout << "eyes are closed?: " << eyes.empty() << std::endl; // Detect eyes are open or not
        
        // draw eyes' positions
        std::vector<cv::Rect>::const_iterator nr = eyes.begin(); // n means nested
        int counterForEye = 0; // to store eyes value to both eye1Status and eye2Status
        for(; nr != eyes.end(); ++nr) {
            // for debugging
            /*
            cv::Point eyes_center;
            int eyes_radius;
            eyes_center.x = cv::saturate_cast<int>((r->x + nr->x + nr->width*0.5));
            eyes_center.y = cv::saturate_cast<int>((r->y + nr->y + nr->height*0.5));
            eyes_radius = cv::saturate_cast<int>((nr->width + nr->height) / 2);
            cv::circle(smallImg, eyes_center, eyes_radius, cv::Scalar(80,255,80), 3, 8, 0 ); // last three parameters are Tichness, Linetype and NoShift (each shift value devides the rectangle size and location by 2)
//            cv::circle(mat, eyes_center, eyes_radius, cv::Scalar(80,255,80), 3, 8, 0 ); // last three parameters are Tichness, Linetype and NoShift (each shift value devides the rectangle size and location by 2)
             */
            std::cout << "eyes rect: " << *nr << std::endl;
            
            // Insert value to structure
            if (counterForEye == 0) {
                facialFeatures.eye1.featureRect.origin.x = r->x + nr->x;;
                facialFeatures.eye1.featureRect.origin.y = r->y + nr->y;
                facialFeatures.eye1.featureRect.size.width = nr->width;
                facialFeatures.eye1.featureRect.size.height = nr->height;
                facialFeatures.eye1.isDetected = true;
                
                counterForEye += 1;
                
            } else {
                facialFeatures.eye2.featureRect.origin.x = r->x + nr->x;;
                facialFeatures.eye2.featureRect.origin.y = r->y + nr->y;
                facialFeatures.eye2.featureRect.size.width = nr->width;
                facialFeatures.eye2.featureRect.size.height = nr->height;
                facialFeatures.eye2.isDetected = true;
            }
        
         }
    }
    
    // Transfer cv::Mat -> UIImage
//    UIImage *resultImage = MatToUIImage(smallImg); for debugging
//    return resultImage; // for debugging
    return facialFeatures;
}

@end