inherited DocumentSignersReferenceForm: TDocumentSignersReferenceForm
  Caption = #1042#1086#1079#1084#1086#1078#1085#1099#1077' '#1087#1086#1076#1087#1080#1089#1072#1085#1090#1099' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
  PixelsPerInch = 96
  TextHeight = 13
  inherited DataOperationToolBar: TToolBar
    inherited ChangeDataToolButton: TToolButton
      ExplicitLeft = 348
    end
    inherited DeleteDataToolButton: TToolButton
      ExplicitLeft = 416
    end
    inherited ReserveToolButton1: TToolButton
      ExplicitLeft = 484
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
  inherited ClientAreaPanel: TPanel
    inherited DataRecordGrid: TcxGrid
      inherited DataRecordGridTableView: TcxGridDBTableView
        inherited IsForeignColumn: TcxGridDBColumn
          Visible = False
        end
      end
    end
  end
  inherited DataOperationActionList: TActionList
    inherited actCopySelectedDataRecordCell: TAction
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
  end
end
