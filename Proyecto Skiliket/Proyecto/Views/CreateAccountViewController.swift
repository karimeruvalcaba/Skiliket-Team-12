import UIKit
import Firebase
import FirebaseAuth

class CreateAccountViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var ZonePickerView: UIPickerView!
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var AddressTextField: UITextField!
    @IBOutlet weak var AgeTextField: UITextField!
    @IBOutlet weak var FullNameTextfield: UITextField!
    @IBOutlet weak var termsAndConditionsButton: UIButton!
    @IBOutlet weak var CheckButton: UIButton!
    @IBOutlet weak var checkImage: UIImageView!
    
    var isCheckButtonChecked = false


    let zoneOptions = ["Mexico City", "Guadalajara", "Monterrey", "Toronto"]
    var selectedZone: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        ZonePickerView.delegate = self
        ZonePickerView.dataSource = self
        
        selectedZone = zoneOptions.first

        configureCheckButton()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    // MARK: - Configure CheckButton Appearance
    
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

    private func configureCheckButton() {
        isCheckButtonChecked = false
        checkImage.isHidden = true
        updateCheckButtonAppearance()
    }

    private func updateCheckButtonAppearance() {
        CheckButton.layer.borderWidth = 2
        CheckButton.layer.borderColor = UIColor.black.cgColor
        checkImage.isHidden = !isCheckButtonChecked
    }

    @IBAction func checkButtonTapped(_ sender: UIButton) {
        isCheckButtonChecked.toggle()
        updateCheckButtonAppearance()
    }

    // MARK: - UIPickerView DataSource and Delegate methods

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return zoneOptions.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return zoneOptions[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedZone = zoneOptions[row]
    }

    // MARK: - Register Action

    @IBAction func Register(_ sender: UIButton) {
        guard isCheckButtonChecked else {
            let alert = UIAlertController(title: "Alert", message: "Terms and conditions must be checked in order to register!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }

        guard let email = EmailTextField.text, !email.isEmpty else { return }
        guard let address = AddressTextField.text, !address.isEmpty else { return }
        guard let age = AgeTextField.text, !age.isEmpty else { return }
        guard let name = FullNameTextfield.text, !name.isEmpty else { return }
        guard let password = PasswordTextField.text, !password.isEmpty else { return }
        guard let zone = selectedZone else { return }

        if password.count < 6 {
            let alert = UIAlertController(title: "Weak Password", message: "Password must be at least 6 characters long.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }

        UserDefaults.standard.set(email, forKey: "userEmail")
        UserDefaults.standard.set(address, forKey: "userAddress")
        UserDefaults.standard.set(age, forKey: "userAge")
        UserDefaults.standard.set(name, forKey: "username")
        UserDefaults.standard.set(zone, forKey: "userCity")
        UserDefaults.standard.set("YourCountry", forKey: "userCountry")
        UserDefaults.standard.set(0, forKey: "userFollowers")
        UserDefaults.standard.set([], forKey: "userFollowing")
        UserDefaults.standard.set("default", forKey: "userType")
        UserDefaults.standard.set("https://icons.veryicon.com/png/o/miscellaneous/common-icons-31/default-avatar-2.png", forKey: "userURL")

        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let e = error {
                print("Error: \(e.localizedDescription)")
            } else {
                self.performSegue(withIdentifier: "goToNext", sender: self)
            }
        }
    }

}
