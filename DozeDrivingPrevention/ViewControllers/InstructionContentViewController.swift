//
//  InstructionContentViewController.swift
//  DozeDrivingPrevention
//
//  Created by 小林和宏 on 1/8/16.
//  Copyright © 2016 mycompany. All rights reserved.
//

import UIKit

class InstructionContentViewController: UIViewController {
    
    @IBOutlet weak var contentImage: UIImageView!
    var imageFileName: String!
    var pageIndex: Int!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        contentImage.image = UIImage(named: imageFileName)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }    
}
