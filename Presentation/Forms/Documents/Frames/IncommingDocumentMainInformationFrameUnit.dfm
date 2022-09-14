inherited IncommingDocumentMainInformationFrame: TIncommingDocumentMainInformationFrame
  Height = 237
  ExplicitHeight = 237
  inherited ScrollBox: TScrollBox
    Height = 237
    ExplicitHeight = 237
    inherited DocumentInfoPanel: TPanel
      Height = 233
      ExplicitHeight = 233
      inherited DocumentNumberLabel: TLabel
        Left = 8
        Top = 34
        Width = 59
        Anchors = [akLeft, akTop, akRight]
        Caption = #1048#1089#1093'. '#1085#1086#1084#1077#1088':'
        ExplicitLeft = 8
        ExplicitTop = 34
        ExplicitWidth = 59
      end
      inherited DocumentCreationDateLabel: TLabel
        Left = 310
        Top = 34
        Anchors = [akLeft, akTop, akRight]
        ExplicitLeft = 310
        ExplicitTop = 34
      end
      inherited DocumentNameLabel: TLabel
        Left = 544
        Top = 10
        ExplicitLeft = 544
        ExplicitTop = 10
      end
      inherited DocumentContentLabel: TLabel
        Left = 544
        Top = 56
        ExplicitLeft = 544
        ExplicitTop = 56
      end
      inherited DocumentNoteLabel: TLabel
        Left = 544
        Top = 181
        ExplicitLeft = 544
        ExplicitTop = 181
      end
      inherited PerformerLabel: TLabel
        Top = 91
        ExplicitTop = 91
      end
      inherited PerformerTelephoneNumberLabel: TLabel
        Left = 358
        Top = 113
        ExplicitLeft = 358
        ExplicitTop = 113
      end
      inherited DocumentSignerLabel: TLabel
        Top = 151
        ExplicitTop = 151
      end
      object IncomingDocumentNumberLabel: TLabel [9]
        Left = 8
        Top = 61
        Width = 53
        Height = 13
        Caption = #1042#1093'. '#1085#1086#1084#1077#1088':'
      end
      inherited NameWhoSignedLabel: TLabel
        Left = 77
        Top = 200
        ExplicitLeft = 77
        ExplicitTop = 200
      end
      inherited SignedLabel: TLabel
        Left = 12
        Top = 200
        ExplicitLeft = 12
        ExplicitTop = 200
      end
      inherited SignerNameAndSigningDateSeparator: TLabel
        Left = 162
        Top = 200
        ExplicitLeft = 162
        ExplicitTop = 200
      end
      inherited SigningDateLabel: TLabel
        Left = 188
        Top = 200
        ExplicitLeft = 188
        ExplicitTop = 200
      end
      inherited DocumentCreationDateTimePicker: TDateTimePicker
        Left = 331
        Top = 32
        Anchors = [akLeft, akTop, akRight]
        ExplicitLeft = 331
        ExplicitTop = 32
      end
      inherited DocumentNumberDepartmentCodePartEdit: TRegExprValidateEdit
        Left = 103
        Top = 34
        Anchors = [akLeft, akTop, akRight]
        ExplicitLeft = 103
        ExplicitTop = 34
      end
      inherited DocumentNumberOrderPartEdit: TRegExprValidateEdit
        Left = 184
        Top = 34
        Width = 112
        Anchors = [akLeft, akTop, akRight]
        ExplicitLeft = 184
        ExplicitTop = 34
        ExplicitWidth = 112
      end
      inherited DocumentTypeEdit: TRegExprValidateEdit
        Left = 103
        Width = 233
        Anchors = [akLeft, akTop, akRight]
        ExplicitLeft = 103
        ExplicitWidth = 233
      end
      inherited DocumentNameEdit: TRegExprValidateEdit
        Left = 544
        Top = 29
        Width = 258
        ExplicitLeft = 544
        ExplicitTop = 29
        ExplicitWidth = 258
      end
      inherited DocumentNoteMemo: TRegExprValidateMemo
        Left = 544
        Top = 198
        Width = 258
        Height = 30
        ExplicitLeft = 544
        ExplicitTop = 198
        ExplicitWidth = 258
        ExplicitHeight = 30
      end
      inherited DocumentContentMemo: TRegExprValidateRichEdit
        Left = 544
        Top = 75
        Width = 258
        Height = 100
        ExplicitLeft = 544
        ExplicitTop = 75
        ExplicitWidth = 258
        ExplicitHeight = 100
      end
      inherited DocumentIsSelfRegisteredCheckBox: TCheckBox
        TabOrder = 18
      end
      inherited PerformerDepartmentCodeEdit: TRegExprValidateEdit
        Left = 135
        Top = 88
        ExplicitLeft = 135
        ExplicitTop = 88
      end
      inherited PerformerDepartmentShortNameEdit: TRegExprValidateEdit
        Left = 200
        Top = 88
        ExplicitLeft = 200
        ExplicitTop = 88
      end
      inherited PerformerFullNameEdit: TRegExprValidateEdit
        Left = 103
        Top = 113
        Width = 249
        ExplicitLeft = 103
        ExplicitTop = 113
        ExplicitWidth = 249
      end
      inherited ChooseDocumentPerformerButton: TcxButton
        Left = 103
        Top = 88
        ExplicitLeft = 103
        ExplicitTop = 88
      end
      inherited SignerDepartmentShortNameEdit: TRegExprValidateEdit [26]
        Left = 200
        Top = 148
        TabOrder = 13
        ExplicitLeft = 200
        ExplicitTop = 148
      end
      inherited SignerDepartmentCodeEdit: TRegExprValidateEdit [27]
        Left = 135
        Top = 148
        TabOrder = 17
        ExplicitLeft = 135
        ExplicitTop = 148
      end
      object IncomingDocumentDepartmentCodePartOfNumberEdit: TRegExprValidateEdit [28]
        Left = 103
        Top = 61
        Width = 75
        Height = 21
        TabOrder = 16
        InvalidColor = 10520575
        RegularExpression = '.*'
      end
      object IncomingDocumentReferenceNumberOfNumberEdit: TRegExprValidateEdit [29]
        Left = 184
        Top = 61
        Width = 112
        Height = 21
        TabOrder = 15
        InvalidColor = 10520575
        RegularExpression = '.*'
      end
      inherited SignerNameEdit: TRegExprValidateEdit [30]
        Left = 103
        Top = 173
        Width = 249
        TabOrder = 14
        ExplicitLeft = 103
        ExplicitTop = 173
        ExplicitWidth = 249
      end
      inherited PerformerTelephoneNumberEdit: TRegExprValidateEdit [31]
        Left = 388
        Top = 113
        ExplicitLeft = 388
        ExplicitTop = 113
      end
      inherited SignerChooseButton: TcxButton
        Left = 103
        Top = 148
        ExplicitLeft = 103
        ExplicitTop = 148
      end
    end
  end
end
