# SampleEmailLogin
iOSアプリのURL: 

## 目次

- [アプリの内容](https://github.com/kasiwa-mesi/SampleEmailLogin#アプリの内容)
- [機能](https://github.com/kasiwa-mesi/SampleEmailLogin#機能)
  - [会員登録機能](https://github.com/kasiwa-mesi/SampleEmailLogin#会員登録機能)
  - [ログイン・ログアウト](https://github.com/kasiwa-mesi/SampleEmailLogin#ログイン・ログアウト)
  - [メールアドレス変更](https://github.com/kasiwa-mesi/SampleEmailLogin#メールアドレス変更)
  - [パスワード再設定](https://github.com/kasiwa-mesi/SampleEmailLogin#パスワード再設定)
- [コードレビューで指摘された箇所](https://github.com/kasiwa-mesi/SampleEmailLogin#コードレビュー)
  - [エラーハンドリング](https://github.com/kasiwa-mesi/SampleEmailLogin#エラーハンドリング)
  - [インデントを深くしない](https://github.com/kasiwa-mesi/SampleEmailLogin#インデントを深くしない)

## アプリの内容
- ログイン機能付きのメモアプリ

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