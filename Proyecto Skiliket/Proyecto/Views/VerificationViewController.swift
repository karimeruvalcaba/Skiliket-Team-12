import UIKit

class VerificationViewController: UIViewController {

    @IBOutlet weak var verificationText: UILabel!
    @IBOutlet weak var codeSentText: UILabel!
    @IBOutlet weak var sendCodeButton: UIButton!
    
    let email = UserDefaults.standard.string(forKey: "userEmail")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        verificationText.text = "An email was sent to \(email!) with instructions to confirm the email address"
        codeSentText.isHidden = true
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

    @IBAction func sendCodeButtonTapped(_ sender: UIButton) {
        codeSentText.isHidden = false

        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            self.codeSentText.isHidden = true
        }
    }
}
