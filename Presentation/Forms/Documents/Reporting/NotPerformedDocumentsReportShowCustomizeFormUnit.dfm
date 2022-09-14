object NotPerformedDocumentsReportShowCustomizeForm: TNotPerformedDocumentsReportShowCustomizeForm
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = #1060#1086#1088#1084#1080#1088#1086#1074#1072#1085#1080#1077' '#1086#1090#1095#1105#1090#1072' '#1086' '#1085#1077#1074#1099#1087#1086#1083#1085#1077#1085#1085#1099#1093' '#1076#1086#1082#1091#1084#1077#1085#1090#1072#1093
  ClientHeight = 90
  ClientWidth = 531
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 87
    Height = 13
    Caption = #1053#1072#1095#1072#1083#1086' '#1087#1077#1088#1080#1086#1076#1072':'
  end
  object Label2: TLabel
    Left = 273
    Top = 8
    Width = 81
    Height = 13
    Caption = #1050#1086#1085#1077#1094' '#1087#1077#1088#1080#1086#1076#1072':'
  end
  object DepartmentLabel: TLabel
    Left = 8
    Top = 40
    Width = 84
    Height = 13
    Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077':'
  end
  object PeriodStartPicker: TDateTimePicker
    Left = 101
    Top = 8
    Width = 140
    Height = 21
    Date = 43613.368029386580000000
    Time = 43613.368029386580000000
    TabOrder = 0
  end
  object PeriodEndPicker: TDateTimePicker
    Left = 360
    Top = 8
    Width = 161
    Height = 21
    Date = 43613.368231226850000000
    Time = 43613.368231226850000000
    TabOrder = 1
  end
  object FormReportButton: TcxButton
    Left = 333
    Top = 55
    Width = 99
    Height = 25
    Caption = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100
    TabOrder = 2
    OnClick = FormReportButtonClick
  end
  object CloseButton: TcxButton
    Left = 446
    Top = 55
    Width = 75
    Height = 25
    Caption = #1047#1072#1082#1088#1099#1090#1100
    TabOrder = 3
    OnClick = CloseButtonClick
  end
  object DepartmentsComboBox: TComboBox
    Left = 8
    Top = 59
    Width = 233
    Height = 21
    ItemHeight = 0
    TabOrder = 4
  end
end
