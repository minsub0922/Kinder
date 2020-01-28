//
//  SettingsController.swift
//  KElonTinder
//
//  Created by 최민섭 on 2020/01/08.
//  Copyright © 2020 최민섭. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD
import SDWebImage

protocol SettingsControllerDelegate {
    func didSaveSettings()
}

class CustomImagePickerController: UIImagePickerController {
    var imageButton: UIButton?
}

class SettingsController: UITableViewController {
    
    var delegate: SettingsControllerDelegate?
     
    // instance properties
    lazy var image1Button = createButton(selector: #selector(handleSelectPhoto))
    lazy var image2Button = createButton(selector: #selector(handleSelectPhoto))
    lazy var image3Button = createButton(selector: #selector(handleSelectPhoto))
    
    func createButton(selector: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("Select Photo", for: .normal)
        button.backgroundColor = .white
        button.addTarget(self, action: selector, for: .touchUpInside)
        button.imageView?.contentMode = .scaleAspectFill
        button.imageView?.layer.cornerRadius = 8
        button.clipsToBounds = true
        return button
    }
    
    @objc fileprivate func handleSelectPhoto(button: UIButton) {
        let imagePicker = CustomImagePickerController()
        imagePicker.delegate = self
        imagePicker.imageButton = button
        present(imagePicker, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationItems()
        tableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        tableView.tableFooterView = UIView()
        tableView.keyboardDismissMode = .interactive
        
        fetchCurrentUser()
    }
    
    deinit {
        print("\(self.className) is destroying itsel properly, no retain cycles or any other memory related issues. Meemory being reclaimed properly")
    }
    
    var user: User?
    
    fileprivate func fetchCurrentUser() {
        Firestore.firestore().fetchCurrentUser { (user, err) in
            if let err = err {
                print("Failed to fetch user:", err)
                return
            }
            
            self.user = user
            self.loadUserPhotos()
            self.tableView.reloadData()
        }
    }
    
    fileprivate func loadUserPhotos() {
        if  let imageUrl = self.user?.imageUrl1, let url = URL(string: imageUrl) {
            SDWebImageManager.shared.loadImage(with: url,
                                                 options: .continueInBackground,
                                                 progress: nil) { (image, _, _, _, _, _) in
                                                    self.image1Button.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
            }
        }
        if  let imageUrl = self.user?.imageUrl2, let url = URL(string: imageUrl) {
            SDWebImageManager.shared.loadImage(with: url,
                                                 options: .continueInBackground,
                                                 progress: nil) { (image, _, _, _, _, _) in
                                                    self.image2Button.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
            }
        }
        if  let imageUrl = self.user?.imageUrl3, let url = URL(string: imageUrl) {
            SDWebImageManager.shared.loadImage(with: url,
                                                 options: .continueInBackground,
                                                 progress: nil) { (image, _, _, _, _, _) in
                                                    self.image3Button.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
            }
        }
        
       
        
    }
    
    lazy var header: UIView = {
       let header = UIView()
        header.addSubview(image1Button)
        let padding: CGFloat = 16
        image1Button.anchor(top: header.topAnchor,
                            leading: header.leadingAnchor,
                            bottom: header.bottomAnchor,
                            trailing: header.trailingAnchor,
                            padding: .init(top: padding, left: padding, bottom: padding, right: 0))
        image1Button.widthAnchor.constraint(equalTo: header.widthAnchor, multiplier: 0.45).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [image2Button, image3Button])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = padding
        
        header.addSubview(stackView)
        stackView.anchor(top: header.topAnchor,
                         leading: image1Button.trailingAnchor,
                         bottom: header.bottomAnchor,
                         trailing: header.trailingAnchor,
                         padding: .init(top: padding, left: padding, bottom: padding, right: padding))
        return header
    }()
    
    class HeaderLabel: UILabel {
        override func drawText(in rect: CGRect) {
            super.drawText(in: rect.insetBy(dx: 16, dy: 0))
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return header
        }
        
        let headerLabel = HeaderLabel()
        switch section {
        case 1:
            headerLabel.text = "Name"
        case 2:
            headerLabel.text = "Profession"
        case 3:
            headerLabel.text = "Age"
        case 4:
            headerLabel.text = "Bio"
        default:
            headerLabel.text = "Seeking Age Range"
        }
        
        headerLabel.font = UIFont.boldSystemFont(ofSize: 16)
        return headerLabel
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 300
        }
        return 50
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
   
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 0 : 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // age range cell
        if indexPath.section == 5 {
            let ageRangeCell = AgeRangeCell(style: .default, reuseIdentifier: nil)
            ageRangeCell.minSlider.addTarget(self, action: #selector(handleMinAgeChange), for: .valueChanged)
            ageRangeCell.maxSlider.addTarget(self, action: #selector(handleMaxAgeChange), for: .valueChanged)
            ageRangeCell.minSlider.value = Float(user?.minSeekingAge ?? 0)
            ageRangeCell.maxSlider.value = Float(user?.maxSeekingAge ?? 0)
            ageRangeCell.minLabel.text = "Min \(user?.minSeekingAge ?? 0)"
            ageRangeCell.maxLabel.text = "Max \(user?.maxSeekingAge ?? 0)"
            return ageRangeCell
        }
        
        let cell = SettingsCell(style: .default, reuseIdentifier: nil)
        
        switch indexPath.section {
        case 1:
            cell.textField.placeholder = "Enter Name"
            cell.textField.text = user?.name
            cell.textField.addTarget(self, action: #selector(handleNameChange), for: .editingChanged)
        case 2:
            cell.textField.placeholder = "Enter Profession"
            cell.textField.text = user?.profession
            cell.textField.addTarget(self, action: #selector(handleProfessuibChange), for: .editingChanged)
        case 3:
            cell.textField.placeholder = "Enter Age"
            if let age = user?.age {
                cell.textField.text = String(age)
            }
            cell.textField.addTarget(self, action: #selector(handleAgeChange), for: .editingChanged)
        default:
            cell.textField.placeholder = "Enter Bio"
        }
         
        return cell
    }
    
    // MARK:- Actions
    @objc fileprivate func handleMinAgeChange(slider: UISlider) {
        // want to update the minLabel in AgeRaneCell somehow...
        let ageRangeCell = tableView.cellForRow(at: IndexPath(row: 0, section: 5)) as! AgeRangeCell
        ageRangeCell.minLabel.text = "Min \(Int(slider.value))"
        
        self.user?.minSeekingAge = Int(slider.value)
    }
    
    @objc fileprivate func handleMaxAgeChange(slider: UISlider) {
        // want to update the maxLabel in AgeRaneCell somehow...
        let ageRangeCell = tableView.cellForRow(at: IndexPath(row: 0, section: 5)) as! AgeRangeCell
        ageRangeCell.maxLabel.text = "Max \(Int(slider.value))"
        
        self.user?.maxSeekingAge = Int(slider.value)
    }
    @objc fileprivate func handleNameChange(textField: UITextField) {
        self.user?.name = textField.text
    }
    @objc fileprivate func handleProfessuibChange(textField: UITextField) {
        self.user?.profession = textField.text
    }
    @objc fileprivate func handleAgeChange(textField: UITextField) {
        self.user?.age = Int(textField.text ?? "")
    }
    
    fileprivate func setupNavigationItems() {
        navigationItem.title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancle",
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(handleCancel))
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: "Save",
                            style: .plain,
                            target: self,
                            action: #selector(handleSave)),
            UIBarButtonItem(title: "Logout",
                            style: .plain,
                            target: self,
                            action: #selector(handleLogout))
        ]
    }
    
    @objc fileprivate func handleCancel() {
        dismiss(animated: true)
    }
    @objc fileprivate func handleSave() {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Saving settings"
        hud.show(in: view)
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let documentData: [String: Any] = [
            "uid": uid,
            "fullName": user?.name ?? "",
            "imageUrl1": user?.imageUrl1 ?? "",
            "imageUrl2": user?.imageUrl2 ?? "",
            "imageUrl3": user?.imageUrl3 ?? "",
            "age": user?.age ?? -1,
            "profession": user?.profession ?? "",
            "minSeekingAge": user?.minSeekingAge ?? -1,
            "maxSeekingAge": user?.maxSeekingAge ?? -1,
        ]
                
        Firestore.firestore().collection("users").document(uid).setData(documentData) { (err) in
            hud.dismiss()
            self.view.endEditing(true)
            
            if let err = err {
                print(err)
                return
            }
            
            print("Finished saving user info")
            self.dismiss(animated: true) {
                print("Dismissal complete")
                
                self.delegate?.didSaveSettings()
            }
        }
    }
    
    @objc fileprivate func handleLogout() {
        try? Auth.auth().signOut()
        dismiss(animated: true)
    }
}

extension SettingsController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedImage = info[.originalImage] as? UIImage
        let imageButton = (picker as? CustomImagePickerController)?.imageButton
        imageButton?.setImage(selectedImage?.withRenderingMode(.alwaysOriginal), for: .normal)
        dismiss(animated: true)
        
        let filename = UUID().uuidString
        let ref = Storage.storage().reference(withPath: "/images/\(filename)")
        
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Uploading image..."
        hud.show(in: view)
        
        guard let uploadData = selectedImage?.jpegData(compressionQuality: 0.75) else { return }
        ref.putData(uploadData,
                    metadata: nil) { (nil, err) in
                        if let err = err {
                            print("Failed to upload image to storage", err)
                            return
                        }
                        
                        print("Finished uploading image")
                        ref.downloadURL { (url, err) in
                            hud.dismiss()
                            if let err = err {
                                print("Failed to retrieve download URL:", err)
                                return
                            }
                            
                            if imageButton == self.image1Button {
                                self.user?.imageUrl1 = url?.absoluteString
                            } else if imageButton == self.image2Button {
                                self.user?.imageUrl2 = url?.absoluteString
                            } else {
                                self.user?.imageUrl3 = url?.absoluteString
                            }
                            
                            print("Finished getting dowload url:", url?.absoluteString ?? "")
                        }
        }
    }
}
