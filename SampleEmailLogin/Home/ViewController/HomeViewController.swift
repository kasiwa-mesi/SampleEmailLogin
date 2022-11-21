//
//  HomeViewController.swift
//  SampleEmailLogin
//
//  Created by kasiwa on 2022/10/19.
//

import RxCocoa
import RxOptional
import RxSwift
import UIKit

final class HomeViewController: UIViewController {
    private var moveSetMemoCreatedButtonItem: UIBarButtonItem!
    private var signOutButtonItem: UIBarButtonItem!
    
    @IBOutlet private weak var indicator: UIActivityIndicatorView!
    @IBOutlet private weak var cautionLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.register(TableViewCell.nib, forCellReuseIdentifier: TableViewCell.reuseIdentifier)
        }
    }
    @IBOutlet private weak var moveSetEmailChangedButton: UIButton! {
        didSet {
            moveSetEmailChangedButton.addTarget(self, action: #selector(tapMoveSetEmailChanged), for: .touchUpInside)
        }
    }
    
    @IBOutlet private weak var moveSetPasswordChangedButton: UIButton! {
        didSet {
            moveSetPasswordChangedButton.addTarget(self, action: #selector(tapMoveSetPasswordChanged), for: .touchUpInside)
        }
    }
    
    private let didSelectRelay: PublishRelay<Int> = .init()
    private var viewModel: HomeViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewModel()
        
        moveSetMemoCreatedButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(tapMoveSetMemoCreated))
        signOutButtonItem = UIBarButtonItem(barButtonSystemItem: .reply, target: self, action: #selector(tapSignOutButton))
        
        self.navigationItem.rightBarButtonItem = moveSetMemoCreatedButtonItem
        self.navigationItem.leftBarButtonItem = signOutButtonItem
        
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
    func setupViewModel() {
        viewModel = HomeViewModel(input: self)
        
        viewModel.fetchMemos { (memosExist) in
            if memosExist {
                self.cautionLabel.isHidden = true
                self.tableView.dataSource = self
                self.tableView.delegate = self
                self.tableView.reloadData()
            } else {
                self.cautionLabel.isHidden = false
                self.tableView.isHidden = true
            }
        }
        
        viewModel.loadingObservable
            .debug()
            .bind(to: Binder(self) { vc, loading in
                vc.tableView.isHidden = loading
                vc.indicator.isHidden = !loading
            }).disposed(by: rx.disposeBag)
        
        viewModel.selectMemoModelObservable.bind(to: Binder(self) { vc, memo in
            Router.shared.showSetMemoChanged(from: vc, memo: memo)
        }).disposed(by: rx.disposeBag)
    }
    
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

extension HomeViewController: HomeViewModelInput {
    var didSelectObservable: Observable<Int> {
        didSelectRelay.asObservable()
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectRelay.accept(indexPath.item)
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.memos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.reuseIdentifier, for: indexPath) as? TableViewCell else {
            return UITableViewCell()
        }
        let memo = viewModel.memos[indexPath.item]
        cell.configure(memo: memo)
        return cell
    }
}
