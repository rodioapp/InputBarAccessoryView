/*
 MIT License
 
 Copyright (c) 2017 MessageKit
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

import UIKit

public protocol AutocompleteDataSource: class {
    
    func autocomplete(_ autocompleteManager: AutocompleteManager, autocompleteTextFor prefix: Character) -> [String]
    
    func autocomplete(_ autocompleteManager: AutocompleteManager, tableView: UITableView, cellForRowAt indexPath: IndexPath, for arguments: (char: Character, filterText: String, autocompleteText: String)) -> UITableViewCell
}

public extension AutocompleteDataSource {
    
    func autocomplete(_ autocompleteManager: AutocompleteManager, tableView: UITableView, cellForRowAt indexPath: IndexPath, for arguments: (char: Character, filterText: String, autocompleteText: String)) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AutocompleteCell.reuseIdentifier, for: indexPath) as? AutocompleteCell else {
            return UITableViewCell()
        }
    
        let matchingRange = (arguments.autocompleteText as NSString).range(of: arguments.filterText, options: .caseInsensitive)
        let attributedString = NSMutableAttributedString().normal(arguments.autocompleteText)
        attributedString.addAttributes([NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 14)], range: matchingRange)
        let stringWithPrefix = NSMutableAttributedString().normal(String(arguments.char))
        stringWithPrefix.append(attributedString)
        cell.textLabel?.attributedText = stringWithPrefix
        
        cell.backgroundColor = autocompleteManager.inputBarAccessoryView?.backgroundView.backgroundColor ?? .white
        cell.tintColor = autocompleteManager.inputBarAccessoryView?.tintColor
        cell.separatorLine.isHidden = indexPath.row == (autocompleteManager.currentAutocompleteText ?? []).count - 1
        
        return cell
    }
}

