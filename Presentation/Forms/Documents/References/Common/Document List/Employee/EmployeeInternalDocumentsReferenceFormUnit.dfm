inherited EmployeeInternalDocumentsReferenceForm: TEmployeeInternalDocumentsReferenceForm
  Caption = ''
  ClientWidth = 863
  ExplicitWidth = 879
  PixelsPerInch = 96
  TextHeight = 13
  inherited DataOperationToolBar: TToolBar
    Width = 863
    ExplicitWidth = 863
    inherited ChooseRecordsToolButton: TToolButton
      Enabled = True
    end
    inherited RefreshSeparator: TToolButton [1]
      Left = 111
      Wrap = False
      ExplicitLeft = 111
      ExplicitHeight = 36
    end
    inherited ReserveToolButton2: TToolButton [2]
      Left = 119
      ExplicitLeft = 119
    end
    inherited ChooseRecordsSeparator: TToolButton [3]
      Left = 230
      ExplicitLeft = 230
    end
    inherited AddDataToolButton: TToolButton [4]
      Left = 238
      ExplicitLeft = 238
    end
    inherited SelectFilterDataToolButton: TToolButton [5]
      Left = 349
      Top = 2
      ExplicitLeft = 349
      ExplicitTop = 2
    end
    inherited RefreshDataToolButton: TToolButton
      Left = 460
      ExplicitLeft = 460
    end
    inherited CopySelectedDataRecordsToolButton: TToolButton [7]
      Left = 571
      ExplicitLeft = 571
    end
    inherited ChangeDataToolButton: TToolButton [8]
      Left = 682
      Enabled = True
      ExplicitLeft = 682
    end
    inherited ExportDataSeparator: TToolButton [9]
      Left = 0
      Top = 2
      Wrap = True
      ExplicitLeft = 0
      ExplicitTop = 2
      ExplicitHeight = 41
    end
    inherited ReserveToolButton1: TToolButton [10]
      Left = 0
      Top = 43
      ExplicitLeft = 0
      ExplicitTop = 43
    end
    inherited DeleteDataToolButton: TToolButton [14]
      Left = 356
      Top = 43
      ExplicitLeft = 356
      ExplicitTop = 43
    end
    inherited ExitToolButton: TToolButton
      Left = 467
      ExplicitLeft = 467
    end
    inherited RespondingDocumentCreatingToolButton: TToolButton
      Left = 578
      Enabled = False
      ExplicitLeft = 578
    end
  end
  inherited StatisticsInfoStatusBar: TStatusBar
    Width = 863
    ExplicitWidth = 863
  end
  inherited SearchByColumnPanel: TScrollBox
    Width = 863
    ExplicitWidth = 863
    inherited btnPrevFoundOccurrence: TcxButton
      LookAndFeel.SkinName = ''
    end
    inherited btnNextFoundOccurrence: TcxButton
      LookAndFeel.SkinName = ''
    end
  end
  inherited DataRecordMovingToolBar: TToolBar
    Width = 863
    ExplicitWidth = 863
  end
  inherited ClientAreaPanel: TPanel
    Width = 863
    ExplicitWidth = 863
    inherited DataLoadingCanceledPanel: TPanel
      Left = 106
      ExplicitLeft = 106
    end
    inherited WaitDataLoadingPanel: TPanel
      Left = 59
      ExplicitLeft = 59
    end
    inherited DataRecordGrid: TcxGrid
      Width = 863
      ExplicitWidth = 863
      inherited DataRecordGridTableView: TcxGridDBTableView
        inherited OwnDocumentChargeColumn: TcxGridDBColumn
          Visible = False
          VisibleForCustomization = False
        end
        inherited DocumentNumberColumn: TcxGridDBColumn [1]
          Caption = #1053#1086#1084#1077#1088
          DataBinding.FieldName = 'outcomming_number'
          VisibleForCustomization = False
        end
        inherited DocumentCreationDateColumn: TcxGridDBColumn [3]
        end
        inherited ReceiptDateColumn: TcxGridDBColumn [4]
          Visible = False
        end
        inherited CurrentWorkCycleStageNameColumn: TcxGridDBColumn [5]
        end
        inherited DocumentCreationDateYearColumn: TcxGridDBColumn [6]
        end
        inherited DocumentCreationDateMonthColumn: TcxGridDBColumn [7]
        end
        inherited DocumentTypeIdColumn: TcxGridDBColumn [8]
        end
        inherited CurrentWorkCycleStageNumberColumn: TcxGridDBColumn [9]
        end
        inherited DocumentTypeNameColumn: TcxGridDBColumn [10]
        end
        inherited DocumentAuthorShortNameColumn: TcxGridDBColumn [11]
        end
        inherited ChargePerformingStatsColumn: TcxGridDBColumn [12]
        end
        inherited IdColumn: TcxGridDBColumn [13]
        end
        inherited AllSubordinateChargesPerformedColumn: TcxGridDBColumn [14]
        end
        inherited CanBeRemovedColumn: TcxGridDBColumn [15]
        end
        inherited OutcommingDocumentNumberColumn: TcxGridDBColumn [17]
          Visible = False
        end
        inherited DocumentAuthorIdColumn: TcxGridDBColumn [18]
        end
        inherited SendingDepartmentNameColumn: TcxGridDBColumn [19]
        end
      end
    end
  end
  inherited DataOperationActionList: TActionList
    inherited actAddData: TAction
      Visible = True
    end
  end
  inherited Localizer: TcxLocalizer
    Left = 232
    Top = 352
  end
end
