//
//  detailsViewController.swift
//  MEME
//
//  Created by Benjamin Kampf on 9/20/16.
//  Copyright © 2016 Me. All rights reserved.
//

import UIKit

class detailsViewController: UIViewController {
    var meme: MemeStruct!
    @IBOutlet weak var im: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        im.image = meme.memeImage
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

}
