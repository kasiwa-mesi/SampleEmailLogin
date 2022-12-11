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
    @IBOutlet private weak var cautionLabel: UILabel! {
        didSet {
            cautionLabel.isHidden = true
        }
    }
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
        
        viewModel.fetchMemos()
        viewModel.getIsEmailVerified()
        
        viewModel.showEmptyViewObservable
            .bind(to: Binder(self) { vc, _ in
                print("中身がない")
                vc.cautionLabel.isHidden = false
                vc.indicator.isHidden = true
                vc.tableView.isHidden = true
            }).disposed(by: rx.disposeBag)
        
        viewModel.updateMemoModelsObservable
            .bind(to: Binder(self) { vc, _ in
                print("メモを更新")
                vc.cautionLabel.isHidden = true
                vc.indicator.isHidden = true
                vc.tableView.isHidden = false
                vc.tableView.dataSource = self
                vc.tableView.delegate = self
                vc.tableView.reloadData()
            }).disposed(by: rx.disposeBag)
        
        viewModel.loadingObservable
            .bind(to: Binder(self) { vc, loading in
                vc.tableView.isHidden = loading
                vc.indicator.isHidden = !loading
            }).disposed(by: rx.disposeBag)
        
        viewModel.selectMemoModelObservable
            .bind(to: Binder(self) { vc, memo in
                Router.shared.showSetMemoChanged(from: vc, memo: memo)
            }).disposed(by: rx.disposeBag)
    }
}

@objc private extension HomeViewController {
    func tapSignOutButton() {
        viewModel.logOut()
    }
    
    func tapMoveSetEmailChanged() {
        Router.shared.showSetEmailChanged(from: self)
    }
    
    func tapMoveSetPasswordChanged() {
        Router.shared.showSetPasswordChanged(from: self)
    }
    
    func tapMoveSetMemoCreated() {
        Router.shared.showSetMemoCreated(from: self)
    }
}

extension HomeViewController: HomeViewModelInput {
    func show() {
        let tapLogoutAction = UIAlertAction(title: String.ok, style: .default) { _ in
            self.viewModel.sendEmailVerification()
            self.viewModel.logOut()
        }
        
        self.showAlert(title: "メールアドレスが確認されていません", message: "\(self.viewModel.email)宛に認証リンクを送信したので、ご確認ください", actions: [tapLogoutAction])
    }
    
    func showErrorAlert(code: String, message: String) {
        let gotItAction = UIAlertAction(title: String.ok, style: .default)
        let errorTitle = String.errorTitle + code
        self.showAlert(title: errorTitle, message: message, actions: [gotItAction])
    }
    
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
