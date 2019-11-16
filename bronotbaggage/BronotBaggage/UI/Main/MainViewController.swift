//
//  MainViewController.swift
//  XcodeGenDemo
//

import UIKit
import SnapKit



class MainViewController: UIViewController {

    let imageView = UIImageView(image: .cat1)
    
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .white
        view.addSubview(imageView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
}
