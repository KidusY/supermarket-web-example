//
//  LoginScreenlet.swift
//  WeDeployApp
//
//  Created by Victor Galán on 09/01/2017.
//  Copyright © 2017 liferay. All rights reserved.
//

import UIKit
import WeDeploy
import RxSwift

public enum LoginDelegate {
	case loginSuccessful(User)
	case loginError(Error)
	case actionStarted(String)
	case customAction(String, InteractorOutput)
	case customActionError(String, Error)
	case error(Error)
}

open class LoginScreenlet: BaseScreenlet {

	public static let LoginActionName = "LoginAction"
	public static let LoginWithProviderActionName = "LoginWithProviderActionName"

	var delegate = PublishSubject<LoginDelegate>()

	override open func interactionStarted(actionName: String) {
		delegate.onNext(.actionStarted(actionName))
	}

	override open func interactionEnded(actionName: String, result: InteractorOutput) {
		if actionName == LoginScreenlet.LoginActionName ||
			actionName == LoginScreenlet.LoginWithProviderActionName {

			delegate.onNext(.loginSuccessful(result as! User))
		}
		else {
			delegate.onNext(.customAction(actionName, result))
		}

		super.interactionEnded(actionName: actionName, result: result)
	}

	override open func interactionErrored(actionName: String, error: Error) {
		if actionName == LoginScreenlet.LoginActionName ||
			actionName == LoginScreenlet.LoginWithProviderActionName {

			delegate.onNext(.loginError(error))
		}
		else {
			delegate.onNext(.customActionError(actionName, error))
		}

		super.interactionErrored(actionName: actionName, error: error)
	}
}
