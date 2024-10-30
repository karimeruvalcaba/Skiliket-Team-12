import UIKit

class NewPostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var projectTitleText: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var categoriesPickerView: UIPickerView!
    @IBOutlet weak var selectProjectButton: UIButton!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var uploadButton: UIButton!
    
    var selectedProject: Project?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureProjectTitleText()
        configureDescriptionText()
        configureCategoriesPickerView()

        cameraButton.setImage(UIImage(systemName: "camera.fill"), for: .normal)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            self.view.frame.origin.y = -keyboardHeight / 2
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func configureProjectTitleText() {
        projectTitleText.text = ""
        projectTitleText.isEditable = false
        projectTitleText.isScrollEnabled = false
        projectTitleText.textContainerInset = .zero
        projectTitleText.textContainer.lineFragmentPadding = 0
    }
    
    private func configureDescriptionText() {
        descriptionText.layer.borderColor = UIColor.lightGray.cgColor
        descriptionText.layer.borderWidth = 1.0
        descriptionText.layer.cornerRadius = 5.0
    }
    
    private func configureCategoriesPickerView() {
        categoriesPickerView.delegate = self
        categoriesPickerView.dataSource = self
    }

    @IBAction func selectProjectButtonTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let projectSelectorVC = storyboard.instantiateViewController(identifier: "NewPost2TableViewController") as? NewPost2TableViewController else {
            return
        }
        projectSelectorVC.delegate = self
        navigationController?.pushViewController(projectSelectorVC, animated: true)
    }
    
    @IBAction func uploadButtonTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let thanksVC = storyboard.instantiateViewController(identifier: "ThanksViewController") as? ThanksViewController else {
            return
        }
        thanksVC.modalPresentationStyle = .fullScreen
        present(thanksVC, animated: true, completion: nil)
    }
    
    @IBAction func cameraButtonTapped(_ sender: UIButton) {
        let actionSheet = UIAlertController(title: "Choose Photo", message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { (_) in
            self.openCamera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Choose from Library", style: .default, handler: { (_) in
            self.openPhotoLibrary()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        if let popoverController = actionSheet.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = sender.frame
        }

        present(actionSheet, animated: true, completion: nil)
    }

    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = true
            present(imagePicker, animated: true, completion: nil)
        } else {
            print("Camera not available")
        }
    }

    func openPhotoLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true
            present(imagePicker, animated: true, completion: nil)
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            imageView.image = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            imageView.image = originalImage
        }
        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

extension NewPostViewController: NewPost2TableViewControllerDelegate {
    func didSelectProject(_ project: Project) {
        self.selectedProject = project
        projectTitleText.text = project.name
        adjustTextViewHeight()
        selectProjectButton.setTitle("Select Project", for: .normal)
        categoriesPickerView.reloadAllComponents()
    }

    private func adjustTextViewHeight() {
        projectTitleText.sizeToFit()
        projectTitleText.isScrollEnabled = false
    }
}

extension NewPostViewController {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return selectedProject?.monitoredVariables.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let variableName = selectedProject?.monitoredVariables[row] else { return nil }
        return formatVariableName(variableName)
    }
    
    private func formatVariableName(_ name: String) -> String {
        let formatted = name
            .replacingOccurrences(of: "_", with: " ")
            .capitalized
        return formatted
    }
}
