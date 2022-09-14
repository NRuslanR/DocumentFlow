inherited EmployeeIncomingDocumentsReferenceForm: TEmployeeIncomingDocumentsReferenceForm
  Caption = 'EmployeeIncomingDocumentsReferenceForm'
  ClientWidth = 1070
  ExplicitLeft = 8
  ExplicitTop = 8
  ExplicitWidth = 1086
  PixelsPerInch = 96
  TextHeight = 13
  inherited DataOperationToolBar: TToolBar
    Width = 1070
    ExplicitWidth = 1070
  end
  inherited StatisticsInfoStatusBar: TStatusBar
    Width = 1070
    ExplicitWidth = 1070
  end
  inherited SearchByColumnPanel: TScrollBox
    Width = 1070
    ExplicitWidth = 1070
    inherited btnPrevFoundOccurrence: TcxButton
      LookAndFeel.SkinName = ''
    end
    inherited btnNextFoundOccurrence: TcxButton
      LookAndFeel.SkinName = ''
    end
  end
  inherited DataRecordMovingToolBar: TToolBar
    Width = 1070
    ExplicitWidth = 1070
  end
  inherited ClientAreaPanel: TPanel
    Width = 1070
    ExplicitWidth = 1070
    DesignSize = (
      1070
      531)
    inherited DataLoadingCanceledPanel: TPanel
      Left = 154
      ExplicitLeft = 154
    end
    inherited WaitDataLoadingPanel: TPanel
      Left = 107
      ExplicitLeft = 107
    end
    inherited DataRecordGrid: TcxGrid
      Width = 1070
      ExplicitWidth = 1070
      inherited DataRecordGridTableView: TcxGridDBTableView
        inherited OutcommingDocumentNumberColumn: TcxGridDBColumn [0]
        end
        inherited CurrentWorkCycleStageNameColumn: TcxGridDBColumn [1]
          Width = 93
        end
        inherited DocumentNameColumn: TcxGridDBColumn [2]
        end
        inherited DocumentCreationDateColumn: TcxGridDBColumn [3]
        end
        inherited DocumentCreationDateYearColumn: TcxGridDBColumn [4]
        end
        inherited DocumentCreationDateMonthColumn: TcxGridDBColumn [5]
        end
        inherited DocumentNumberColumn: TcxGridDBColumn [6]
          FooterAlignmentHorz = taCenter
        end
        inherited IdColumn: TcxGridDBColumn [7]
        end
        inherited DocumentTypeIdColumn: TcxGridDBColumn [8]
        end
        inherited CurrentWorkCycleStageNumberColumn: TcxGridDBColumn [9]
        end
        inherited DocumentTypeNameColumn: TcxGridDBColumn [10]
          Width = 160
        end
        inherited DocumentAuthorShortNameColumn: TcxGridDBColumn [11]
        end
        inherited ChargePerformingStatsColumn: TcxGridDBColumn [12]
        end
        inherited CanBeRemovedColumn: TcxGridDBColumn [13]
        end
        inherited DocumentAuthorIdColumn: TcxGridDBColumn [14]
        end
        inherited SendingDepartmentNameColumn: TcxGridDBColumn [15]
        end
        inherited IsDocumentViewedColumn: TcxGridDBColumn [16]
          Visible = True
        end
        inherited ReceiptDateColumn: TcxGridDBColumn [17]
        end
        inherited BaseDocumentIdColumn: TcxGridDBColumn [18]
        end
        inherited OwnChargeSheetColumn: TcxGridDBColumn [19]
        end
        inherited AllChargeSheetsPerformedColumn: TcxGridDBColumn [20]
        end
        inherited AllSubordinateChargeSheetsPerformedColumn: TcxGridDBColumn [21]
        end
      end
    end
  end
  inherited Localizer: TcxLocalizer
    Left = 560
    Top = 48
  end
end
