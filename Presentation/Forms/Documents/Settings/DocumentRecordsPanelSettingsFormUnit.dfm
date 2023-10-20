inherited DocumentRecordsPanelSettingsForm: TDocumentRecordsPanelSettingsForm
  Anchors = [akRight, akBottom]
  Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080' '#1087#1072#1085#1077#1083#1080' '#1079#1072#1087#1080#1089#1077#1081' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074
  ClientHeight = 68
  Constraints.MinHeight = 102
  Constraints.MinWidth = 434
  FormStyle = fsStayOnTop
  ExplicitWidth = 442
  ExplicitHeight = 107
  PixelsPerInch = 96
  TextHeight = 13
  object RecordGroupingByColumnsOptionCheckBox: TCheckBox
    Left = 16
    Top = 8
    Width = 313
    Height = 17
    Caption = #1042#1082#1083#1102#1095#1080#1090#1100' '#1074#1086#1079#1084#1086#1078#1085#1086#1089#1090#1100' '#1075#1088#1091#1087#1087#1080#1088#1086#1074#1082#1080' '#1079#1072#1087#1080#1089#1077#1081' '#1087#1086' '#1089#1090#1086#1083#1073#1094#1072#1084
    TabOrder = 0
  end
  object ApplySettingsButton: TcxButton
    Left = 254
    Top = 35
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = #1055#1088#1080#1084#1077#1085#1080#1090#1100
    Default = True
    TabOrder = 1
    OnClick = ApplySettingsButtonClick
  end
  object CloseButton: TcxButton
    Left = 343
    Top = 35
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = #1047#1072#1082#1088#1099#1090#1100
    TabOrder = 2
    OnClick = CloseButtonClick
  end
end
