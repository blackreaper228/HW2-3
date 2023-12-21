import UIKit

final class WishStoringViewController: UIViewController {
    private var tableView: UITableView!
    private var wishArray: [String] = ["I wish to add cells to the table"]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        configureTable()
    }

    private func configureTable() {
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        tableView.backgroundColor = .red

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        tableView.dataSource = self
        tableView.register(AddWishCell.self, forCellReuseIdentifier: AddWishCell.Constants.reuseId)
        tableView.register(WrittenWishCell.self, forCellReuseIdentifier: WrittenWishCell.Constants.reuseId)
    }
}

extension WishStoringViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return wishArray.count
        default: return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: AddWishCell.Constants.reuseId, for: indexPath) as! AddWishCell
            cell.addWish = { [weak self] wish in
                DispatchQueue.main.async {
                    self?.wishArray.append(wish)
                    self?.tableView.reloadData()
                }
            }
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: WrittenWishCell.Constants.reuseId, for: indexPath) as! WrittenWishCell
            cell.configure(with: wishArray[indexPath.row])
            return cell
        default:
            fatalError("Unexpected section")
        }
    }
}

final class WrittenWishCell: UITableViewCell {
    enum Constants {
        static let reuseId: String = "WrittenWishCell"
        static let wrapColor: UIColor = .white
        static let wrapRadius: CGFloat = 16
        static let wrapOffsetV: CGFloat = 5
        static let wrapOffsetH: CGFloat = 10
        static let wishLabelOffset: CGFloat = 8
    }

    private let wishLabel: UILabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with wish: String) {
        wishLabel.text = wish
    }

    private func configureUI() {
        selectionStyle = .none
        backgroundColor = .clear

        let wrap: UIView = UIView()
        wrap.translatesAutoresizingMaskIntoConstraints = false
        addSubview(wrap)
        wrap.backgroundColor = Constants.wrapColor
        wrap.layer.cornerRadius = Constants.wrapRadius

        NSLayoutConstraint.activate([
            wrap.topAnchor.constraint(equalTo: topAnchor, constant: Constants.wrapOffsetV),
            wrap.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.wrapOffsetV),
            wrap.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.wrapOffsetH),
            wrap.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.wrapOffsetH)
        ])

        wishLabel.translatesAutoresizingMaskIntoConstraints = false
        wrap.addSubview(wishLabel)

        NSLayoutConstraint.activate([
            wishLabel.topAnchor.constraint(equalTo: wrap.topAnchor, constant: Constants.wishLabelOffset),
            wishLabel.bottomAnchor.constraint(equalTo: wrap.bottomAnchor, constant: -Constants.wishLabelOffset),
            wishLabel.leadingAnchor.constraint(equalTo: wrap.leadingAnchor, constant: Constants.wishLabelOffset),
            wishLabel.trailingAnchor.constraint(equalTo: wrap.trailingAnchor, constant: -Constants.wishLabelOffset)
        ])
    }
}

class AddWishCell: UITableViewCell {
    enum Constants {
        static let reuseId = "AddWishCell"
        static let textViewTopInset: CGFloat = 8
        static let textViewHorizontalInset: CGFloat = 16
        static let addButtonTopInset: CGFloat = 8
        static let addButtonBottomInset: CGFloat = -8
        static let textViewHeight: CGFloat = 100
        static let addButtonHeight: CGFloat = 44
    }

    private let textView = UITextView()
    private let addButton = UIButton(type: .system)

    var addWish: ((String) -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .green
        textView.layer.cornerRadius = 10
        textView.clipsToBounds = true
        contentView.addSubview(textView)
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.textViewTopInset),
            textView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.textViewHorizontalInset),
            textView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.textViewHorizontalInset),
            textView.heightAnchor.constraint(equalToConstant: Constants.textViewHeight)
        ])

        addButton.setTitle("Добавить желание", for: .normal)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(addButton)
        NSLayoutConstraint.activate([
            addButton.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: Constants.addButtonTopInset),
            addButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.textViewHorizontalInset),
            addButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.textViewHorizontalInset),
            addButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: Constants.addButtonBottomInset),
            addButton.heightAnchor.constraint(equalToConstant: Constants.addButtonHeight)
        ])

        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
    }

    @objc private func addButtonTapped() {
        if let text = textView.text, !text.isEmpty {
            addWish?(text)
        }
    }

    func configure() {
        textView.text = ""
    }
}
