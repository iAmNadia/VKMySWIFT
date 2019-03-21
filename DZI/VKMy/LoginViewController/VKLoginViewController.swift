

import UIKit
import WebKit
import Alamofire


class VKLoginViewController: UIViewController {
    var friend: FriendController!
    private let networkService = NetworkService()
    
    @IBOutlet weak var webView: WKWebView! {
        didSet {
            webView.navigationDelegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let request = NetworkService().authorizeRequest()
        print(request)
        
        webView.load(request)

    }
}
func deleteCookies() {
    let dataStore = WKWebsiteDataStore.default()
    dataStore.fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
        dataStore.removeData(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(), for: records) {
            print("Deleted: " + records.description)
            
        }
    }
}

extension VKLoginViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        guard let url = navigationResponse.response.url, url.path == "/blank.html", let fragment = url.fragment  else {
            decisionHandler(.allow)
            return
        }
        
        let params = fragment
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce([String: String]()) { result, param in
                var dict = result
                let key = param[0]
                let value = param[1]
                dict[key] = value
                return dict
        }
        
        print(params)
        
        guard let token = params["access_token"],
            let userId = Int(params["user_id"]!) else {
                decisionHandler(.cancel)
                
                return
        }
        
        print(token, userId)
        
        Session.shared.token = token
        Session.shared.userId = userId
        
        decisionHandler(.cancel)
        
        performSegue(withIdentifier: "VKLogin", sender: nil)
    }
}
