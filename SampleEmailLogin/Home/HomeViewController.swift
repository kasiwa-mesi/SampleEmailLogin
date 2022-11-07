//
//  HomeViewController.swift
//  SampleEmailLogin
//
//  Created by kasiwa on 2022/10/19.
//

import UIKit

final class HomeViewController: UIViewController {
    
    private var memos: [MemoModel] = []
    
    var moveSetMemoCreatedButtonItem: UIBarButtonItem!
    var signOutButtonItem: UIBarButtonItem!
    
    @IBOutlet weak var isEmailAuthenticatedLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            print("tableView登録")
            tableView.register(TableViewCell.nib, forCellReuseIdentifier: TableViewCell.reuseIdentifier)
        }
    }
    @IBOutlet weak var moveSetEmailChangedButton: UIButton! {
        didSet {
            moveSetEmailChangedButton.addTarget(self, action: #selector(tapMoveSetEmailChanged), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var moveSetPasswordChangedButton: UIButton! {
        didSet {
            moveSetPasswordChangedButton.addTarget(self, action: #selector(tapMoveSetPasswordChanged), for: .touchUpInside)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        moveSetMemoCreatedButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(tapMoveSetMemoCreated))
        signOutButtonItem = UIBarButtonItem(barButtonSystemItem: .reply, target: self, action: #selector(tapSignOutButton))
        
        self.navigationItem.rightBarButtonItem = moveSetMemoCreatedButtonItem
        self.navigationItem.leftBarButtonItem = signOutButtonItem
        
        let userId = AuthController.shared.getCurrentUserId()
        CloudFirestoreService.shared.getCollection(userId: userId) { (memos) in
            print("メモ: \(memos)")
            self.memos = memos
            print("self.memos: \(self.memos)")
            if !self.memos.isEmpty {
                self.isEmailAuthenticatedLabel.isHidden = true
                self.tableView.isHidden = false
                self.tableView.dataSource = self
                self.tableView.delegate = self
                self.tableView.reloadData()
            } else {
                self.tableView.isHidden = true
                self.isEmailAuthenticatedLabel.isHidden = false
            }
        }
        //        if Auth.auth().currentUser?.isEmailVerified {
        //            isEmailAuthenticatedLabel.text = ""
        //        } else {
        //            isEmailAuthenticatedLabel.text = "まだ、メール認証されていません。メール受信リストを確認してください"
        //        }
        
    }
    
    static func makeFromStoryboard() -> HomeViewController {
        guard let vc = UIStoryboard.init(name: "Home", bundle: nil).instantiateInitialViewController() as? HomeViewController else {
            fatalError()
        }
        return vc
    }
}

private extension HomeViewController {
    @objc func tapSignOutButton() {
        print("ログアウト")
        AuthController.shared.signOut()
    }
    
    @objc func tapMoveSetEmailChanged() {
        print("メールアドレス変更へ遷移")
        Router.shared.showSetEmailChanged(from: self)
    }
    
    @objc func tapMoveSetPasswordChanged() {
        print("パスワード再設定へ移動")
        Router.shared.showSetPasswordChanged(from: self)
    }
    
    @objc func tapMoveSetMemoCreated() {
        print("メモ新規作成へ移動")
        Router.shared.showSetMemoCreated(from: self)
    }
    
    @objc func addButtonPressed(_ sender: UIBarButtonItem) {
       print("追加ボタンが押されました")
     }

     @objc func deleteButtonPressed(_ sender: UIBarButtonItem) {
       print("削除ボタンが押されました")
     }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("cellの個数返す")
        print(memos)
        return memos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("cellの再利用")
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.reuseIdentifier, for: indexPath) as? TableViewCell else {
            return UITableViewCell()
        }
        let memo = memos[indexPath.row]
        cell.configure(memo: memo)
        return cell
    }
}
