//
//  DetailedView.swift
//  FetchRewardsTechnical
//
//  Created by Gage Fonk on 9/11/21.
//

import UIKit

class DetailedView: UIViewController {
    
    let meal: MealDetails
    var ingredients: [String] = []
    var measurements: [String] = []
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.bounces = true
        scrollView.autoresizingMask = .flexibleHeight
        scrollView.showsVerticalScrollIndicator = true
        
        return scrollView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        
        return label
    }()
    
    let instructionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        
        return label
    }()
    
    let ingredientLabel: UILabel = {
        let label = UILabel()
        label.text = "Ingredients"
        
        return label
    }()
    
    let ingredientContainer: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        
        return stack
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(instructionLabel)
        scrollView.addSubview(ingredientLabel)
        scrollView.addSubview(ingredientContainer)
        
        //add ingredients to container
        addIngredientViews()
    }
    
    override func viewDidLayoutSubviews() {
        //add title
        title = meal.strMeal
        
        //setup scrollview
        scrollView.frame = view.bounds
        
        //setup titleLabel
        titleLabel.text = meal.strMeal
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10).isActive = true
        
        //setup instructionLabel
        instructionLabel.text = meal.strInstructions
        instructionLabel.translatesAutoresizingMaskIntoConstraints = false
        instructionLabel.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 10).isActive = true
        instructionLabel.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: -10).isActive = true
        instructionLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        instructionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40).isActive = true
        
        //setup ingredient label
        ingredientLabel.translatesAutoresizingMaskIntoConstraints = false
        ingredientLabel.topAnchor.constraint(equalTo: instructionLabel.bottomAnchor, constant: 20).isActive = true
        ingredientLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        
        //setup ingredient container
        ingredientContainer.translatesAutoresizingMaskIntoConstraints = false
        ingredientContainer.topAnchor.constraint(equalTo: ingredientLabel.bottomAnchor, constant: 20).isActive = true
        ingredientContainer.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 10).isActive = true
        ingredientContainer.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: -10).isActive = true
        
        
        //resize scrollview height -- had to google this one
        let contentRect: CGRect = scrollView.subviews.reduce(into: .zero) { rect, view in
            rect = rect.union(view.frame)
        }
        scrollView.contentSize = contentRect.size
    }
    
    init(meal: MealDetails) {
        self.meal = meal
        super.init(nibName: nil, bundle: nil)
        //update ingredients / measurements
        let mirror = Mirror(reflecting: meal)
        updateIngredients(mirror: mirror)
        updateMeasurements(mirror: mirror)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addIngredientViews() {
        let ingredientCount = ingredients.count
        let measurementCount = measurements.count
        let count = ingredientCount <= measurementCount ? ingredientCount : measurementCount
        
        for i in 0..<count {
            let ingredientLabel = UILabel()
            ingredientLabel.text = ingredients[i]
            ingredientLabel.numberOfLines = 0
            ingredientLabel.lineBreakMode = .byWordWrapping
            ingredientLabel.textAlignment = .center
            ingredientLabel.translatesAutoresizingMaskIntoConstraints = false
            
            let measurementLabel = UILabel()
            measurementLabel.text = measurements[i]
            measurementLabel.numberOfLines = 0
            measurementLabel.lineBreakMode = .byWordWrapping
            measurementLabel.textAlignment = .center
            measurementLabel.translatesAutoresizingMaskIntoConstraints = false
            
            let divider = UIView()
            divider.backgroundColor = .black
            divider.translatesAutoresizingMaskIntoConstraints = false
            divider.heightAnchor.constraint(equalToConstant: 1).isActive = true
            
            let stack = UIStackView()
            stack.axis = .horizontal
            stack.distribution = .fillEqually
            stack.alignment = .center
            stack.addArrangedSubview(measurementLabel)
            stack.addArrangedSubview(ingredientLabel)
            stack.translatesAutoresizingMaskIntoConstraints = false
            
            ingredientContainer.addArrangedSubview(stack)
            ingredientContainer.addArrangedSubview(divider)
        }
    }
    
    func updateIngredients(mirror: Mirror){
        let strReference = "strIngredient"
        for att in mirror.children {
            if let label = att.label {
                if label.contains(strReference) {
                    if let val = att.value as? String{
                        if val != "" && val != " " {
                            ingredients.append(val)
                        }
                    }
                }
            }
        }
    }
    
    func updateMeasurements(mirror: Mirror) {
        let strReference = "strMeasure"
        for att in mirror.children {
            if let label = att.label {
                if label.contains(strReference) {
                    if let val = att.value as? String{
                        if val != "" && val != " " {
                            measurements.append(val)
                        }
                    }
                }
            }
        }
    }
    

}
