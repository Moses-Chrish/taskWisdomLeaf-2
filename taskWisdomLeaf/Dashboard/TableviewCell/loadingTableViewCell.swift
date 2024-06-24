//
//  loadingTableViewCell.swift
//  taskWisdomLeaf
//
//  Created by ilamparithi mayan on 23/06/24.
//

import UIKit
import SDWebImage


class loadingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var viewUI: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var checkBoxButton: UIButton!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var picImage: UIImageView!
    
    var chkBoxTapped: (() -> Void)?

    var check = false

    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewUI.layer.masksToBounds = true
        viewUI.clipsToBounds = true
        viewUI.layer.cornerRadius = 5
        
        checkBoxButton.setImage(UIImage(named: "Uncheckbox"), for: .normal)
        checkBoxButton.setImage(UIImage(named: "CheckBox"), for: .selected)
        
    }
    
    
    func config(photo: PictureDetails, completion: @escaping() -> Void) {
        chkBoxTapped = completion
        self.picImage.image = nil
        let slno = Int(photo.id ?? "1") ?? 1
        
        // Set the title label with the photo's serial number and author.
        titleLbl.text = "\(slno+1) " + "\(photo.author ?? "None")"
        
        descriptionLbl.text = "Wisdomleaf has been developing iOS Apps since the last three years and its dedicated team can help businesses develop their dream projects effortlessly."
        descriptionLbl.numberOfLines = 0
        descriptionLbl.lineBreakMode = .byWordWrapping
        
       

        
        // Set the photo image if image data is available.
        if let imageURL = photo.download_url {
            picImage.sd_setImage(with: URL(string: imageURL), placeholderImage: UIImage(named: "wisdom"))
        }
    }

    @IBAction func checkBoxTapped(_ sender: Any) {
        checkBoxButton.isSelected.toggle()
        chkBoxTapped?()

    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
