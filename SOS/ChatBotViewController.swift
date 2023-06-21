//
//  ChatBotViewController.swift
//  SOS
//
//  Created by Neha Patil on 4/3/23.
//

import UIKit
import OpenAISwift
import SwiftUI

class ChatBotViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var tableView: UITableView!
    private var client: OpenAISwift?
    var models = [String]()
    var cells: [ChatCell] = [
        ChatCell(sender: "ChatGPT", body: "Hi I'm SOS's AI Chatbot, ask me questions related to emergencies and safety! Here's an example: 'What are strategic self defense tactics?'")
    
    ]
    var finalResponse: String = "asdfjdsalkf"

    @IBOutlet weak var enterText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        tableView.dataSource = self
        self.enterText.delegate = self
        tableView.register(UINib(nibName: "ChatBotTableViewCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
       
        // Do any additional setup after loading the view.
    }
    
    @objc func dismissKeyboard() {
            view.endEditing(true)
        }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return enterText.resignFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        enterText.resignFirstResponder()
        self.view.endEditing(true)
    }
    func setUp(){
        client = OpenAISwift(authToken: "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")
        
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        if enterText.text == "" {
            return
        } else {
            guard !enterText.text!.isEmpty else {
                return
            }
            self.models.append("me: \(enterText.text!)")
            self.cells.append(ChatCell(sender: "me", body: self.enterText.text!))
            send(text: enterText.text!) { response in
                DispatchQueue.main.async{
                    
                    self.finalResponse = response.trimmingCharacters(in: .whitespacesAndNewlines.union(.init(charactersIn: "\"")))
        
                    self.cells.append(ChatCell(sender: "ChatGPT", body: self.finalResponse))
                    print(self.finalResponse)
                    self.enterText.text = ""
                    self.tableView.reloadData()
                    let indexPath = IndexPath(row: self.cells.count - 1, section: 0)
                    self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
                }
                
            }
            
        }
        enterText.resignFirstResponder()
        print(finalResponse)
    }
        
        
    func send(text: String, completion: @escaping (String) -> Void) {
        client?.sendCompletion(with: text,
                               maxTokens: 500,
                               completionHandler: { result in
            switch result {
            case.success(let model):
                let output = model.choices?.first?.text ?? ""
                completion(output)
            case .failure(_):
                break
            }
        })
        
        
    }
    
}



extension ChatBotViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! ChatBotTableViewCell
        cell.messageLabel.text = cells[indexPath.row].body
        
        if cells[indexPath.row].sender == "me" {
            cell.leftImage.isHidden = true
            cell.imageSender.isHidden = false
            
        }
        //This is a message from another sender.
        else {
            cell.leftImage.isHidden = false
            cell.imageSender.isHidden = true
          
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {

       return tableView.rowHeight

    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {

        return UITableView.automaticDimension
    }

    
    
}


