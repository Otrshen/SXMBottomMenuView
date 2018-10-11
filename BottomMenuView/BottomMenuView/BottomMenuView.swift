//
//  BottomMenuView.swift
//  BottomMenuView
//
//  Created by 1 on 2018/10/10.
//  Copyright © 2018年 sxm. All rights reserved.
//

import UIKit

/// 菜单Cell的高度
fileprivate let kMenuCellHeight: CGFloat = 50
/// 取消按钮的间距
fileprivate let kCancelBtnPadding: CGFloat = 8
/// title的左右间距
fileprivate let kLRPadding: CGFloat = 20
/// title的上下间距
fileprivate let kTBPadding: CGFloat = 14
/// 屏幕的宽度
fileprivate let kWidth: CGFloat = UIScreen.main.bounds.width
/// ContentView背景色
fileprivate let kBgColor = UIColor(red: 227 / 255.0, green: 227 / 255.0, blue: 227 / 255.0, alpha: 1)
fileprivate let kTextColor = UIColor(red: 45 / 255.0, green: 45 / 255.0, blue: 45 / 255.0, alpha: 1)

typealias HandlerBlock = (() -> Swift.Void)?

enum BottomMenuActionStyle : Int {
    case `default`
    case cancel
    case destructive
}

class BottomMenuAction {
    var title: String
    var style: BottomMenuActionStyle
    var handler: HandlerBlock
    
    init(title: String, style: BottomMenuActionStyle, handler: HandlerBlock) {
        self.title = title
        self.style = style
        self.handler = handler
    }
}

class BottomMenuView: UIView {
    
    private var title: String?
    private var actions: [BottomMenuAction]
    private var cancelHandler: HandlerBlock
    
    private var titleLabel: UILabel
    // 缓存高度
    private var titleViewHeight: CGFloat?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(title: String?, actions: [BottomMenuAction], cancelHandler: HandlerBlock) {
        self.title = title
        self.actions = actions
        self.cancelHandler = cancelHandler
        
        // 标题
        titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: kWidth - 2 * kLRPadding, height: 0))

        super.init(frame: UIScreen.main.bounds)
        
        setupUI()
    }
    
    /// 显示
    ///
    /// - Parameters:
    ///   - title: 标题
    ///   - actions: 动作
    ///   - cancelHandler: 取消回调
    class func show(title: String?, actions: [BottomMenuAction], cancelHandler: HandlerBlock = nil) {
        BottomMenuView(title: title, actions: actions, cancelHandler: cancelHandler).showView()
    }
    
    // MARK: - lazy
    
    private lazy var coverView: UIView = {
        let v = UIView(frame: self.frame)
        v.alpha = 0.0
        let tap = UITapGestureRecognizer(target: self, action: #selector(cancelView))
        v.addGestureRecognizer(tap)
        v.backgroundColor = UIColor.black
        return v
    }()
    
    private lazy var contentView: UIView = {
        let v = UIView(frame: CGRect(x: 0, y: frame.height, width: frame.width, height: getContentHeight()))
        v.backgroundColor = kBgColor
        return v
    }()
    
    private lazy var titleView: UIView = {
        let height = getTitleViewHeight()

        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 13)
        titleLabel.textColor = UIColor.lightGray

        let v = UIView(frame: CGRect(x: 0, y: 0, width: frame.width, height: height))
        v.addSubview(titleLabel)
        v.backgroundColor = UIColor.white

        return v
    }()
    
    private lazy var tableView: UITableView = {
        let tableViewY = (title == nil ? 0 : getTitleViewHeight())
        let t = UITableView(frame: CGRect(x: 0, y: tableViewY, width: frame.width, height: getTableViewHeight()), style: .grouped)
        t.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        t.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0.01))
        t.dataSource = self
        t.delegate = self
        t.separatorColor = kBgColor
        t.separatorInset = UIEdgeInsets.zero
        t.isScrollEnabled = false
        t.rowHeight = kMenuCellHeight
        return t
    }()
    
    private lazy var cancelBtnView: UIView = {
        let v = UIView(frame: CGRect(x: 0, y: contentView.bounds.height - getCancelBtnViewHeight() , width: frame.width, height: getCancelBtnViewHeight()))
        v.backgroundColor = UIColor.white
        let b = UIButton(frame: CGRect(x: 0, y: 0, width: frame.width, height: 50))
        b.backgroundColor = UIColor.white
        b.setTitle("取消", for: .normal)
        b.setTitleColor(kTextColor, for: .normal)
        b.addTarget(self, action: #selector(self.cancelView), for: .touchUpInside)
        v.addSubview(b)
        return v
    }()
}

