//
//  MotivationViewController.swift
//  FitSync
//
//  Created by Devarsh Agrawal on 2025-04-12.
//

import UIKit
import WebKit

class MotivationViewController: UIViewController {

    @IBOutlet weak var emojiLabel: UILabel!
        @IBOutlet weak var quoteTextLabel: UILabel!
    @IBOutlet weak var webView: WKWebView!


        override func viewDidLoad() {
            super.viewDidLoad()
            updateMotivationContent()
            webView.isHidden = true // Initially hide web view

        }

        @IBAction func newQuoteButtonTapped(_ sender: UIButton) {
            updateMotivationContent()
        }
    
    @IBAction func openWebButtonTapped(_ sender: UIButton) {
            if let url = URL(string: "https://www.brainyquote.com/topics/motivational-quotes") {
                let request = URLRequest(url: url)
                webView.load(request)
                webView.isHidden = false
            }
        }

        func updateMotivationContent() {
            let quote = QuoteProvider.getRandomQuote()
            emojiLabel.text = quote.emoji
            quoteTextLabel.text = quote.text
        }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
