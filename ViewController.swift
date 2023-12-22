//
//  ViewController.swift
//  TodoListTest
//
//  Created by YeongHo Ha on 12/21/23.
//

import UIKit


struct Todo {
    var title: String
    var isCompleted: Bool
}


class ViewController: UIViewController {
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var list: [Todo] = [
        Todo(title: "첫 리스트", isCompleted: false), Todo(title: "멀 할까?", isCompleted: false), Todo(title: "놀자!!", isCompleted: false)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
       
        tableView.dataSource = self
        tableView.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    // 리스트 아이템 추가 메서드
    func addNewItem() {
        guard let newText = textField.text, !newText.isEmpty else {
            return
        }
        
        //새로운 아이템 리스트에 추가
        list.append(Todo(title: newText, isCompleted: false))
        //리스트 추가 될때, 리로드
        tableView.reloadData()
        //아이템 추가 후 텍스트 필드 초기화
        textField.text = nil
        
    }
    
    // 텍스트 필드 입력 후 리스트에 아이템 추가
    @IBAction func addTextField(_ sender: Any) {
        addNewItem()
    }
    
    // 리스트 추가 버튼
    @IBAction func addDidButton(_ sender: Any) {
        addNewItem()
    }
    
    // Todo 완료 토글
    @IBAction func toggleCompletion(_ sender: Any) {
        if let cell = (sender as AnyObject).superview??.superview as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) {
            list[indexPath.row].isCompleted.toggle()
            tableView.reloadRows(at: [indexPath], with: .none)
        }
    }
    
    
    // 리스트 특정 항목 삭제 메서드
    func deleteItem(at index: Int) {
        list.remove(at: index)
        tableView.reloadData()
    }
    
    // 삭제 확인창을 표시하는 메서드
    func showDeleteAlert(for index: Int) {
        // "삭제 확인" 제목과 "이 항목을 삭제하시겠습니까?" 내용을 alert창으로 생성.
        let alertController = UIAlertController(title: "삭제 확인", message: "이 항목을 삭제하시겠습니까?", preferredStyle: .alert)
        // "확인" 액션을 추가, deleteItem(at: index)를 호출하여 해당 항목 삭제
        let okAction = UIAlertAction(title: "확인", style: .destructive) { [weak self] _ in self?.deleteItem(at: index)
        }
        // "취소" 액션을 추가, 삭제 취소.
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alertController.addAction(okAction) // 사용자가 "확인" 버튼 클릭시 실행.
        alertController.addAction(cancelAction) // 사용자가 "취소" 버튼 클릭시 실행.
        
        present(alertController, animated: true, completion: nil)
    }
    
}


extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let todo = list[indexPath.row]
        
        // 취소선 추가
        let attributedTitle = NSAttributedString(string: todo.title, attributes: todo.isCompleted ? [.strikethroughStyle : NSUnderlineStyle.single.rawValue] : [:])
        cell.textLabel?.attributedText = attributedTitle
        
        return cell
    }
    
    // 라스트를 오른쪽으로 스와이프 했을 때, 삭제 버튼이 나타나도록 반환
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "삭제") { [weak self] (_, _, completion) in
            self?.showDeleteAlert(for: indexPath.row)
            completion(true)
        }
        
        let swipeConfig = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipeConfig
    }
    
}
