inherited BaseOutcomingDocumentsReferenceForm: TBaseOutcomingDocumentsReferenceForm
  Caption = 'BaseOutcomingDocumentsReferenceForm'
  ExplicitWidth = 320
  ExplicitHeight = 240
  PixelsPerInch = 96
  TextHeight = 13
  inherited DataOperationToolBar: TToolBar
    inherited ChooseRecordsSeparator: TToolButton
      ExplicitHeight = 36
    end
    inherited AddDataToolButton: TToolButton
      Enabled = False
    end
    inherited RefreshDataToolButton: TToolButton
      ExplicitWidth = 108
    end
    inherited ExportDataToolButton: TToolButton
      ExplicitWidth = 108
    end
  end
  inherited SearchByColumnPanel: TScrollBox
    inherited Label1: TLabel
      ExplicitLeft = 8
    end
    inherited btnPrevFoundOccurrence: TcxButton
      LookAndFeel.SkinName = ''
    end
    inherited btnNextFoundOccurrence: TcxButton
      LookAndFeel.SkinName = ''
    end
  end
  inherited DataRecordMovingToolBar: TToolBar
    inherited FirstDataRecordToolButton: TToolButton
      ExplicitWidth = 46
    end
    inherited PrevDataRecordToolButton: TToolButton
      ExplicitWidth = 46
    end
    inherited NextDataRecordToolButton: TToolButton
      ExplicitWidth = 46
    end
    inherited LastDataRecordToolButton: TToolButton
      ExplicitWidth = 46
    end
  end
  inherited ClientAreaPanel: TPanel
    inherited DataRecordGrid: TcxGrid
      inherited DataRecordGridTableView: TcxGridDBTableView
        object ReceivingDepartmentNamesColumn: TcxGridDBColumn [16]
          Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103
          MinWidth = 0
          Width = 103
        end
      end
    end
  end
end
