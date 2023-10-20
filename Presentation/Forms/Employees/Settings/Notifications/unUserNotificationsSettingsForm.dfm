inherited UserNotificationsSettingsForm: TUserNotificationsSettingsForm
  Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080' '#1087#1086#1095#1090#1086#1074#1099#1093' '#1086#1087#1086#1074#1077#1097#1077#1085#1080#1081
  ClientHeight = 526
  ClientWidth = 1005
  Position = poScreenCenter
  OnShow = FormShow
  ExplicitWidth = 1021
  ExplicitHeight = 565
  PixelsPerInch = 96
  TextHeight = 13
  inherited ButtonsFooterPanel: TPanel
    Top = 479
    Width = 1005
    ExplicitTop = 479
    ExplicitWidth = 1005
    inherited btnCancel: TcxButton
      Left = 916
      LookAndFeel.SkinName = ''
      ExplicitLeft = 916
    end
    inherited btnOK: TcxButton
      Left = 816
      LookAndFeel.SkinName = ''
      ExplicitLeft = 816
    end
  end
  object UserNotificationsSettingsFramePanel: TPanel
    Left = 0
    Top = 0
    Width = 1005
    Height = 460
    Align = alTop
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelOuter = bvNone
    TabOrder = 1
  end
end
