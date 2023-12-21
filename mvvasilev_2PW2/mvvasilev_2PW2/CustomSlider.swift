//
//  CustomSlider.swift
//  mvvasilev_2PW2
//
//  Created by Matvey Vasilyev on 29.11.2023.
//

import UIKit


final class CustomSlider: UIView {
    var valueChanged: ((Double) -> Void)?
    
    var slider = UISlider()
    var titleView = UILabel()
    var valueView = UILabel()
    init(title: String, min: Double, max: Double) {
        super.init(frame: .zero)
        titleView.text = title
        valueView.text = "\(slider.value)"
        slider.minimumValue = Float(min)
        slider.maximumValue = Float(max)
        slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        configureUI()
        
    }
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    private func configureUI() {
        backgroundColor = .white
        translatesAutoresizingMaskIntoConstraints = false
        for view in [slider, titleView, valueView] {
            addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
            
        }
        NSLayoutConstraint.activate([
            titleView.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            titleView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            valueView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            valueView.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
            slider.topAnchor.constraint(equalTo: titleView.bottomAnchor),
            slider.centerXAnchor.constraint(equalTo: centerXAnchor),
            slider.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            slider.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20)
        ])
        
    }
    @objc
    private func sliderValueChanged() {
        valueChanged?(Double(slider.value))
        
    }
    
}
