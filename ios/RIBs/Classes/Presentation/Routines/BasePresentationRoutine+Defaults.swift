//
//  Copyright (c) 2017. Uber Technologies
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import Foundation

public extension BasePresentationRoutine {
    func show(viewController: ViewControllable, with presentation: ViewablePresentation) {
        self.viewablePresentation = presentation.rawValue
        presentation.execute(with: viewController)
    }

    func hide(animated: Bool = true, completion: BaseCompletion? = nil) {
        guard let presentation = viewablePresentation else {
            assertionFailure("Attempt to dismiss not presented component")
            completion?()
            return
        }

        switch presentation {
        case .asRoot:
            fatalError("Attempt to dismiss a 'ViewController presented as window root'")

        case .modally:
            viewControllable.uiViewController.dismiss(animated: animated, completion: completion)

        case .embedded:
            viewControllable.uiViewController.view.removeFromSuperview()
            viewControllable.uiViewController.removeFromParent()
        }

        viewablePresentation = nil
    }
}

public extension BasePresentationRoutine where Self: ViewableRouting {
    func showAttached(router: ViewableFlowRouting, with presentation: ViewablePresentation) {
        attachChild(router)
        show(viewController: router.navigationViewControllable, with: presentation)
    }

    func showAttached(router: ViewableRouting, with presentation: ViewablePresentation) {
        attachChild(router)
        show(viewController: router.viewControllable, with: presentation)
    }

    func hideDetached(animated: Bool = true, completion: BaseCompletion? = nil) {
        detachCurrentChild()
        hide(animated: animated, completion: completion)
    }
}

public extension BasePresentationRoutine where Self: ViewableFlowRouting {
    func showAttached(router: ViewableFlowRouting, with presentation: ViewablePresentation) {
        attachChild(router)
        show(viewController: router.navigationViewControllable, with: presentation)
    }

    func showAttached(router: ViewableRouting, with presentation: ViewablePresentation) {
        attachChild(router)
        show(viewController: router.viewControllable, with: presentation)
    }

    func hideDetached(animated: Bool = true, completion: BaseCompletion? = nil) {
        detachCurrentChild()
        hide(animated: animated, completion: completion)
    }
}