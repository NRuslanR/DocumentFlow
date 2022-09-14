inherited IncomingServiceNotesReferenceForm: TIncomingServiceNotesReferenceForm
  Caption = 'IncomingServiceNotesReferenceForm'
  ExplicitWidth = 320
  PixelsPerInch = 96
  TextHeight = 13
  inherited DataOperationToolBar: TToolBar
    Height = 156
    ButtonWidth = 108
    ExplicitHeight = 156
    inherited ChooseRecordsToolButton: TToolButton
      ExplicitWidth = 108
    end
    inherited ReserveToolButton1: TToolButton [2]
      Left = 0
      Wrap = False
      ExplicitLeft = 0
      ExplicitWidth = 108
    end
    inherited AddDataToolButton: TToolButton [3]
      Left = 108
      ExplicitLeft = 108
      ExplicitWidth = 108
    end
    inherited CopySelectedDataRecordsToolButton: TToolButton [4]
      Left = 216
      Enabled = False
      ExplicitLeft = 216
      ExplicitWidth = 108
    end
    inherited ChangeDataToolButton: TToolButton [5]
      Left = 324
      ExplicitLeft = 324
      ExplicitWidth = 108
    end
    inherited RefreshDocumentCardToolButton: TToolButton
      Left = 432
      ExplicitLeft = 432
      ExplicitTop = 43
    end
    inherited RefreshDataToolButton: TToolButton
      Left = 544
      Wrap = True
      ExplicitLeft = 544
      ExplicitWidth = 123
    end
    inherited SelectFilterDataToolButton: TToolButton [8]
      Left = 0
      ExplicitLeft = 0
      ExplicitWidth = 108
    end
    inherited ReserveToolButton2: TToolButton
      Left = 108
      ExplicitLeft = 108
      ExplicitWidth = 108
    end
    inherited PrintDataToolButton: TToolButton [10]
      Left = 216
      ExplicitLeft = 216
      ExplicitWidth = 108
    end
    inherited SelectFilteredRecordsSeparator: TToolButton
      Left = 324
      ExplicitLeft = 324
    end
    inherited ExportDataToolButton: TToolButton [12]
      Left = 332
      Enabled = False
      ExplicitLeft = 332
      ExplicitWidth = 123
    end
    inherited ExportDataSeparator: TToolButton [13]
      Left = 0
      Enabled = False
      Wrap = True
      ExplicitLeft = 0
      ExplicitHeight = 41
    end
    inherited ExitToolButton: TToolButton [14]
      Left = 0
      Top = 120
      ExplicitLeft = 0
      ExplicitTop = 120
      ExplicitWidth = 108
    end
    inherited DeleteDataToolButton: TToolButton [15]
      Left = 108
      Top = 120
      ExplicitLeft = 108
      ExplicitWidth = 108
    end
    inherited RefreshDocumentCardToolButton: TToolButton
      ExplicitWidth = 111
    end
    inherited RespondingDocumentCreatingToolButton: TToolButton
      Left = 216
      Top = 120
      Enabled = False
      ExplicitLeft = 216
      ExplicitTop = 120
      ExplicitWidth = 108
    end
  end
  inherited SearchByColumnPanel: TScrollBox
    inherited btnPrevFoundOccurrence: TcxButton
      LookAndFeel.SkinName = ''
    end
    inherited btnNextFoundOccurrence: TcxButton
      LookAndFeel.SkinName = ''
    end
  end
  inherited DataRecordMovingToolBar: TToolBar
    Top = 156
  end
  inherited ClientAreaPanel: TPanel
    Top = 178
    Height = 454
    inherited DataLoadingCanceledPanel: TPanel
      Top = 49
    end
    inherited WaitDataLoadingPanel: TPanel
      Top = 116
    end
    inherited DataRecordGrid: TcxGrid
      Height = 454
      inherited DataRecordGridTableView: TcxGridDBTableView
        inherited OwnChargeSheetColumn: TcxGridDBColumn [0]
          Visible = True
          MinWidth = 60
        end
        inherited DocumentNameColumn: TcxGridDBColumn [1]
        end
        inherited DocumentCreationDateColumn: TcxGridDBColumn [2]
        end
        inherited DocumentCreationDateYearColumn: TcxGridDBColumn [3]
        end
        inherited DocumentCreationDateMonthColumn: TcxGridDBColumn [4]
        end
        inherited DocumentTypeNameColumn: TcxGridDBColumn [5]
        end
        inherited CurrentWorkCycleStageNameColumn: TcxGridDBColumn [6]
        end
        inherited CurrentWorkCycleStageNumberColumn: TcxGridDBColumn [7]
        end
        inherited DocumentAuthorShortNameColumn: TcxGridDBColumn [8]
        end
        inherited ChargePerformingStatsColumn: TcxGridDBColumn [9]
        end
        inherited IdColumn: TcxGridDBColumn [10]
        end
        inherited DocumentTypeIdColumn: TcxGridDBColumn [11]
        end
        inherited CanBeRemovedColumn: TcxGridDBColumn [12]
        end
        inherited DocumentAuthorIdColumn: TcxGridDBColumn [13]
        end
        inherited DocumentNumberColumn: TcxGridDBColumn [14]
        end
        inherited IsSelectedColumn: TcxGridDBColumn [15]
        end
        inherited AllChargeSheetsPerformedColumn: TcxGridDBColumn [16]
        end
        inherited AllSubordinateChargeSheetsPerformedColumn: TcxGridDBColumn [17]
        end
        inherited IsSelfRegisteredColumn: TcxGridDBColumn [18]
        end
        inherited ReceiptDateColumn: TcxGridDBColumn [19]
        end
        inherited IncomingDocumentNumberColumn: TcxGridDBColumn [20]
        end
        inherited SendingDepartmentNameColumn: TcxGridDBColumn [21]
        end
        inherited IsDocumentViewedColumn: TcxGridDBColumn [22]
        end
        inherited DocumentDateColumn: TcxGridDBColumn [23]
        end
        inherited BaseDocumentIdColumn: TcxGridDBColumn [24]
        end
        inherited ApplicationsExistsColumn: TcxGridDBColumn [25]
        end
        inherited ProductCodeColumn: TcxGridDBColumn [26]
        end
      end
    end
  end
  inherited DataOperationActionList: TActionList
    inherited actCreateRespondingDocument: TAction
      Caption = #1054#1090#1074#1077#1090' '#1085#1072' '#1089'/'#1079
    end
  end
end
