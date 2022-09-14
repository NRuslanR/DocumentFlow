inherited PersonnelOrderMainInformationFrame: TPersonnelOrderMainInformationFrame
  Height = 326
  ExplicitHeight = 326
  inherited ScrollBox: TScrollBox
    Height = 326
    ExplicitHeight = 326
    inherited DocumentInfoPanel: TPanel
      Height = 323
      ExplicitHeight = 323
      inherited DocumentNameLabel: TLabel
        Top = 115
        ExplicitTop = 115
      end
      inherited DocumentContentLabel: TLabel
        Top = 144
        ExplicitTop = 144
      end
      inherited DocumentNoteLabel: TLabel
        Top = 235
        ExplicitTop = 235
      end
      inherited PerformerLabel: TLabel
        Top = 61
        ExplicitTop = 61
      end
      inherited PerformerTelephoneNumberLabel: TLabel
        Left = 646
        Top = 61
        ExplicitLeft = 646
        ExplicitTop = 61
      end
      inherited DocumentSignerLabel: TLabel
        Left = 30
        Top = 88
        Width = 59
        Caption = #1055#1086#1076#1087#1080#1089#1072#1085#1090':'
        ExplicitLeft = 30
        ExplicitTop = 88
        ExplicitWidth = 59
      end
      inherited SigningDateTimeLabel: TLabel
        Top = 280
        ExplicitTop = 280
      end
      object PersonnelOrderSubKindLabel: TLabel [10]
        Left = 47
        Top = 34
        Width = 42
        Height = 13
        Caption = #1055#1086#1076#1090#1080#1087':'
      end
      inherited DocumentNumberPrefixEdit: TRegExprValidateEdit
        Visible = False
      end
      inherited DocumentNumberMainValueEdit: TRegExprValidateEdit
        ReadOnly = True
      end
      inherited DocumentNameEdit: TRegExprValidateEdit
        Top = 115
        ExplicitTop = 115
      end
      inherited DocumentNoteMemo: TRegExprValidateMemo
        Top = 235
        ExplicitTop = 235
      end
      inherited DocumentContentMemo: TRegExprValidateRichEdit
        Top = 144
        RegularExpression = '.*'
        ExplicitTop = 144
      end
      inherited DocumentIsSelfRegisteredCheckBox: TCheckBox
        Top = 280
        Visible = False
        ExplicitTop = 280
      end
      inherited DocumentDateTimePicker: TDateTimePicker
        TabOrder = 20
      end
      inherited PerformerDepartmentCodeEdit: TRegExprValidateEdit
        Top = 61
        ExplicitTop = 61
      end
      inherited PerformerDepartmentShortNameEdit: TRegExprValidateEdit
        Top = 61
        ExplicitTop = 61
      end
      inherited PerformerFullNameEdit: TRegExprValidateEdit
        Top = 61
        ExplicitTop = 61
      end
      inherited ChooseDocumentPerformerButton: TcxButton
        Top = 61
        ExplicitTop = 61
      end
      inherited PerformerTelephoneNumberEdit: TRegExprValidateEdit
        Top = 61
        ExplicitTop = 61
      end
      inherited SignerNameEdit: TRegExprValidateEdit
        Top = 88
        ExplicitTop = 88
      end
      inherited SignerDepartmentShortNameEdit: TRegExprValidateEdit
        Top = 88
        ExplicitTop = 88
      end
      inherited SignerDepartmentCodeEdit: TRegExprValidateEdit
        Top = 88
        ExplicitTop = 88
      end
      inherited SignerChooseButton: TcxButton
        Top = 88
        ExplicitTop = 88
      end
      inherited SigningDateTimePicker: TDateTimePicker
        Top = 280
        ExplicitTop = 280
      end
      object PersonnelOrderSubKindEdit: TRegExprValidateEdit
        Left = 127
        Top = 34
        Width = 648
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        ReadOnly = True
        TabOrder = 18
        InvalidHint = #1053#1077#1086#1073#1093#1086#1076#1080#1084#1086' '#1074#1099#1073#1088#1072#1090#1100' '#1087#1086#1076#1090#1080#1087' '#1082#1072#1076#1088#1086#1074#1086#1075#1086' '#1087#1088#1080#1082#1072#1079#1072
        InvalidColor = 10520575
        RegularExpression = '.+'
      end
      object PersonnelOrderSubKindChooseButton: TcxButton
        Left = 95
        Top = 34
        Width = 33
        Height = 21
        Caption = '...'
        TabOrder = 19
        OnClick = PersonnelOrderSubKindChooseButtonClick
      end
    end
  end
end
