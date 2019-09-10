//
//  ViewController.swift
//  DLWaveButtonDemo
//
//  Created by user on 2019/9/10.
//  Copyright © 2019 muyang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let button = DLWaveButton(frame: CGRect(x: UIScreen.main.bounds.size.width / 2 - 60, y: UIScreen.main.bounds.size.height - 200, width: 120, height: 40))
        button.titleLabel.text = "长按回收"
        button.pressCompletion = { (index) in
            // 0按下  1结束
            print("按下状态\(index)")
        }
        view.addSubview(button)
    }

    
}

