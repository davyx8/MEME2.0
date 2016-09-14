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
        self.we.autocapitalizationType = .AllCharacters
        self.down.autocapitalizationType = .AllCharacters
      //  bgImage.clipsToBounds = true
        cam.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        share.enabled = false
      
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
          self.subscribeToKeyboardNotifications()
    }
    override func didReceiveMemoryWarning() {	
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func KeyboardWillHide(notification:NSNotification){
        if (down.isFirstResponder()){
            
            self.view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    
    func KeyboardWillShow(notification: NSNotification) {
        print("keyboard shown ")
        
        if (down.isFirstResponder()){
        self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
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
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.KeyboardWillShow(_:)) , name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.KeyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillHideNotification, object: nil)
    }

    @IBAction func galleryPic(sender: AnyObject) {
        pick(true)

    }
    
    func pick(type: Bool){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        if(type){
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        }
        else {
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        }
        presentViewController(imagePicker, animated: true, completion: nil)
        arrangeViews()
        enableButtons(true)
    }
    
    @IBAction func camPciker(sender: AnyObject) {
     pick(false)
    }
    func enableButtons(cond: Bool){
        
        we.enabled = cond
        down.enabled = cond
        share.enabled = cond
    }
    
    func toolbarsSet(cond:  Bool){
        self.tool.hidden = cond
        self.topBar.hidden = cond
    }
    func generateMemedImage() -> UIImage {
        
        // TODO: Hide toolbar and navbar
        toolbarsSet(true)
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawViewHierarchyInRect(self.view.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // TODO:  Show toolbar and navbar
        toolbarsSet(false)
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
    func arrangeViews(){
        we.textAlignment = NSTextAlignment.Center;
        down.textAlignment = NSTextAlignment.Center;
        self.view.bringSubviewToFront(tool)
        self.view.bringSubviewToFront(we)
        self.view.bringSubviewToFront(down)
        self.view.sendSubviewToBack(bgImage)
    }
  let memeTextAttributes = [
    NSForegroundColorAttributeName : UIColor.whiteColor(),
    NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 20)!,
    NSStrokeColorAttributeName : UIColor.blackColor(),
    NSStrokeWidthAttributeName : -2
    ]
    func stylizeTextField(textField: UITextField) {
        textField.defaultTextAttributes = memeTextAttributes
        textField.delegate = self
        
    }
    func buttonInit(){
        stylizeTextField(we)
        stylizeTextField(down)
        we.text = "TOP"
        down.text = "DOWN"
        arrangeViews()
        enableButtons(false)
        }
    func save(im: UIImage) {
        //Create the meme
    let meme = MemeStruct(top: we.text!,bottom:down.text!, Image:bgImage.image!, memeImage: im)
        (UIApplication.sharedApplication().delegate as! AppDelegate).memes.append(meme)
    }

}

