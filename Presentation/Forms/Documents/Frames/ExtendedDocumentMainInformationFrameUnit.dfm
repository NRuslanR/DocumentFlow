inherited ExtendedDocumentMainInformationFrame: TExtendedDocumentMainInformationFrame
  Width = 825
  Height = 340
  ExplicitWidth = 825
  ExplicitHeight = 340
  inherited ScrollBox: TScrollBox
    Width = 825
    Height = 340
    ExplicitWidth = 825
    ExplicitHeight = 340
    inherited DocumentInfoPanel: TPanel
      Width = 819
      Height = 341
      OnResize = DocumentInfoPanelResize
      ExplicitWidth = 819
      ExplicitHeight = 341
      DesignSize = (
        819
        341)
      inherited DocumentNumberLabel: TLabel
        Left = 380
        ExplicitLeft = 380
      end
      inherited DocumentTypeLabel: TLabel
        Left = 8
        Top = 7
        ExplicitLeft = 8
        ExplicitTop = 7
      end
      inherited DocumentCreationDateLabel: TLabel
        Left = 597
        ExplicitLeft = 597
      end
      inherited DocumentNameLabel: TLabel
        Left = 12
        Top = 88
        ExplicitLeft = 12
        ExplicitTop = 88
      end
      inherited DocumentContentLabel: TLabel
        Left = 21
        Top = 115
        ExplicitLeft = 21
        ExplicitTop = 115
      end
      inherited DocumentNoteLabel: TLabel
        Left = 24
        Top = 207
        ExplicitLeft = 24
        ExplicitTop = 207
      end
      object PerformerLabel: TLabel [6]
        Left = 19
        Top = 34
        Width = 70
        Height = 13
        Caption = #1048#1089#1087#1086#1083#1085#1080#1090#1077#1083#1100':'
      end
      object PerformerTelephoneNumberLabel: TLabel [7]
        Left = 683
        Top = 37
        Width = 26
        Height = 13
        Anchors = [akTop, akRight]
        Caption = #1058#1077#1083'.:'
        ExplicitLeft = 649
      end
      object DocumentSignerLabel: TLabel [8]
        Left = 12
        Top = 61
        Width = 77
        Height = 13
        Caption = #1056#1091#1082#1086#1074#1086#1076#1080#1090#1077#1083#1100':'
      end
      object SigningDateTimeLabel: TLabel [9]
        Left = 357
        Top = 297
        Width = 93
        Height = 13
        Caption = #1044#1072#1090#1072' '#1087#1086#1076#1087#1080#1089#1072#1085#1080#1103':'
      end
      object ActualSignerNameLabel: TLabel [10]
        Left = 204
        Top = 261
        Width = 67
        Height = 13
        Anchors = [akTop, akRight]
        Caption = '_placeholder_'
        Visible = False
      end
      object SignedLabel: TLabel [11]
        Left = 36
        Top = 261
        Width = 53
        Height = 13
        Anchors = [akTop, akRight]
        Caption = #1055#1086#1076#1087#1080#1089#1072#1085':'
        Visible = False
      end
      object SignerNameAndSigningDateSeparator: TLabel [12]
        Left = 186
        Top = 261
        Width = 12
        Height = 13
        Anchors = [akTop, akRight]
        Caption = #1086#1090
        Visible = False
      end
      object SigningDateLabel: TLabel [13]
        Left = 113
        Top = 261
        Width = 67
        Height = 13
        Anchors = [akTop, akRight]
        Caption = '_placeholder_'
        Visible = False
      end
      object ProductCodeLabel: TLabel [15]
        Left = 379
        Top = 254
        Width = 79
        Height = 13
        Anchors = [akTop, akRight]
        Caption = #1064#1080#1092#1088' '#1080#1079#1076#1077#1083#1080#1103':'
      end
      inherited DocumentCreationDateTimePicker: TDateTimePicker
        Left = 624
        Width = 151
        ExplicitLeft = 624
        ExplicitWidth = 151
      end
      inherited DocumentNumberPrefixEdit: TRegExprValidateEdit
        Left = 421
        Width = 75
        ParentShowHint = False
        ShowHint = True
        ExplicitLeft = 421
        ExplicitWidth = 75
      end
      inherited DocumentNumberMainValueEdit: TRegExprValidateEdit
        Left = 503
        Width = 82
        ParentShowHint = False
        ShowHint = True
        ExplicitLeft = 503
        ExplicitWidth = 82
      end
      inherited DocumentTypeEdit: TRegExprValidateEdit
        Left = 95
        Width = 279
        ExplicitLeft = 95
        ExplicitWidth = 279
      end
      inherited DocumentNameEdit: TRegExprValidateEdit
        Left = 95
        Top = 88
        Width = 714
        ExplicitLeft = 95
        ExplicitTop = 88
        ExplicitWidth = 714
      end
      inherited DocumentNoteMemo: TRegExprValidateMemo
        Left = 95
        Top = 209
        Width = 714
        ExplicitLeft = 95
        ExplicitTop = 209
        ExplicitWidth = 714
      end
      inherited DocumentContentMemo: TRegExprValidateRichEdit
        Left = 95
        Top = 115
        Width = 714
        Height = 86
        ExplicitLeft = 95
        ExplicitTop = 115
        ExplicitWidth = 714
        ExplicitHeight = 86
      end
      inherited DocumentIsSelfRegisteredCheckBox: TCheckBox
        Left = 8
        Top = 298
        Width = 159
        TabOrder = 16
        ExplicitLeft = 8
        ExplicitTop = 298
        ExplicitWidth = 159
      end
      inherited DocumentDateTimePicker: TDateTimePicker
        Left = 669
        Top = 273
        TabOrder = 18
        ExplicitLeft = 669
        ExplicitTop = 273
      end
      object PerformerDepartmentCodeEdit: TRegExprValidateEdit
        Left = 127
        Top = 34
        Width = 59
        Height = 21
        ReadOnly = True
        TabOrder = 8
        InvalidColor = 10520575
        RegularExpression = '.+'
      end
      object PerformerDepartmentShortNameEdit: TRegExprValidateEdit
        Left = 193
        Top = 34
        Width = 158
        Height = 21
        ReadOnly = True
        TabOrder = 9
        InvalidColor = 10520575
        RegularExpression = '.+'
      end
      object PerformerFullNameEdit: TRegExprValidateEdit
        Left = 357
        Top = 34
        Width = 304
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        ReadOnly = True
        TabOrder = 10
        InvalidColor = 10520575
        RegularExpression = '.+'
      end
      object ChooseDocumentPerformerButton: TcxButton
        Left = 95
        Top = 34
        Width = 33
        Height = 21
        Caption = '...'
        TabOrder = 7
        OnClick = ChooseDocumentPerformerButtonClick
      end
      object PerformerTelephoneNumberEdit: TRegExprValidateEdit
        Left = 712
        Top = 34
        Width = 97
        Height = 21
        Anchors = [akTop, akRight]
        TabOrder = 11
        InvalidHint = #1048#1089#1087#1086#1083#1085#1080#1090#1077#1083#1100' '#1076#1086#1083#1078#1077#1085' '#1080#1084#1077#1090#1100' '#1090#1077#1083#1077#1092#1086#1085
        InvalidColor = 10520575
        RegularExpression = '.+'
      end
      object SignerNameEdit: TRegExprValidateEdit
        Left = 357
        Top = 61
        Width = 304
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        ReadOnly = True
        TabOrder = 15
        InvalidColor = 10520575
        RegularExpression = '.+'
      end
      object SignerDepartmentShortNameEdit: TRegExprValidateEdit
        Left = 193
        Top = 61
        Width = 158
        Height = 21
        ReadOnly = True
        TabOrder = 14
        InvalidColor = 10520575
        RegularExpression = '.+'
      end
      object SignerDepartmentCodeEdit: TRegExprValidateEdit
        Left = 127
        Top = 61
        Width = 59
        Height = 21
        TabOrder = 13
        InvalidColor = 10520575
        RegularExpression = '.+'
      end
      object SignerChooseButton: TcxButton
        Left = 95
        Top = 61
        Width = 33
        Height = 21
        Caption = '...'
        TabOrder = 12
        OnClick = SignerChooseButtonClick
      end
      object SigningDateTimePicker: TDateTimePicker
        Left = 461
        Top = 298
        Width = 186
        Height = 21
        Date = 44231.382833217590000000
        Time = 44231.382833217590000000
        TabOrder = 17
      end
      object ProductCodeEdit: TRegExprValidateEdit
        Left = 464
        Top = 254
        Width = 121
        Height = 21
        Anchors = [akTop, akRight]
        TabOrder = 19
        InvalidHint = #1064#1080#1092#1088' '#1080#1079#1076#1077#1083#1080#1103' '#1076#1086#1083#1078#1077#1085' '#1073#1099#1090#1100' '#1095#1080#1089#1083#1086#1074#1099#1084
        InvalidColor = 10520575
        RegularExpression = '^(\s*|\d+)$'
      end
    end
  end
end
