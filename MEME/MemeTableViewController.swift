//
//  MemeTableViewController.swift
//  MEME
//
//  Created by Benjamin Kampf on 9/15/16.
//  Copyright © 2016 Me. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController {
    
    var memes:[MemeStruct] = []
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        memes = delegate.memes
        
        print("count : ")
        print(memes.count)
        for x in memes {
        print(x.top)
        }
        self.tableView.reloadData()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source


    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
      return memes.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        print("fucker")
        let cell = tableView.dequeueReusableCellWithIdentifier("cellMEME", forIndexPath : indexPath) as! MemeTableViewCell
        
        let meme = memes[indexPath.row]
        print(indexPath.row)
        print(meme.top)
        cell.top.text = meme.top+" ... "+meme.bottom
        cell.im.image = meme.memeImage
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let detailController = storyboard!.instantiateViewControllerWithIdentifier("detailsView") as! detailsViewController
        detailController.meme = memes[indexPath.row]
        
        navigationController!.pushViewController(detailController, animated: true)
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

   
    // MARK: - Navigation
    
     @IBAction func addMeme(sender: AnyObject) {
     
     let editorController = storyboard!.instantiateViewControllerWithIdentifier("memeCreator") 
     presentViewController(editorController, animated: true, completion: nil)
      /*
     
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    }
}
