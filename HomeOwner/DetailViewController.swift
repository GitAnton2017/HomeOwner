import UIKit

class DetailViewController : UIViewController
{
    
    @IBOutlet weak var serialEdit: UITextField!
    @IBOutlet weak var nameEdit: UITextField!
    @IBOutlet weak var valueEdit: UITextField!
    @IBOutlet weak var dateLabel: UILabel!
    
    var editedItem: Item!
    
    let dateFormat =
    { () -> DateFormatter in
     let df = DateFormatter()
     df.timeStyle = .none
     df.dateFormat = "EEEE, MMMM, dd-yyyy"
     return df
    }()
    
    let valueFormat =
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
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
    
        nameEdit.text = editedItem.name
        serialEdit.text = editedItem.serial
        valueEdit.text = String(editedItem.value)
        dateLabel.text = dateFormat.string(from: editedItem.date)
        
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        
        if let name_txt = nameEdit.text, name_txt != ""
        {
         editedItem.name = name_txt
        }
        if let serial_txt = serialEdit.text, serial_txt != ""
        {
         editedItem.serial = serial_txt
        }
        if let val_txt = valueEdit.text, let val = valueFormat.number(from: val_txt)
        {
         editedItem.value = val.doubleValue
        }
        view.endEditing(true)
    }
}

extension DetailViewController : UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
}


