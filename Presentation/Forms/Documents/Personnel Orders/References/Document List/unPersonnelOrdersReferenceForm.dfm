inherited PersonnelOrdersReferenceForm: TPersonnelOrdersReferenceForm
  Caption = 'PersonnelOrdersReferenceForm'
  ExplicitWidth = 965
  ExplicitHeight = 719
  PixelsPerInch = 96
  TextHeight = 13
  inherited DataOperationToolBar: TToolBar
    inherited ExportDataToolButton: TToolButton
      ExplicitWidth = 123
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
    inherited DataRecordGrid: TcxGrid
      inherited DataRecordGridTableView: TcxGridDBTableView
        object SubKindNameColumn: TcxGridDBColumn [6]
          Caption = #1055#1086#1076#1090#1080#1087
          MinWidth = 150
          Width = 150
        end
        inherited ChargePerformingStatsColumn: TcxGridDBColumn
          Visible = False
          VisibleForCustomization = False
        end
        object SubKindIdColumn: TcxGridDBColumn
          Visible = False
          VisibleForCustomization = False
        end
      end
    end
  end
end
