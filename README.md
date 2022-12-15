# SampleEmailLogin
[iOSアプリのURL](https://apps.apple.com/app/%E3%83%A1%E3%83%A2-%E7%94%9F%E6%B4%BB%E3%82%92%E8%A8%98%E9%8C%B2/id6444788780)

## 目次

- [アプリの内容](https://github.com/kasiwa-mesi/SampleEmailLogin#アプリの内容)
- [技術要件](https://github.com/kasiwa-mesi/SampleEmailLogin#技術要件)
- [注意して実装した箇所](https://github.com/kasiwa-mesi/SampleEmailLogin#注意して実装した箇所)
  - [ViewControllerにif文を流入させないこと](https://github.com/kasiwa-mesi/SampleEmailLogin#ViewControllerにif文を流入させないこと)
- [コードレビューで指摘された箇所](https://github.com/kasiwa-mesi/SampleEmailLogin#コードレビューで指摘された箇所)
  - [エラーハンドリング](https://github.com/kasiwa-mesi/SampleEmailLogin#エラーハンドリング)
  - [インデントを深くしない](https://github.com/kasiwa-mesi/SampleEmailLogin#インデントを深くしない)
  - [ハードコーディングを避ける](https://github.com/kasiwa-mesi/SampleEmailLogin#ハードコーディングを避ける)
- [機能](https://github.com/kasiwa-mesi/SampleEmailLogin#機能)
  - [会員登録機能](https://github.com/kasiwa-mesi/SampleEmailLogin#会員登録機能)
  - [ログイン・ログアウト](https://github.com/kasiwa-mesi/SampleEmailLogin#ログイン・ログアウト)
  - [メールアドレス変更](https://github.com/kasiwa-mesi/SampleEmailLogin#メールアドレス変更)
  - [パスワード再設定](https://github.com/kasiwa-mesi/SampleEmailLogin#パスワード再設定)
- [今後追加したい機能](https://github.com/kasiwa-mesi/SampleEmailLogin#今後追加したい機能)
  - [メモの並び替え](https://github.com/kasiwa-mesi/SampleEmailLogin#メモの並び替え)
## アプリの内容
- ログイン機能付きのメモアプリ

## 技術要件
- Swift
- Firebase
  - Firebase Authentication)
    - アプリ内のログイン機能として活用
  - Firestore
    - メモを保存するデータベースとして活用
  - FirebaseStorage
    - メモに添付する画像アップロード機能を実装するために利用
- アーキテクチャ
  - MVVM(Model - View - ViewModel)

## 注意して実装した箇所
### ViewControllerにif文を流入させないこと
MVVMの設計に基づき、ViewControllerは**Viewに関する実装**, **ViewModelに依存する実装**だけを記述するようにした。

しかし、データベースの通信でViewの変更が起きる。
そのため、if文ではなく、RxSwiftを使って変更を監視した。
(参考: 下記コード: HomeViewModel, HomeViewController)

**HomeViewModel**
```
final class HomeViewModel: HomeViewModelOutput, HasDisposeBag {
    private let _loading: PublishRelay<Bool> = .init()
    lazy var loadingObservable: Observable<Bool> = _loading.asObservable()

    func fetchMemos() {
        DatabaseService.shared.getCollection(userId: self.userId) { memos, error in
            // 省略
            self._loading.accept(false)
            // 省略
        }
    }
}
```

**HomeViewController**
```
viewModel.loadingObservable
    .bind(to: Binder(self) { vc, loading in
      vc.tableView.isHidden = loading
      vc.indicator.isHidden = !loading
    }).disposed(by: rx.disposeBag)
```

## コードレビューで指摘された箇所
Swiftに関して知識が薄いので、知り合いのiOSエンジニアにコードレビューしてもらった。
ここでは、コードレビューを受けて改善した内容に関して記述する

### エラーハンドリング
レビュー前のコードであれば、アプリ内でエラーが発生してもユーザーに対して何もリアクションしない状態であった。

レビュー後のコードでは、エラーコードとエラーの内容をモーダルで表示している(参考下記画像)。ユーザーから問い合わせがあれば、スクリーンショットを撮ってもらって、エラーコードとエラーの内容に基づいて修正できるように改善

- <img src="https://gyazo.com/1e2aea51bfd092e4449d3f44bae335e8/raw" width="200" height="400">

### インデントを深くしない
レビュー前のコードは、下記のように条件が増えるたび、ネストが深くなるような実装であった。
```
func hoge() {
  if hoge {
      //
  } else if hage {
     if fuga {
        //本来このメソッドがやること
     }
  } else {
    //
  }
}
```

レビュー後のコードは、以下のように不正な入力があれば、早期returnするように改善した。また、できる限りメソッドがやるべき実装を最後に記述するように変更した。
```
func hoge(input: String?) {
 if 不正な入力か判定 {
   return
 }
 if 不正な入力か判定 {
   return
 }
 if 不正な入力か判定 {
   return
 }

 本来このメソッドがやるべき処理
}
```

### ハードコーディングを避ける
各ファイルで使い回すダイアログの「"了解しました"」という文字列に関しては、修正するとき手間がかかる。

レビューを受けて、以下のようにextensionでまとめるように改善。
```
extension String {
  static var ok: String { "了解しました" }
}
```

## 機能
### 会員登録機能
- 打ち間違えた時の対策としてパスワードを2回入力させる
- <img src="https://gyazo.com/42f7eab0ddbdc294ee8379b7141e6d48/raw" width="200" height="400">

### ログイン・ログアウト
- <img src="https://gyazo.com/d9fb1b0b6c25190f00dcb4e72a5060af/raw" width="200" height="400">

### メールアドレス変更
- <img src="https://gyazo.com/48b131d09c7e4c596e6a1f854944c372/raw" width="200" height="400">

### パスワード再設定
- <img src="https://gyazo.com/deaa5ae62cfe599c875665cc38a6dfe8/raw" width="200" height="400">

## 今後追加したい機能
### メモの並び替え
作成日、五十音、画像ファイルの有無で並び替えでフィルターをかけられる機能を実装したい