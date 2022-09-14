inherited EmployeesReferenceForm: TEmployeesReferenceForm
  Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1086#1074
  ClientWidth = 892
  Position = poMainFormCenter
  ExplicitTop = -101
  ExplicitWidth = 908
  PixelsPerInch = 96
  TextHeight = 13
  inherited DataOperationToolBar: TToolBar
    Width = 892
    Height = 38
    ExplicitWidth = 892
    ExplicitHeight = 38
    inherited SelectFilteredRecordsSeparator: TToolButton
      Left = 620
      Wrap = False
      ExplicitLeft = 620
      ExplicitHeight = 36
    end
    inherited PrintDataToolButton: TToolButton
      Left = 628
      Top = 2
      ExplicitLeft = 628
      ExplicitTop = 2
    end
    inherited ExportDataToolButton: TToolButton
      Left = 696
      Top = 2
      ExplicitLeft = 696
      ExplicitTop = 2
    end
    inherited ExportDataSeparator: TToolButton
      Left = 779
      Top = 2
      ExplicitLeft = 779
      ExplicitTop = 2
    end
    inherited ExitToolButton: TToolButton
      Left = 787
      Top = 2
      ExplicitLeft = 787
      ExplicitTop = 2
    end
  end
  inherited StatisticsInfoStatusBar: TStatusBar
    Width = 892
    ExplicitWidth = 892
  end
  inherited SearchByColumnPanel: TScrollBox
    Top = 60
    Width = 892
    ExplicitTop = 60
    ExplicitWidth = 892
    inherited btnPrevFoundOccurrence: TcxButton
      Top = 5
      LookAndFeel.SkinName = ''
      ExplicitTop = 5
    end
    inherited btnNextFoundOccurrence: TcxButton
      LookAndFeel.SkinName = ''
    end
  end
  inherited DataRecordMovingToolBar: TToolBar
    Top = 38
    Width = 892
    ExplicitTop = 38
    ExplicitWidth = 892
  end
  inherited ClientAreaPanel: TPanel
    Top = 91
    Width = 892
    Height = 570
    ExplicitTop = 91
    ExplicitWidth = 892
    ExplicitHeight = 570
    DesignSize = (
      892
      570)
    inherited DataLoadingCanceledPanel: TPanel
      Left = 113
      Top = 69
      ExplicitLeft = 113
      ExplicitTop = 69
    end
    inherited WaitDataLoadingPanel: TPanel
      Left = 66
      Top = 159
      ExplicitLeft = 66
      ExplicitTop = 159
    end
    inherited DataRecordGrid: TcxGrid
      Width = 892
      Height = 570
      ExplicitWidth = 892
      ExplicitHeight = 570
      inherited DataRecordGridTableView: TcxGridDBTableView
        DataController.DataModeController.SmartRefresh = True
        object IdColumn: TcxGridDBColumn [0]
          DataBinding.FieldName = 'id'
          Visible = False
          VisibleForCustomization = False
        end
        inherited IsSelectedColumn: TcxGridDBColumn
          Caption = #1042#1099#1073#1088#1072#1090#1100
          DataBinding.ValueType = 'Boolean'
        end
        object PersonnelNumberColumn: TcxGridDBColumn
          Caption = #1058#1072#1073#1077#1083#1100#1085#1099#1081' '#1085#1086#1084#1077#1088
          DataBinding.FieldName = 'personnel_number'
          Width = 72
        end
        object SurnameColumn: TcxGridDBColumn
          Caption = #1060#1072#1084#1080#1083#1080#1103
          DataBinding.FieldName = 'surname'
          SortIndex = 0
          SortOrder = soAscending
          Width = 95
        end
        object NameColumn: TcxGridDBColumn
          Caption = #1048#1084#1103
          DataBinding.FieldName = 'name'
          SortIndex = 1
          SortOrder = soAscending
          Width = 95
        end
        object PatronymicColumn: TcxGridDBColumn
          Caption = #1054#1090#1095#1077#1089#1090#1074#1086
          DataBinding.FieldName = 'patronymic'
          SortIndex = 2
          SortOrder = soAscending
          Width = 97
        end
        object SpecialityColumn: TcxGridDBColumn
          Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100
          DataBinding.FieldName = 'speciality'
          Width = 187
        end
        object DepartmentCodeColumn: TcxGridDBColumn
          Caption = #1050#1086#1076' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103
          DataBinding.FieldName = 'department_code'
          Width = 100
        end
        object DepartmentShortNameColumn: TcxGridDBColumn
          Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103
          DataBinding.FieldName = 'department_short_name'
          Width = 132
        end
        object TelephoneNumberColumn: TcxGridDBColumn
          Caption = #1058#1077#1083#1077#1092#1086#1085
          DataBinding.FieldName = 'telephone_number'
          Visible = False
          FooterAlignmentHorz = taCenter
          GroupSummaryAlignment = taCenter
          HeaderAlignmentHorz = taCenter
          HeaderGlyphAlignmentHorz = taCenter
        end
        object IsForeignColumn: TcxGridDBColumn
          Caption = #1042#1085#1077#1096#1085#1080#1081' ('#1069#1044#1054' '#1086#1090#1089#1091#1090#1089#1090#1074#1091#1077#1090')'
          DataBinding.FieldName = 'is_foreign'
          PropertiesClassName = 'TcxCheckBoxProperties'
          GroupSummaryAlignment = taCenter
          HeaderAlignmentHorz = taCenter
          HeaderGlyphAlignmentHorz = taCenter
          Width = 100
        end
      end
    end
  end
  inherited imgLstDisabled: TPngImageList
    Left = 0
    Top = 632
  end
  inherited imgLstEnabled: TPngImageList
    Left = 32
    Top = 632
  end
  inherited DataOperationActionList: TActionList
    Left = 64
    Top = 632
    inherited actAddData: TAction
      Enabled = False
      Visible = False
    end
    inherited actDeleteData: TAction
      Visible = False
    end
  end
  inherited DataOperationPopupMenu: TPopupMenu
    Left = 96
    Top = 632
  end
  inherited TargetDataSource: TDataSource
    Left = 128
    Top = 632
  end
  inherited ExportDataPopupMenu: TPopupMenu
    Left = 160
    Top = 632
  end
  inherited ExportDataDialog: TSaveDialog
    Left = 192
    Top = 632
  end
end
