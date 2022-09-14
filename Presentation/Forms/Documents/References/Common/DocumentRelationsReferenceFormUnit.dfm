inherited DocumentRelationsReferenceForm: TDocumentRelationsReferenceForm
  Caption = 'DocumentRelationsReferenceForm'
  ClientWidth = 718
  ExplicitWidth = 734
  ExplicitHeight = 719
  PixelsPerInch = 96
  TextHeight = 13
  inherited DataOperationToolBar: TToolBar
    Width = 718
    Height = 80
    EdgeBorders = [ebTop]
    EdgeOuter = esLowered
    ExplicitWidth = 718
    ExplicitHeight = 80
    inherited ChooseRecordsToolButton: TToolButton
      Visible = False
    end
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
  inherited StatisticsInfoStatusBar: TStatusBar
    Width = 718
    ExplicitWidth = 718
  end
  inherited SearchByColumnPanel: TScrollBox
    Top = 102
    Width = 718
    Visible = False
    ExplicitTop = 102
    ExplicitWidth = 718
    inherited btnPrevFoundOccurrence: TcxButton
      LookAndFeel.SkinName = ''
    end
    inherited btnNextFoundOccurrence: TcxButton
      LookAndFeel.SkinName = ''
    end
  end
  inherited DataRecordMovingToolBar: TToolBar
    Top = 80
    Width = 718
    ExplicitTop = 80
    ExplicitWidth = 718
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
    Width = 718
    Height = 528
    ExplicitTop = 133
    ExplicitWidth = 718
    ExplicitHeight = 528
    inherited DataLoadingCanceledPanel: TPanel
      Left = 73
      ExplicitLeft = 73
    end
    inherited WaitDataLoadingPanel: TPanel
      Left = 25
      Top = 143
      ExplicitLeft = 25
      ExplicitTop = 143
    end
    inherited DataRecordGrid: TcxGrid
      Width = 718
      Height = 528
      ExplicitWidth = 718
      ExplicitHeight = 528
      inherited DataRecordGridTableView: TcxGridDBTableView
        DataController.KeyFieldNames = 'id;type_id'
        OptionsView.GroupByBox = False
        object DocumentNumberColumn: TcxGridDBColumn
          Caption = #1053#1086#1084#1077#1088
          DataBinding.FieldName = 'number'
          Width = 125
        end
        object DocumentNameColumn: TcxGridDBColumn
          Caption = #1053#1072#1079#1074#1072#1085#1080#1077
          DataBinding.FieldName = 'name'
          Width = 192
        end
        object DocumentDateColumn: TcxGridDBColumn
          Caption = #1044#1072#1090#1072' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
          DataBinding.FieldName = 'document_date'
          Width = 128
        end
        object DocumentKindNameColumn: TcxGridDBColumn
          Caption = #1058#1080#1087' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
          DataBinding.FieldName = 'type_name'
          Width = 292
        end
        object DocumentIdColumn: TcxGridDBColumn
          DataBinding.FieldName = 'id'
          Visible = False
          VisibleForCustomization = False
        end
        object DocumentKindIdColumn: TcxGridDBColumn
          DataBinding.FieldName = 'type_id'
          Visible = False
          VisibleForCustomization = False
        end
        object BaseDocumentIdColumn: TcxGridDBColumn
          DataBinding.FieldName = 'base_document_id'
          Visible = False
          VisibleForCustomization = False
        end
        object IdColumn: TcxGridDBColumn
          Visible = False
          VisibleForCustomization = False
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
    object actOpenRelatedDocumentCard: TAction
      Caption = #1054#1090#1082#1088#1099#1090#1100' '#1082#1072#1088#1090#1086#1095#1082#1091' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      OnExecute = actOpenRelatedDocumentCardExecute
    end
  end
  inherited DataOperationPopupMenu: TPopupMenu
    OnPopup = DataOperationPopupMenuPopup
    object OpenRelatedDocumentCardMenuItem: TMenuItem [2]
      Action = actOpenRelatedDocumentCard
    end
  end
end
