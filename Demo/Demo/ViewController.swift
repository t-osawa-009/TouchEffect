import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func buttonTapped(_ sender: Any) {
        let ac = UIAlertController(title: "Tap!", message: nil, preferredStyle: .alert)
        ac.addAction(.init(title: "OK", style: .default, handler: nil))
        present(ac, animated: true, completion: nil)
    }
}

