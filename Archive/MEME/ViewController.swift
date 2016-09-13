//
//  ViewController.swift
//  MEME
//
//  Created by Me on 8/28/16.
//  Copyright © 2016 Me. All rights reserved.
//

import UIKit

class ViewController: UIViewController ,UIImagePickerControllerDelegate,UITextFieldDelegate,
UINavigationControllerDelegate {
@IBOutlet weak var bgImage: UIImageView!
@IBOutlet weak var we: UITextField!

@IBOutlet weak var share: UIBarButtonItem!
@IBOutlet weak var topBar: UIToolbar!
@IBOutlet weak var tool: UIToolbar!
@IBOutlet weak var cam: UIBarButtonItem!
@IBOutlet weak var down: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("sss")
        buttonInit()
      //  bgImage.clipsToBounds = true
        cam.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        share.enabled = false
        self.subscribeToKeyboardNotifications()
    }

    override func didReceiveMemoryWarning() {	
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func keyboardWillHide(notification:NSNotification){

            view.frame.origin.y += getKeyboardHeight(notification)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        self.view.frame.origin.y -= getKeyboardHeight(notification)
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeFromKeyboardNotifications()
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo!
        let keyboardSize = userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedIm = info[UIImagePickerControllerOriginalImage] as? UIImage{
            print("image")
            bgImage.contentMode = .ScaleAspectFit
        bgImage.image = pickedIm
        }
        print("then")
        
         dismissViewControllerAnimated(true, completion: nil)
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
         dismissViewControllerAnimated(true, completion: nil)
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
    }

    @IBAction func galleryPic(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        presentViewController(imagePicker, animated: true, completion: nil)
        

        self.view.bringSubviewToFront(we)
        self.view.bringSubviewToFront(down)
        self.view.sendSubviewToBack(bgImage)
        share.enabled = true
        we.enabled = true
        down.enabled = true
        we.textAlignment = NSTextAlignment.Center;
        down.textAlignment = NSTextAlignment.Center;
    }

    @IBAction func camPciker(sender: AnyObject) {
   
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        presentViewController(imagePicker, animated: true, completion: nil)
        
        we.enabled = true
        down.enabled = true
        share.enabled = true
    }
    
    func generateMemedImage() -> UIImage {
        
        // TODO: Hide toolbar and navbar
        self.tool.hidden = true
        self.topBar.hidden = true
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawViewHierarchyInRect(self.view.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // TODO:  Show toolbar and navbar
        self.tool.hidden = false
        self.topBar.hidden = false
        return memedImage
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    @IBAction func resetUI(sender: AnyObject) {
   
        buttonInit()


        bgImage.image = nil
        //shareButton.enabled = false
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func share(sender: AnyObject) {
        let im = generateMemedImage()

        let nextController = UIActivityViewController(activityItems: [im], applicationActivities: nil)
        nextController.completionWithItemsHandler = { activity, success, items, error in
            
            if(success) {
                self.save(im)
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        
        presentViewController(nextController, animated: true, completion: nil)
    }
    func buttonInit(){
        we.delegate = self
        we.defaultTextAttributes = [
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 20)!,
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSStrokeWidthAttributeName : -2
        ]
        down.delegate = self
        we.textAlignment = NSTextAlignment.Center;
        down.textAlignment = NSTextAlignment.Center;
        down.defaultTextAttributes = [
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 20)!,
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSStrokeWidthAttributeName : -2
        ]
        we.text = "TOP"
        down.text = "DOWN"
        
        we.textAlignment = NSTextAlignment.Center;
        down.textAlignment = NSTextAlignment.Center;
        
        self.view.bringSubviewToFront(tool)
        self.view.bringSubviewToFront(we)
        self.view.bringSubviewToFront(down)
        self.view.sendSubviewToBack(bgImage)
        we.enabled = false
        down.enabled = false
        share.enabled = false
        }
    func save(im: UIImage) {
        //Create the meme
        _ = MemeStruct(top: we.text!,bottom:down.text!, Image:bgImage.image!, memeImage: im)
    }

}

