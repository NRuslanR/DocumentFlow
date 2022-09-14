object ApplicationMainForm: TApplicationMainForm
  Left = 0
  Top = 0
  Caption = 'ApplicationMainForm'
  ClientHeight = 862
  ClientWidth = 849
  Color = clBtnFace
  DefaultMonitor = dmMainForm
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu
  OldCreateOrder = True
  WindowState = wsMaximized
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 16
  object ActionList1: TActionList
    Left = 48
    Top = 8
    object actChangeFont: TAction
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1096#1088#1080#1092#1090'...'
      OnExecute = actChangeFontExecute
    end
    object actExitFromProgram: TAction
      Caption = #1042#1099#1081#1090#1080' '#1080#1079' '#1087#1088#1086#1075#1088#1072#1084#1084#1099
      OnExecute = actExitFromProgramExecute
    end
    object actCreateNotPerformedDocumentsReport: TAction
      Caption = #1053#1077#1074#1099#1087#1086#1083#1085#1077#1085#1085#1099#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1099
      OnExecute = actCreateNotPerformedDocumentsReportExecute
    end
    object actShowDocumentRecordsPanelSettingsForm: TAction
      Caption = #1055#1072#1085#1077#1083#1100' '#1079#1072#1087#1080#1089#1077#1081' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074'...'
      OnExecute = actShowDocumentRecordsPanelSettingsFormExecute
    end
    object actAdministration: TAction
      Caption = #1040#1076#1084#1080#1085#1080#1089#1090#1088#1080#1088#1086#1074#1072#1085#1080#1077
      Visible = False
      OnExecute = actAdministrationExecute
    end
    object actResetAppSettings: TAction
      Caption = #1057#1073#1088#1086#1089#1080#1090#1100' '#1085#1072#1089#1090#1088#1086#1081#1082#1080' '#1087#1088#1086#1075#1088#1072#1084#1084#1099
      OnExecute = actResetAppSettingsExecute
    end
    object actMailNotifications: TAction
      Caption = #1055#1086#1095#1090#1086#1074#1099#1077' '#1091#1074#1077#1076#1086#1084#1083#1077#1085#1080#1103'...'
      OnExecute = actMailNotificationsExecute
    end
    object actSetNewUI: TAction
      Caption = #1053#1086#1074#1099#1081
      Checked = True
      OnExecute = actSetNewUIExecute
    end
    object actSetOldUI: TAction
      Caption = #1057#1090#1072#1088#1099#1081
      Checked = True
      OnExecute = actSetOldUIExecute
    end
    object actOpenVersionsList: TAction
      Caption = #1057#1087#1080#1089#1086#1082' '#1080#1079#1084#1077#1085#1077#1085#1080#1081
      OnExecute = actOpenVersionsListExecute
    end
  end
  object MainMenu: TMainMenu
    Left = 8
    Top = 8
    object FileMenuItem: TMenuItem
      Caption = #1060#1072#1081#1083
      object N3: TMenuItem
        Action = actExitFromProgram
      end
      object N8: TMenuItem
        Action = actOpenVersionsList
      end
    end
    object SettingsMenuItem: TMenuItem
      Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080
      object N4: TMenuItem
        Action = actChangeFont
      end
      object N5: TMenuItem
        Action = actShowDocumentRecordsPanelSettingsForm
      end
      object N7: TMenuItem
        Action = actMailNotifications
      end
      object N6: TMenuItem
        Action = actResetAppSettings
      end
      object UserInterfaceMenuItem: TMenuItem
        Caption = #1048#1085#1090#1077#1088#1092#1077#1081#1089
        object SetOldUITool: TMenuItem
          Action = actSetOldUI
          AutoCheck = True
          RadioItem = True
        end
        object SetNewUITool: TMenuItem
          Action = actSetNewUI
          AutoCheck = True
          RadioItem = True
        end
      end
    end
    object N1: TMenuItem
      Caption = #1054#1090#1095#1105#1090#1099
      object N2: TMenuItem
        Action = actCreateNotPerformedDocumentsReport
      end
    end
    object AdministrationMenu: TMenuItem
      Action = actAdministration
    end
  end
end
