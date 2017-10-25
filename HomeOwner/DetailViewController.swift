import UIKit

extension UITextField
{
    @discardableResult open override func becomeFirstResponder() -> Bool
    {
        super.becomeFirstResponder()
        borderStyle = .bezel
        return true;
    }
    @discardableResult open override func resignFirstResponder() -> Bool
    {
        super.resignFirstResponder()
        borderStyle = .roundedRect
        return true;
    }
}

class DetailViewController : UIViewController
{
    
    @IBOutlet weak var serialEdit: UITextField!
    @IBOutlet weak var nameEdit: UITextField!
    @IBOutlet weak var valueEdit: UITextField!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var itemImageView: UIImageView!
    
    var imagePicker = UIImagePickerController()

    
    @IBAction func deletePhoto(_ sender: UIBarButtonItem)
    {
     
     guard let _ = itemImageView.image else {return}
        
     let imageDelAC = UIAlertController(title: "Deleteting Image",
                                    message: "Are you sure you want to purge the photo for \(editedItem.name)",
                                    preferredStyle: .alert)
     
     let delAction = UIAlertAction(title: "DELETE", style: .destructive)
     {
        _ in
        self.itemImageView.image = nil
        self.images.deleteImage(forKey: self.editedItem.imageKey)
     }
     
     let cnxAction = UIAlertAction(title: "CANCEL", style: .cancel, handler: nil)
        
     imageDelAC.addAction(delAction)
     imageDelAC.addAction(cnxAction)
     imageDelAC.preferredAction = cnxAction
        
     self.present(imageDelAC, animated: true, completion: nil)
     
    }
    
    @IBAction func takePhoto(_ sender: UIBarButtonItem)
    {
      if UIImagePickerController.isSourceTypeAvailable(.camera)
      {
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .camera
      }
      else
      {
        print ("Camera is not available!")
        imagePicker.sourceType = .photoLibrary
      }
      
     
     present(imagePicker, animated: true, completion: nil)
    }
    
    var editedItem: Item!
    {
        didSet
        {
         navigationItem.title = editedItem.name
        }
    }
    
    var images: imagesCache!
    
    static let dateFormat =
    { () -> DateFormatter in
     let df = DateFormatter()
     df.timeStyle = .none
     df.dateFormat = "EEEE, MMMM, dd-yyyy"
     return df
    }()
    
    static let valueFormat =
    { () -> NumberFormatter in
     let nf = NumberFormatter()
     nf.numberStyle = .decimal
     nf.minimumFractionDigits = 2
     nf.maximumFractionDigits = 2
     
     return nf
    }()
    
    @IBAction func backgroundTouched(_ sender: UITapGestureRecognizer)
    {
        view.endEditing(true)
    }
    @IBAction func long_press(_ sender: UILongPressGestureRecognizer)
    {
        view.endEditing(true)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        imagePicker.delegate = self
    }
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
    
        nameEdit.text = editedItem.name.trimmingCharacters(in: CharacterSet(charactersIn: " "))
        serialEdit.text = editedItem.serial?.trimmingCharacters(in: CharacterSet(charactersIn: " "))
        valueEdit.text = String(editedItem.value)
        dateLabel.text = DetailViewController.dateFormat.string(from: editedItem.date)
        
        itemImageView.image = images.getImage(forKey: editedItem.imageKey)
        
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        
        if let name_txt = nameEdit.text, !name_txt.isEmpty
        {
         editedItem.name = name_txt
        }
        else
        {
            if editedItem.name.isEmpty  {editedItem.name = " "}
        }
        if let serial_txt = serialEdit.text, !serial_txt.isEmpty
        {
         editedItem.serial = serial_txt
        }
        else
        {
            if (editedItem.serial?.isEmpty)! {editedItem.serial = " "}
        }
        if let val_txt = valueEdit.text, let val = DetailViewController.valueFormat.number(from: val_txt)
        {
         editedItem.value = val.doubleValue
        }
        view.endEditing(true)
    }
}
extension DetailViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        let image_type = UIImagePickerController.isSourceTypeAvailable(.camera) ? UIImagePickerControllerEditedImage : UIImagePickerControllerOriginalImage
        
        guard let pickedImage = info[image_type] as? UIImage
        else
        {
            print("Image not found!!!")
            dismiss(animated: true, completion: nil)
            return
        }
        
        itemImageView.image = pickedImage
        images.setImage(pickedImage, forKey: editedItem.imageKey)
        dismiss(animated: true, completion: nil)
    }
}
extension DetailViewController : UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let segID = segue.identifier, segID == "editDate"
        {
            (segue.destination as! DateViewController).editedItem = editedItem
            
        }
    }
    
   /* func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        textField.borderStyle = .bezel
        textField.textColor = UIColor.red
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool
    {
        textField.borderStyle = .roundedRect
        textField.textColor = UIColor.black
        return true
    }*/
}


