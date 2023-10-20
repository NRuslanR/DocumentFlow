object DocumentApproversInfoForm: TDocumentApproversInfoForm
  Left = 0
  Top = 0
  Caption = 'DocumentApproversInfoForm'
  ClientHeight = 393
  ClientWidth = 603
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object DocumentApproversControlPanel: TPanel
    Left = 0
    Top = 0
    Width = 603
    Height = 43
    Align = alTop
    BevelEdges = [beTop]
    BevelKind = bkFlat
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 0
    object AddApproversButton: TcxButton
      Left = 16
      Top = 9
      Width = 161
      Height = 25
      Action = actAddApprovers
      TabOrder = 0
    end
    object RemoveApproversButton: TcxButton
      Left = 200
      Top = 9
      Width = 161
      Height = 25
      Action = actRemoveApprovers
      TabOrder = 1
    end
  end
  object DocumentApprovingsTreeList: TcxDBTreeList
    Left = 0
    Top = 43
    Width = 603
    Height = 350
    Align = alClient
    Bands = <
      item
      end>
    DataController.DataSource = DocumentApproversDataSource
    LookAndFeel.SkinName = 'UserSkin'
    OptionsCustomizing.ColumnsQuickCustomization = True
    OptionsSelection.HideFocusRect = False
    OptionsSelection.MultiSelect = True
    OptionsView.CellAutoHeight = True
    OptionsView.ColumnAutoWidth = True
    OptionsView.HeaderAutoHeight = True
    PopupMenu = ApproversControlPopupMenu
    RootValue = -1
    TabOrder = 1
    OnCustomDrawDataCell = DocumentApprovingsTreeListCustomDrawDataCell
    OnDblClick = DocumentApprovingsTreeListDblClick
    OnFocusedNodeChanged = DocumentApprovingsTreeListFocusedNodeChanged
    object ApproverNameColumn: TcxDBTreeListColumn
      Caption.AlignHorz = taCenter
      Caption.Text = #1060#1048#1054
      Options.Editing = False
      Width = 73
      Position.ColIndex = 2
      Position.RowIndex = 0
      Position.BandIndex = 0
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object RecordIdColumn: TcxDBTreeListColumn
      Visible = False
      Options.Customizing = False
      Options.Editing = False
      Position.ColIndex = 0
      Position.RowIndex = 0
      Position.BandIndex = 0
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object ApproverIdColumn: TcxDBTreeListColumn
      Visible = False
      Options.Customizing = False
      Position.ColIndex = 3
      Position.RowIndex = 0
      Position.BandIndex = 0
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object ApproverSpecialityColumn: TcxDBTreeListColumn
      Caption.AlignHorz = taCenter
      Caption.Text = #1044#1086#1083#1078#1085#1086#1089#1090#1100
      Options.Editing = False
      Width = 74
      Position.ColIndex = 1
      Position.RowIndex = 0
      Position.BandIndex = 0
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object ApproverDepartmentNameColumn: TcxDBTreeListColumn
      Caption.AlignHorz = taCenter
      Caption.Text = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
      Options.Editing = False
      Width = 93
      Position.ColIndex = 4
      Position.RowIndex = 0
      Position.BandIndex = 0
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object ApprovingPerformingResultIdColumn: TcxDBTreeListColumn
      Visible = False
      Options.Customizing = False
      Options.Editing = False
      Position.ColIndex = 5
      Position.RowIndex = 0
      Position.BandIndex = 0
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object ApprovingPerformingResultColumn: TcxDBTreeListColumn
      Caption.AlignHorz = taCenter
      Caption.Text = #1057#1090#1072#1090#1091#1089
      Options.Editing = False
      Width = 69
      Position.ColIndex = 7
      Position.RowIndex = 0
      Position.BandIndex = 0
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object ApprovingPerformingDateColumn: TcxDBTreeListColumn
      Caption.AlignHorz = taCenter
      Caption.Text = #1044#1072#1090#1072
      Options.Editing = False
      Width = 70
      Position.ColIndex = 6
      Position.RowIndex = 0
      Position.BandIndex = 0
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object ActuallyPerformedEmployeeIdColumn: TcxDBTreeListColumn
      Visible = False
      Options.Customizing = False
      Options.Editing = False
      Position.ColIndex = 8
      Position.RowIndex = 0
      Position.BandIndex = 0
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object ActuallyPerformedEmployeeColumn: TcxDBTreeListColumn
      Caption.AlignHorz = taCenter
      Caption.Text = #1042#1099#1087#1086#1083#1085#1080#1074#1096#1080#1081
      Options.Editing = False
      Width = 71
      Position.ColIndex = 9
      Position.RowIndex = 0
      Position.BandIndex = 0
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object NoteColumn: TcxDBTreeListColumn
      Caption.AlignHorz = taCenter
      Caption.Text = #1047#1072#1084#1077#1095#1072#1085#1080#1077
      Options.Editing = False
      Width = 69
      Position.ColIndex = 10
      Position.RowIndex = 0
      Position.BandIndex = 0
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object IsViewedByApproverColumn: TcxDBTreeListColumn
      Caption.AlignHorz = taCenter
      Caption.Text = #1055#1088#1086#1089#1084#1086#1090#1088#1077#1085#1086
      Options.Editing = False
      Width = 70
      Position.ColIndex = 11
      Position.RowIndex = 0
      Position.BandIndex = 0
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object TopLevelRecordIdColumn: TcxDBTreeListColumn
      Visible = False
      Options.Customizing = False
      Options.Editing = False
      Position.ColIndex = 12
      Position.RowIndex = 0
      Position.BandIndex = 0
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object CanBeChangedColumn: TcxDBTreeListColumn
      Visible = False
      Options.Customizing = False
      Options.Editing = False
      Position.ColIndex = 13
      Position.RowIndex = 0
      Position.BandIndex = 0
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object CanBeRemovedColumn: TcxDBTreeListColumn
      Visible = False
      Options.Customizing = False
      Options.Editing = False
      Position.ColIndex = 14
      Position.RowIndex = 0
      Position.BandIndex = 0
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object IsApprovingAccessibleColumn: TcxDBTreeListColumn
      Visible = False
      Options.Customizing = False
      Position.ColIndex = 15
      Position.RowIndex = 0
      Position.BandIndex = 0
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
  end
  object ApproversControlPopupMenu: TPopupMenu
    Left = 8
    Top = 360
    object mniAddApprovers: TMenuItem
      Action = actAddApprovers
    end
    object mniRemoveApprovers: TMenuItem
      Action = actRemoveApprovers
    end
  end
  object ApproverControlActionList: TActionList
    Left = 40
    Top = 360
    object actAddApprovers: TAction
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1086#1074
      OnExecute = actAddApproversExecute
    end
    object actRemoveApprovers: TAction
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1086#1074
      OnExecute = actRemoveApproversExecute
    end
    object actSaveChanges: TAction
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1080#1079#1084#1077#1085#1077#1085#1080#1103
    end
  end
  object DocumentApproversDataSource: TDataSource
    Left = 72
    Top = 360
  end
end
