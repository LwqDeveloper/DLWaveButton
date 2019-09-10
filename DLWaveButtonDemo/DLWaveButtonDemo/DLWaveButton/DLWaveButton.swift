//
//  DLWaveButton.swift
//  DLWaveButtonDemo
//
//  Created by user on 2019/9/10.
//  Copyright © 2019 muyang. All rights reserved.
//

import UIKit

typealias DLWaveButtonCompletion = ((_ status: Int) -> Void)

class DLWaveButton: UIView {
    var pressCompletion: DLWaveButtonCompletion?
    
    // 触发时间
    private var startTime: Date!
    // 波纹触发时间
    private var startAnimationInterval: Double = 0.35
    // 波纹一次扩散时间
    private var waveRepeatOnceInterval: Double = 0.75
    // 波纹扩展动画进行中
    private var waveContinueAnimating: Bool = false
    
    // 扩散波纹视图
    var animationView: UIView = {
        let view = UIView.init(frame: CGRect.zero)
        view.backgroundColor = UIColor.orange.withAlphaComponent(0.1)
        return view
    }()
    
    // 圆形变化背景
    var bgCircleView: UIView = {
        let view = UIView.init(frame: CGRect.zero)
        view.backgroundColor = UIColor.orange
        return view
    }()
    
    // 文字label
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.white
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        addLongPressGesture()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        animationView.frame = CGRect(x: 0, y: -(self.bounds.size.width / 2 - self.bounds.size.height / 2), width: self.bounds.size.width, height: self.bounds.size.width)
        animationView.layer.cornerRadius = self.bounds.size.width / 2
        animationView.layer.masksToBounds = true
        animationView.isHidden = true
        self.addSubview(animationView)
        
        bgCircleView.frame = self.bounds
        bgCircleView.layer.cornerRadius = frame.size.height / 2
        bgCircleView.layer.masksToBounds = true
        self.addSubview(bgCircleView)
        
        titleLabel.frame = self.bounds
        self.addSubview(titleLabel)
    }
    
    private func addLongPressGesture() {
        let long = UILongPressGestureRecognizer(target: self, action: #selector(ges_longPress(_:)))
        long.minimumPressDuration = 0.01
        self.addGestureRecognizer(long)
    }
    
    // 长按渐变
    @objc private func ges_longPress(_ ges: UILongPressGestureRecognizer) {
        if self.waveContinueAnimating == true {
            // 波纹动画进行中
            return
        }

        if ges.state == .began {
            startTime = Date()
            UIView.animate(withDuration: startAnimationInterval, animations: {
                self.bgCircleView.frame = CGRect(x: 0, y: -(self.bounds.size.width / 2 - self.bounds.size.height / 2), width: self.bounds.size.width, height: self.bounds.size.width)
                self.bgCircleView.layer.cornerRadius = self.bounds.size.width / 2
            })
            self.perform(#selector(startScaleAnimation), with: nil, afterDelay: startAnimationInterval)
            if let pc = self.pressCompletion {
                pc(0)
            }
        } else if ges.state == .ended {
            let interval = Date().timeIntervalSince(self.startTime)
            if interval < startAnimationInterval {
                // 取消动画
                NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(startScaleAnimation), object: nil)
                // 还原形状
                self.bgCircleView.layer.removeAllAnimations()
                UIView.animate(withDuration: startAnimationInterval) {
                    self.bgCircleView.frame = self.bounds
                    self.bgCircleView.layer.cornerRadius = self.bounds.size.height / 2
                }
            }
            if let pc = self.pressCompletion {
                pc(1)
            }
        }
    }
    
    // 缩放动画
    @objc private func startScaleAnimation() {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.fromValue = NSNumber(floatLiteral: 1.0)
        animation.toValue = NSNumber(floatLiteral: 1.8)
        animation.duration = waveRepeatOnceInterval
        animation.autoreverses = true
        animation.repeatCount = 4
        self.animationView.layer.add(animation, forKey: "scaleSize")
        self.animationView.isHidden = false
        self.waveContinueAnimating = true
        self.perform(#selector(stopScaleAnimation), with: nil, afterDelay: waveRepeatOnceInterval * 4)
    }
    
    @objc private func stopScaleAnimation() {
        self.waveContinueAnimating = false
        self.animationView.layer.removeAnimation(forKey: "scaleSize")
        self.animationView.isHidden = true
        
        UIView.animate(withDuration: startAnimationInterval) {
            self.bgCircleView.frame = self.bounds
            self.bgCircleView.layer.cornerRadius = self.bounds.size.height / 2
        }
    }
}