private extension BottomMenuView {
    private func setupUI() {
        addSubview(coverView)
        addSubview(contentView)
        if title != nil {
            contentView.addSubview(titleView)
        }
        contentView.addSubview(tableView)
        contentView.addSubview(cancelBtnView)
    }
    
    @objc func cancelView() {
        
        if cancelHandler != nil {
            cancelHandler!()
        }
    
        hideView()
    }
    
    func showView() {
        UIApplication.shared.keyWindow?.addSubview(self)
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.7, options: .curveEaseInOut, animations: {
            self.coverView.alpha = 0.4
            self.contentView.transform = CGAffineTransform(translationX: 0, y: -self.contentView.bounds.height)
        }, completion: nil)
    }
    
    func hideView() {
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.7, options: .curveEaseInOut, animations: {
            self.coverView.alpha = 0.0
            self.contentView.transform = CGAffineTransform.identity
        }, completion: { _ in
            self.removeFromSuperview()
        })
    }
    
    // MARK: - GET
    // 菜单的高度
    private func getContentHeight() -> CGFloat {
        return getTitleViewHeight() + getTableViewHeight() + getCancelBtnViewHeight() + kCancelBtnPadding
    }
    
    // 标题View的高度
    private func getTitleViewHeight() -> CGFloat {
        if let height = titleViewHeight {
            return height
        } else {
            if let t = title {
                titleLabel.text = t
                let labelSize = t.boundingRect(with: CGSize(width: kWidth - 2 * kLRPadding, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: titleLabel.font], context: nil).size
                let labelSize1 = "行数".boundingRect(with: CGSize(width: kWidth - 2 * kLRPadding, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: titleLabel.font], context: nil).size
                // 计算出Label的行数
                let numberLines = labelSize.height / labelSize1.height
                
                var padding = kTBPadding
                if numberLines > 1 {
                    padding = 0
                }
                
                let tHeight = labelSize.height + 2 * padding
                titleLabel.frame = CGRect(x: 20, y: padding, width: frame.width - 2 * 20, height: labelSize.height)
                
                titleViewHeight = tHeight
            } else {
                titleViewHeight = 0
            }
            
            return titleViewHeight!
        }
    }
    
    // TableView的高度
    private func getTableViewHeight() -> CGFloat {
        return CGFloat(self.actions.count) * kMenuCellHeight
    }
    
    // 取消View的高度
    private func getCancelBtnViewHeight() -> CGFloat {
        if isLiuhaiScreen() {
            return 50 + 24
        }
        return 50
    }
    
    /* 判断是否是刘海屏
    iOS判断刘海屏的方法：使用safeAreaInsets方法，当返回值为0时，为长方形，非0时即认为是iphone x，原理是判断是传统长方形还是圆角矩形。
     */
    private func isLiuhaiScreen() -> Bool {
        if #available(iOS 11.0, *) {
            return UIApplication.shared.windows[0].safeAreaInsets != UIEdgeInsets.zero
        } else {
            return false
        }
    }
}

extension BottomMenuView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.textAlignment = .center
        
        
        let action = actions[indexPath.row]
        cell.textLabel?.text = action.title
        
        switch action.style {
            case .default, .cancel:
                cell.textLabel?.textColor = kTextColor
            case .destructive:
                cell.textLabel?.textColor = UIColor.red
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let handler = actions[indexPath.row].handler
        if handler != nil {
            handler!()
        }
       
        self.hideView()
    }
}
