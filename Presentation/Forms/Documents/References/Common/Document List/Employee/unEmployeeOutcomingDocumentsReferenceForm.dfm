inherited EmployeeOutcomingDocumentsReferenceForm: TEmployeeOutcomingDocumentsReferenceForm
  Caption = 'EmployeeOutcomingDocumentsReferenceForm'
  ClientWidth = 1041
  ExplicitWidth = 1057
  PixelsPerInch = 96
  TextHeight = 13
  inherited DataOperationToolBar: TToolBar
    Width = 1041
    ExplicitWidth = 1041
  end
  inherited StatisticsInfoStatusBar: TStatusBar
    Width = 1041
    ExplicitWidth = 1041
  end
  inherited SearchByColumnPanel: TScrollBox
    Width = 1041
    ExplicitWidth = 1041
    inherited btnPrevFoundOccurrence: TcxButton
      LookAndFeel.SkinName = ''
    end
    inherited btnNextFoundOccurrence: TcxButton
      LookAndFeel.SkinName = ''
    end
  end
  inherited DataRecordMovingToolBar: TToolBar
    Width = 1041
    ExplicitWidth = 1041
  end
  inherited ClientAreaPanel: TPanel
    Width = 1041
    ExplicitWidth = 1041
    DesignSize = (
      1041
      572)
    inherited DataLoadingCanceledPanel: TPanel
      Left = 147
      ExplicitLeft = 147
    end
    inherited WaitDataLoadingPanel: TPanel
      Left = 101
      ExplicitLeft = 101
    end
    inherited DataRecordGrid: TcxGrid
      Width = 1041
      ExplicitWidth = 1041
      inherited DataRecordGridTableView: TcxGridDBTableView
        OnSelectionChanged = nil
        inherited DocumentNameColumn: TcxGridDBColumn
          Width = 227
        end
        inherited DocumentCreationDateYearColumn: TcxGridDBColumn [2]
          FooterAlignmentHorz = taCenter
        end
        inherited DocumentCreationDateMonthColumn: TcxGridDBColumn [3]
          FooterAlignmentHorz = taCenter
          Width = 113
        end
        inherited DocumentCreationDateColumn: TcxGridDBColumn [4]
          FooterAlignmentHorz = taCenter
          Width = 127
        end
        inherited DocumentTypeNameColumn: TcxGridDBColumn
          FooterAlignmentHorz = taCenter
        end
        inherited CurrentWorkCycleStageNameColumn: TcxGridDBColumn
          FooterAlignmentHorz = taCenter
        end
        inherited IdColumn: TcxGridDBColumn [8]
        end
        inherited DocumentTypeIdColumn: TcxGridDBColumn [9]
        end
        inherited DocumentAuthorShortNameColumn: TcxGridDBColumn [10]
        end
        inherited ChargePerformingStatsColumn: TcxGridDBColumn [11]
        end
        inherited IsDocumentViewedColumn: TcxGridDBColumn
          Visible = True
        end
      end
    end
  end
  inherited DataOperationActionList: TActionList
    inherited actAddData: TAction
      Visible = True
    end
  end
end
