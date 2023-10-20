inherited DocumentResponsiblesReferenceForm: TDocumentResponsiblesReferenceForm
  Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1086#1074' ('#1080#1089#1087#1086#1083#1085#1080#1090#1077#1083#1077#1081')'
  ExplicitWidth = 320
  PixelsPerInch = 96
  TextHeight = 13
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
          VisibleForCustomization = False
        end
      end
    end
  end
end
