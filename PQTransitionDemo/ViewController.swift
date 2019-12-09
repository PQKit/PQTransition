//
//  ViewController.swift
//  PQTransitionDemo
//
//  Created by pgq on 2019/12/9.
//  Copyright © 2019 pgq. All rights reserved.
//

import UIKit
import PQTransition

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let v2 = ViewController2(transition: PQTransition(type: .bottomPush, presentFrame: CGRect(x: 0, y: UIScreen.main.bounds.height - 300, width: UIScreen.main.bounds.width, height: 300), duration: 0.25))
        
        present(v2, animated: true, completion: nil)
    }
}

class ViewController2: UIViewController {
  
    let transition: PQTransition
    init(transition: PQTransition) {
        self.transition = transition
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .custom
        self.transitioningDelegate = transition
        self.view.backgroundColor = .systemRed
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
  
    
    
}


