//
//  ViewController.swift
//  TodayRecipe
//
//  Created by Seoyoung on 23/05/2019.
//  Copyright © 2019 Seoyoung. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import KakaoOpenSDK
import NaverThirdPartyLogin
import GoogleSignIn


class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    // facebook login
    @IBAction func FBLoginBtn(_ sender: UIButton) {
        let facebookLogin = LoginManager()
        facebookLogin.logIn(readPermissions: ["public_profile", "email", "user_friends"], from: self){
            (facebookResult: LoginManagerLoginResult?, facebookError: Error?) in
            
            if facebookError != nil {
                print("Facebook login failed. Error \(facebookError)")

            } else {
                let accessToken = AccessToken.current?.tokenString
                print("Successfully logged in with facebook. \(accessToken)")

            }
        }
    }
    // Google login
    @IBAction func GGLoginBtn(_ sender: Any) {
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.uiDelegate = self
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    // naver login
    @IBAction func NVLoginBtn(_ sender: UIButton) {
        let naverLogin = NaverThirdPartyLoginConnection.getSharedInstance()
        naverLogin?.delegate = self
        naverLogin?.requestThirdPartyLogin()
    }
    
    // kakaotalk login
    @IBAction func KTLoginBtn(_ sender: UIButton) {
//        let kakaoLogin = KOLoginButton()
        let session = KOSession.shared()
        if let s = session {
            if s.isOpen() {
                s.close()
            }
            s.presentingViewController = self
            s.open(completionHandler: { (error) in
                if error != nil {
                    print("Kakao login failed. Error \(error)")
                } else {
                    if s.isOpen() {
                        print("Successfully logged in with kakao.")
                    }
                }
            })
        }
        else {
            print("There's Session Error")
        }
        
    }
    
    @IBAction func EmailLoginBtn(_ sender: Any) {
        
    }
    @IBAction func EmailJoinBtn(_ sender: Any) {
        
    }
    
}

extension LoginViewController: NaverThirdPartyLoginConnectionDelegate {
    func oauth20ConnectionDidOpenInAppBrowser(forOAuth request: URLRequest!) {
        // 로그인 토큰이 없는 경우, 로그인 화면을 오픈한다.
        let naverSignInViewController = NLoginThirdPartyOAuth20InAppBrowserViewController(request: request)!
        present(naverSignInViewController, animated: true, completion: nil)
    }

    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        // 로그인 성공
        print("Success oauth20ConnectionDidFinishRequestACTokenWithAuthCode")
        getNaverEmailFromURL()
    }

    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
        // 로그인 된 상태(로그아웃이나 연동해제를 하지 않은 상태)에서 로그인 재시도
        print("Success oauth20ConnectionDidFinishRequestACTokenWithRefreshToken")
        getNaverEmailFromURL()
    }

    func oauth20ConnectionDidFinishDeleteToken() {
        // 연동해제 콜백
    }

    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
        // 접근 토큰, 갱신 토큰, 연동 해제 등이 실패
        print(error.localizedDescription)
        print(error)
    }

    func getNaverEmailFromURL(){
        guard let loginConn = NaverThirdPartyLoginConnection.getSharedInstance() else {return}
        guard let tokenType = loginConn.tokenType else {return}
        guard let accessToken = loginConn.accessToken else {return}
        
        let authorization = "\(tokenType) \(accessToken)"
        if let url = URL(string: "https://openapi.naver.com/v1/nid/me") {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue(authorization, forHTTPHeaderField: "Authorization")
            
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard let data = data else {return}
                do {
                    guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] else { return }
                    guard let response = json["response"] as? [String: AnyObject] else { return }
                    let id = response["id"] as? String
                    let email = response["email"] as? String
                    let name = response["name"] as? String
                    let nickname = response["nickname"] as? String
                    let profileImage = response["profile_image"] as? String
                    let birthday = response["birthday"] as? String
                    let gender = response["gender"] as? String
//                    print("id: \(id)", "email: \(email)", "name: \(name)", "nickname: \(nickname)", "profileImage: \(profileImage)", "birthday: \(birthday)", "gender: \(gender)")
                } catch let error as NSError {
                    print(error)
                }
            }.resume()
        }
    }
    
    // 네이버 토큰 리셋
    func naverReset() {
        NaverThirdPartyLoginConnection.getSharedInstance()?.resetToken()
    }
    
    // 네이버 토큰 삭제
    func naverLogout() {
        NaverThirdPartyLoginConnection.getSharedInstance()?.requestDeleteToken()
    }
    
}


extension LoginViewController: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print("사용자가 로그인 취소, \(error)")
            return
        } else if let user = user {
//            print("userID: \(user.userID)", "idToken: \(user.authentication.idToken)", "name: \(user.profile.name)", "email: \(user.profile.email)")
        }
    }
}

extension LoginViewController: GIDSignInUIDelegate {
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        viewController.dismiss(animated: true, completion: nil)
    }
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
}
