object UserNotificationsSettingsFrame: TUserNotificationsSettingsFrame
  Left = 0
  Top = 0
  Width = 789
  Height = 530
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  ParentFont = False
  TabOrder = 0
  TabStop = True
  DesignSize = (
    789
    530)
  object NotificationsReceivingEnabledCheckBox: TCheckBox
    Left = 24
    Top = 16
    Width = 209
    Height = 17
    Caption = #1055#1086#1083#1091#1095#1072#1090#1100' '#1087#1086#1095#1090#1086#1074#1099#1077' '#1086#1087#1086#1074#1077#1097#1077#1085#1080#1103
    TabOrder = 1
  end
  object OwnNotificationsReceivingUsersLayoutControl: TdxLayoutControl
    Left = 24
    Top = 39
    Width = 741
    Height = 469
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 0
    TabStop = False
    AutoSize = True
    LayoutLookAndFeel = dxLayoutStandardLookAndFeel1
    object OwnNotificationsReceivingUsersFormPanel: TPanel
      Left = 12
      Top = 20
      Width = 717
      Height = 437
      Align = alClient
      BevelOuter = bvNone
      Color = clWhite
      TabOrder = 0
    end
    object OwnNotificationsReceivingUsersLayoutControlGroup_Root: TdxLayoutGroup
      AlignHorz = ahClient
      AlignVert = avClient
      LayoutLookAndFeel = dxLayoutStandardLookAndFeel1
      ButtonOptions.Buttons = <>
      Hidden = True
      ShowBorder = False
      object OwnNotificationsReceivingUsersLayoutControlGroup1: TdxLayoutGroup
        AlignHorz = ahClient
        AlignVert = avClient
        CaptionOptions.Text = #1057#1086#1090#1088#1091#1076#1085#1080#1082#1080', '#1082#1086#1090#1086#1088#1099#1077' '#1073#1091#1076#1091#1090' '#1087#1086#1083#1091#1095#1072#1090#1100' '#1042#1072#1096#1080' '#1087#1086#1095#1090#1086#1074#1099#1077' '#1091#1074#1077#1076#1086#1084#1083#1077#1085#1080#1103
        SizeOptions.AssignedValues = [sovSizableHorz]
        SizeOptions.SizableHorz = False
        ButtonOptions.Buttons = <>
        ButtonOptions.ShowExpandButton = True
        object OwnNotificationsReceivingUsersLayoutControlItem1: TdxLayoutItem
          AlignHorz = ahClient
          AlignVert = avClient
          CaptionOptions.Visible = False
          Control = OwnNotificationsReceivingUsersFormPanel
          ControlOptions.AutoColor = True
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
  object dxLayoutLookAndFeelList1: TdxLayoutLookAndFeelList
    Left = 312
    Top = 8
    object dxLayoutStandardLookAndFeel1: TdxLayoutStandardLookAndFeel
      GroupOptions.Color = clWhite
      Offsets.ControlOffsetHorz = 0
      Offsets.ControlOffsetVert = 0
      Offsets.ItemOffset = 0
      Offsets.RootItemsAreaOffsetHorz = 0
      Offsets.RootItemsAreaOffsetVert = 0
    end
  end
end
