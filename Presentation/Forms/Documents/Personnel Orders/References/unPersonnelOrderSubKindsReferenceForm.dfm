inherited PersonnelOrderSubKindsReferenceForm: TPersonnelOrderSubKindsReferenceForm
  Caption = #1055#1086#1076#1090#1080#1087#1099' '#1082#1072#1076#1088#1086#1074#1086#1075#1086' '#1087#1088#1080#1082#1072#1079#1072
  ExplicitWidth = 769
  ExplicitHeight = 719
  PixelsPerInch = 96
  TextHeight = 13
  inherited DataOperationToolBar: TToolBar
    inherited ExportDataToolButton: TToolButton
      ExplicitWidth = 83
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
        object IdColumn: TcxGridDBColumn
          Visible = False
          VisibleForCustomization = False
        end
        object NameColumn: TcxGridDBColumn
          Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
        end
      end
    end
  end
  inherited DataOperationActionList: TActionList
    inherited actAddData: TAction
      Visible = False
    end
    inherited actDeleteData: TAction
      Visible = False
    end
  end
end
