inherited DocumentApprovingCyclesReferenceForm: TDocumentApprovingCyclesReferenceForm
  Caption = 'DocumentApprovingCyclesReferenceForm'
  ExplicitWidth = 769
  ExplicitHeight = 719
  PixelsPerInch = 96
  TextHeight = 13
  inherited DataOperationToolBar: TToolBar
    Height = 80
    EdgeBorders = [ebTop]
    EdgeOuter = esLowered
    ExplicitHeight = 80
    inherited ChooseRecordsSeparator: TToolButton
      Visible = False
    end
    inherited ReserveToolButton1: TToolButton
      Action = actCompleteApproving
    end
    inherited SelectFilteredRecordsSeparator: TToolButton
      Visible = False
      ExplicitHeight = 36
    end
    inherited ExportDataToolButton: TToolButton
      ExplicitWidth = 83
    end
    inherited ExportDataSeparator: TToolButton
      Visible = False
    end
  end
  inherited StatisticsInfoStatusBar: TStatusBar
    Visible = False
  end
  inherited SearchByColumnPanel: TScrollBox
    Top = 102
    Visible = False
    ExplicitTop = 102
    inherited btnPrevFoundOccurrence: TcxButton
      LookAndFeel.SkinName = ''
    end
    inherited btnNextFoundOccurrence: TcxButton
      LookAndFeel.SkinName = ''
    end
  end
  inherited DataRecordMovingToolBar: TToolBar
    Top = 80
    ExplicitTop = 80
    inherited FirstDataRecordToolButton: TToolButton
      ExplicitWidth = 24
    end
    inherited PrevDataRecordToolButton: TToolButton
      ExplicitWidth = 24
    end
    inherited NextDataRecordToolButton: TToolButton
      ExplicitWidth = 24
    end
    inherited LastDataRecordToolButton: TToolButton
      ExplicitWidth = 24
    end
  end
  inherited ClientAreaPanel: TPanel
    Top = 133
    Height = 528
    ExplicitTop = 133
    ExplicitHeight = 528
    inherited WaitDataLoadingPanel: TPanel
      Top = 143
      ExplicitTop = 143
    end
    inherited DataRecordGrid: TcxGrid
      Height = 528
      ExplicitHeight = 528
      inherited DataRecordGridTableView: TcxGridDBTableView
        DataController.KeyFieldNames = 'cycle_number'
        OptionsSelection.CellSelect = False
        OptionsView.GroupByBox = False
        object ApprovingCycleNumberColumn: TcxGridDBColumn
          Caption = #1053#1086#1084#1077#1088
          DataBinding.FieldName = 'cycle_number'
          Visible = False
          Options.Editing = False
          SortIndex = 0
          SortOrder = soDescending
        end
        object ApprovingCycleNameColumn: TcxGridDBColumn
          Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
          DataBinding.FieldName = 'cycle_name'
          HeaderAlignmentHorz = taCenter
        end
        object ApprovingCycleIdColumn: TcxGridDBColumn
          DataBinding.FieldName = 'cycle_id'
          Visible = False
          VisibleForCustomization = False
        end
        object ApprovingCycleIsNewColumn: TcxGridDBColumn
          DataBinding.FieldName = 'is_new'
          Visible = False
          VisibleForCustomization = False
        end
        object CanBeChangedColumn: TcxGridDBColumn
          DataBinding.FieldName = 'can_be_changed'
          Visible = False
          VisibleForCustomization = False
        end
        object CanBeRemovedColumn: TcxGridDBColumn
          DataBinding.FieldName = 'can_be_removed'
          Visible = False
          VisibleForCustomization = False
        end
        object CanBeCompletedColumn: TcxGridDBColumn
          DataBinding.FieldName = 'can_be_completed'
          Visible = False
          VisibleForCustomization = False
        end
      end
      object DocumentApprovingsDetailTableView: TcxGridDBTableView [1]
        NavigatorButtons.ConfirmDelete = False
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <>
        DataController.Summary.SummaryGroups = <>
        object PerformerSpecialityColumn: TcxGridDBColumn
          Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100
          DataBinding.FieldName = 'performer_speciality'
        end
        object PerformerNameColumn: TcxGridDBColumn
          Caption = #1060#1048#1054
          DataBinding.FieldName = 'performer_name'
        end
        object PerformerDepartmentNameColumn: TcxGridDBColumn
          Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
          DataBinding.FieldName = 'performer_department_name'
        end
        object PerformingResultColumn: TcxGridDBColumn
          Caption = #1057#1090#1072#1090#1091#1089
          DataBinding.FieldName = 'performing_result'
        end
        object PerformingDateColumn: TcxGridDBColumn
          Caption = #1044#1072#1090#1072
          DataBinding.FieldName = 'performing_date'
        end
        object ActualPerformerNameColumn: TcxGridDBColumn
          Caption = #1060#1072#1082#1090#1080#1095#1077#1089#1082#1080' '#1074#1099#1087#1086#1083#1085#1080#1074#1096#1080#1081
          DataBinding.FieldName = 'actual_performer_name'
        end
        object NoteColumn: TcxGridDBColumn
          Caption = #1047#1072#1084#1077#1095#1072#1085#1080#1077
          DataBinding.FieldName = 'note'
        end
        object IsViewedByPerformerColumn: TcxGridDBColumn
          DataBinding.FieldName = 'is_viewed_by_performer'
          Visible = False
          VisibleForCustomization = False
        end
        object IdColumn: TcxGridDBColumn
          DataBinding.FieldName = 'approving_id'
          Visible = False
          VisibleForCustomization = False
        end
        object PerformerIdColumn: TcxGridDBColumn
          DataBinding.FieldName = 'performer_id'
          Visible = False
          VisibleForCustomization = False
        end
        object PerformingResultIdColumn: TcxGridDBColumn
          DataBinding.FieldName = 'performing_result_id'
          Visible = False
          VisibleForCustomization = False
        end
        object ActualPerformerIdColumn: TcxGridDBColumn
          DataBinding.FieldName = 'actual_performer_id'
          Visible = False
          VisibleForCustomization = False
        end
        object DocumentApprovingCycleNumberColumn: TcxGridDBColumn
          DataBinding.FieldName = 'cycle_number'
          Visible = False
          VisibleForCustomization = False
        end
      end
      inherited DataRecordGridLevel: TcxGridLevel
        Caption = #1062#1080#1082#1083
      end
    end
  end
  inherited DataOperationActionList: TActionList
    inherited actAddData: TAction
      Caption = #1057#1086#1079#1076#1072#1090#1100
      Hint = #1057#1086#1079#1076#1072#1090#1100' '#1085#1086#1074#1099#1081' '#1094#1080#1082#1083
    end
    inherited actDeleteData: TAction [1]
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1094#1080#1082#1083
    end
    object actCompleteApproving: TAction [2]
      Caption = #1047#1072#1074#1077#1088#1096#1080#1090#1100
      Hint = #1047#1072#1074#1077#1088#1096#1080#1090#1100' '#1094#1080#1082#1083
      ImageIndex = 6
      OnExecute = actCompleteApprovingExecute
    end
    inherited actCopySelectedDataRecords: TAction [3]
    end
    inherited actCopySelectedDataRecordCell: TAction [4]
      Visible = False
    end
    inherited actChangeData: TAction [5]
    end
    inherited actRefreshData: TAction
      Visible = False
    end
    inherited actSelectFilteredData: TAction
      Visible = False
    end
    inherited actExportData: TAction
      Visible = False
    end
    inherited actPrevDataRecord: TAction
      Visible = False
    end
    inherited actFirstDataRecord: TAction
      Visible = False
    end
    inherited actLastDataRecord: TAction
      Visible = False
    end
    inherited actNextDataRecord: TAction
      Visible = False
    end
    inherited actExportDataToXLS: TAction
      Visible = False
    end
    inherited actExportDataToXML: TAction
      Visible = False
    end
    inherited actExportDataToHTML: TAction
      Visible = False
    end
    inherited actChooseRecords: TAction
      Visible = False
    end
    inherited actNextFoundOccurrence: TAction
      Visible = False
    end
    inherited actPrevFoundOccurrence: TAction
      Visible = False
    end
  end
  inherited DataOperationPopupMenu: TPopupMenu
    inherited AddDataRecordMenuItem: TMenuItem
      Caption = #1057#1086#1079#1076#1072#1090#1100' '#1085#1086#1074#1099#1081' '#1094#1080#1082#1083
    end
    inherited DeleteDataRecordMenuItem: TMenuItem
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1094#1080#1082#1083
    end
  end
end
