inherited BaseApproveableDocumentsReferenceForm: TBaseApproveableDocumentsReferenceForm
  Caption = 'BaseApproveableDocumentsReferenceForm'
  ExplicitHeight = 719
  PixelsPerInch = 96
  TextHeight = 13
  inherited DataOperationToolBar: TToolBar
    inherited ExportDataToolButton: TToolButton
      ExplicitWidth = 83
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
        object SenderDepartmentNameColumn: TcxGridDBColumn [16]
          Caption = #1054#1090#1087#1088#1072#1074#1080#1090#1077#1083#1100
          MinWidth = 0
          Width = 100
        end
        object ReceiverDepartmentNamesColumn: TcxGridDBColumn [17]
          Caption = #1055#1086#1083#1091#1095#1072#1090#1077#1083#1080
          MinWidth = 0
          Width = 200
        end
      end
    end
  end
end
