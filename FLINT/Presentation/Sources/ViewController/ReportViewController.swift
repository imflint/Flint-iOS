//
//  ReportViewController.swift
//  Presentation
//
//  Created by 소은 on 5/13/26.
//

import UIKit
import Combine

import View
import ViewModel

public final class ReportViewController: BaseViewController<ReportView> {
    
    // MARK: - Property
    
    private let viewModel: ReportViewModel
    
    private let radioSelectionSubject = PassthroughSubject<Int, Never>()
    private let textInputSubject = PassthroughSubject<String, Never>()
    private let submitButtonSubject = PassthroughSubject<Void, Never>()
    
    private var selectedRadioIndex: Int? {
        didSet {
            updateRadioButtons()
        }
    }
    
    // MARK: - Init
    
    public init(viewModel: ReportViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupTextViewObserver()
        setupActions()
        setupKeyboardDismiss()
    }
    
    // MARK: - Override
    
    public override func setUI() {
        view.backgroundColor = DesignSystem.Color.background
    }
    
    public override func bind() {
        let input = ReportViewModel.Input(
            radioSelected: radioSelectionSubject.eraseToAnyPublisher(),
            textInput: textInputSubject.eraseToAnyPublisher(),
            submitButtonTapped: submitButtonSubject.eraseToAnyPublisher()
        )
        
        let output = viewModel.transform(input: input)
        
        output.isSubmitEnabled
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isEnabled in
                self?.rootView.submitButton.isEnabled = isEnabled
            }
            .store(in: &cancellables)
        
        output.submitSuccess
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                print("신고 성공")
                self?.navigationController?.popViewController(animated: true)
            }
            .store(in: &cancellables)
        
        output.submitError
            .receive(on: DispatchQueue.main)
            .sink { error in
                print("신고 실패: \(error)")
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Setup
    
    private func setupNavigationBar() {
        setNavigationBar(.init(
            left: .none,
            title: "신고",
            right: .close
        ))
    }
    
    private func setupTextViewObserver() {
          NotificationCenter.default.addObserver(
              self,
              selector: #selector(textViewDidBeginEditing),
              name: UITextView.textDidBeginEditingNotification,
              object: rootView.textView
          )
      }
    
    private func setupActions() {
        for (index, button) in rootView.radioButtons.enumerated() {
            button.didTapCheckBox = { [weak self] _ in
                guard let self = self else { return }
                self.selectedRadioIndex = index
                self.radioSelectionSubject.send(index)
                
                if index != 4 {
                    self.rootView.textView.text = ""
                    self.rootView.textView.delegate?.textViewDidChange?(self.rootView.textView)
                    self.rootView.textLengthLabel.text = "0/200"
                    self.textInputSubject.send("")
                }
                
                self.rootView.textView.resignFirstResponder()
            }
        }
        
        rootView.textView.onLengthChanged = { [weak self] textLength, maxLength in
            self?.rootView.textLengthLabel.text = "\(textLength)/\(maxLength)"
            self?.textInputSubject.send(self?.rootView.textView.text ?? "")
        }
        
        rootView.submitButton.addAction(UIAction { [weak self] _ in
            self?.submitButtonSubject.send(())
        }, for: .touchUpInside)
    }
    
    private func setupKeyboardDismiss() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapToDismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Action
    
    @objc private func handleTapToDismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func textViewDidBeginEditing() {
        selectedRadioIndex = 4
        radioSelectionSubject.send(4)
    }
        
    
    // MARK: - Custom Method
    
    private func updateRadioButtons() {
        for (index, button) in rootView.radioButtons.enumerated() {
            button.configure(isSelected: selectedRadioIndex == index)
        }
    }
}
