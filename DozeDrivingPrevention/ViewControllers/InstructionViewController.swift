//
//  InstructionViewController.swift
//  DozeDrivingPrevention
//
//  Created by 小林和宏 on 12/1/15.
//  Copyright © 2015 mycompany. All rights reserved.
//

import UIKit

class InstructionViewController: UIViewController, UIPageViewControllerDataSource {
    
    // add for page view controller
    var pageImages: NSArray!
    var pageViewController: UIPageViewController!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // add for page view controller (images' names)
        pageImages = NSArray(objects: "1. Set", "2. Awake", "3. Drowsy", "4. Sign")
        
        self.pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("InstructionPageViewController") as! UIPageViewController
        
        self.pageViewController.dataSource = self
        var initialContentViewController = self.pageInstructionAtIndex(0) as InstructionContentViewController
        var viewControllers = NSArray(object: initialContentViewController)
        
        self.pageViewController.setViewControllers(viewControllers as! [UIViewController], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
//        self.pageViewController.setViewControllers(viewControllers as [AnyObject], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil) //AnyObjectの部分でエラー
        
        self.pageViewController.view.frame = CGRectMake(0, 100, self.view.frame.size.width , self.view.frame.size.height - 100)
        self.addChildViewController(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
        self.pageViewController.didMoveToParentViewController(self)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // add for page view controller
    func pageInstructionAtIndex(index: Int) -> InstructionContentViewController {
        var pageContentViewController = self.storyboard?.instantiateViewControllerWithIdentifier("InstructionContentViewController") as! InstructionContentViewController
        pageContentViewController.imageFileName = pageImages[index] as! String
        pageContentViewController.pageIndex = index
        
        return pageContentViewController
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        var viewController = viewController as! InstructionContentViewController
        var index = viewController.pageIndex as Int
        
        if (index == 0  || index == NSNotFound) {
            return nil
        }
        index--
        
        return self.pageInstructionAtIndex(index)
    }

    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        var viewController = viewController as! InstructionContentViewController
        var index = viewController.pageIndex as Int
        
        if ((index == NSNotFound)) {
            return nil
        }
        index++
        
        if (index == pageImages.count) {
            return nil
        }
        
        return self.pageInstructionAtIndex(index)
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return pageImages.count
    }

    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
}
