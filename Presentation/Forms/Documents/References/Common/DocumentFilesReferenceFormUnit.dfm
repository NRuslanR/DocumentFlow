inherited DocumentFilesReferenceForm: TDocumentFilesReferenceForm
  Caption = 'DocumentFilesReferenceForm'
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
        OnDblClick = DataRecordGridTableViewDblClick
        DataController.KeyFieldNames = 'file_name'
        OptionsSelection.CellSelect = False
        OptionsView.GroupByBox = False
        object DocumentFileIdColumn: TcxGridDBColumn
          DataBinding.FieldName = 'id'
          Visible = False
          VisibleForCustomization = False
        end
        object DocumentFileNameColumn: TcxGridDBColumn
          Caption = #1048#1084#1103' '#1092#1072#1081#1083#1072
          DataBinding.FieldName = 'file_name'
          Width = 196
        end
        object DocumentFilePathColumn: TcxGridDBColumn
          Caption = #1055#1091#1090#1100' '#1082' '#1092#1072#1081#1083#1091
          DataBinding.FieldName = 'file_path'
          Visible = False
          VisibleForCustomization = False
          Width = 370
        end
      end
    end
  end
  inherited DataOperationActionList: TActionList
    inherited actCopySelectedDataRecordCell: TAction
      Visible = False
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
    inherited actChooseRecords: TAction
      Visible = False
    end
    object actOpenDocumentFile: TAction
      Caption = #1054#1090#1082#1088#1099#1090#1100' '#1092#1072#1081#1083
      OnExecute = actOpenDocumentFileExecute
    end
  end
  inherited DataOperationPopupMenu: TPopupMenu
    OnPopup = DataOperationPopupMenuPopup
    object OpenDocumentFileMenuItem: TMenuItem [0]
      Action = actOpenDocumentFile
    end
    object N5: TMenuItem [1]
      Caption = '-'
    end
  end
  object LoadFileDialog: TOpenDialog
    Title = #1047#1072#1075#1088#1091#1079#1082#1072' '#1092#1072#1081#1083#1072' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
    Left = 560
    Top = 64
  end
  object ClientDataSet1: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 368
    Top = 344
  end
end
