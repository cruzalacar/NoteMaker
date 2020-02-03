//
//  CreateNoteViewController.swift
//  NoteMaker
//
//  Created by Murtaza on 2019-12-07.
//  Copyright © 2019 Murtaza. All rights reserved.
//

import UIKit

///Murtaza Completed Create Note
class CreateNoteViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate{

    
    let mainDelegate = UIApplication.shared.delegate as! AppDelegate
    
    ///Text Field for title and note
    @IBOutlet var txtTitle : UITextField!
    @IBOutlet var txtNote : UITextView!
    @IBOutlet weak var imageView : UIImageView!
    var imagePicker: UIImagePickerController!
    static var nTitle: String?
    static var note : String?
    static var date :String?
    static var selectImage :UIImage?
    ///Outlet for DatePicker
    @IBOutlet var datePicker : UIDatePicker!
    @IBOutlet var activityIndicator : UIActivityIndicatorView!
    
    
    //function removes keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
         return textField.resignFirstResponder()
     }
    //function of type imagepickercontroller, used to display camera image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        imagePicker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[.originalImage] as? UIImage else {
            print("Image not found!")
            return
        }
        imageView.image = selectedImage
        CreateNoteViewController.selectImage = selectedImage
    }
    
    ///These three functions are used to declare the activity progress by creating an indicator and alert box method.
    ///THese are functions needed prior to buttons being clicked
    func showActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
          activityIndicator.backgroundColor = UIColor(red:0.16, green:0.17, blue:0.21, alpha:1)
          activityIndicator.layer.cornerRadius = 6
          activityIndicator.center = view.center
          activityIndicator.hidesWhenStopped = true
          activityIndicator.style = .large
          activityIndicator.startAnimating()
          //UIApplication.shared.beginIgnoringInteractionEvents()
          
          activityIndicator.tag = 100 // 100 for example
          
          // before adding it, you need to check if it is already has been added:
          for subview in view.subviews {
              if subview.tag == 100 {
                  print("already added")
                  return
              }
          }
          
          view.addSubview(activityIndicator)
      }
    func hideActivityIndicator() {
          let activityIndicator = view.viewWithTag(100) as? UIActivityIndicatorView
          activityIndicator?.stopAnimating()
          activityIndicator?.removeFromSuperview()
      }
    func myAlert(title:String, msg:String) {
           let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
           let okayAction = UIAlertAction(title: "Close", style: .default, handler: nil)
           alertController.addAction(okayAction)
           present(alertController, animated: true, completion: nil)
       }

    
    
    ///save the text fields functions to avoid SIGN error
    @IBAction func save(sender: UIButton){
        //Getting text from textFiled!
        if txtNote.text=="" || txtTitle.text==""{
                hideActivityIndicator()
                myAlert(title: "Error", msg: "Make sure you enter all the required information!")
            }
        else{
            CreateNoteViewController.nTitle = txtTitle.text
            CreateNoteViewController.note = txtNote.text
            myAlert(title: "Saved", msg: "\(String(describing: CreateNoteViewController.nTitle))")
            
        }
    }
    ///Take photo
    @IBAction func takePhoto(sender : UIButton){
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    ///Function for onclick create button
    @IBAction func createNote(sender : UIButton){
        ///submit to json parser here
        CreateNoteViewController.date = datePicker.date.description
        uploadDataToJSON()
       
    }
    
    
    ///This function retirence the opload url from the php script and updates the values into the sql table
    func uploadDataToJSON(){
         showActivityIndicator()
            
            //Post URL
        let url = URL(string:"http://salemuha.dev.fast.sheridanc.on.ca/project/upload.php")
        var request = URLRequest(url:url!)
            request.httpMethod = "POST"
            
            //Checking image place holder
            let image = CreateNoteViewController.selectImage
        if image == nil {
            myAlert(title: "No Image", msg: "swipe to camera")
            return
        }
        else{
        let imageData = image!.jpegData(compressionQuality: 1)!
        let title = CreateNoteViewController.nTitle!
        let note = CreateNoteViewController.note!
        let date = CreateNoteViewController.date!
        let logo = imageData.base64EncodedString()
            var dataString = "&title=\(title)" // add items as name and value
            dataString = dataString + "&note=\(note)"
            dataString = dataString + "&date=\(date)"
            dataString = dataString + "&logo=\(logo)"
            
        let dataD = dataString.data(using: .utf8)
        
            do {
                let session = URLSession.shared.uploadTask(with: request, from: dataD){
                    data, response, error in
                    if error != nil {
                        //display error in dispatch async
                        DispatchQueue.main.async {
                            self.myAlert(title: "Upload went bad", msg: "hmmm")
                        }
                    }else{
                        if let unwrappedData = data {
                            let returnedData = NSString(data: unwrappedData, encoding: String.Encoding.utf8.rawValue) // Response from web server hosting the database
                                                    
                            if returnedData == "1" // insert into database worked
                                                    {

                            // display an alert if no error and database insert worked (return = 1) inside the DispatchQueue.main.async
                                DispatchQueue.main.async
                                                        {
                                                      self.myAlert(title: "Upload did work", msg: "Xongrats")
                                                        }
                                                    }
                                                    else
                                                    {
                            // display an alert if an error and database insert didn't worked (return != 1) inside the DispatchQueue.main.async
                                DispatchQueue.main.async
                                                        {
                                             self.myAlert(title: "Upload didnt work", msg: "Fix the php file")
                                                            self.hideActivityIndicator()
                                                        }
                                                        
                            }

                        }
                    }
                }
                session.resume()
                ///change to home page
                performSegue(withIdentifier: "homeView", sender: mainDelegate.self)
            }
        }
    }
       
   override func viewDidLoad() {
           super.viewDidLoad()
           
           // Do any additional setup after loading the view.
       }
}
