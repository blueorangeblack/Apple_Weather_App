//
//  SuggestionCell.swift
//  Apple_Weather_App
//
//  Created by Minju Lee on 2022/02/09.
//

import UIKit

class SuggestionCell: UITableViewCell {
    
    // MARK: - Properties
    
    var viewModel: SuggestionViewModel? {
        didSet { configure() }
    }
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    func configure() {
        guard let viewModel = viewModel else { return }
        
        var content = defaultContentConfiguration()
        content.text = viewModel.result
        content.textProperties.color = .white
        contentConfiguration = content
        backgroundColor = .black
    }
}
