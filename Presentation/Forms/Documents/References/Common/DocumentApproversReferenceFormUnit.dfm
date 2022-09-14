inherited DocumentApproversReferenceForm: TDocumentApproversReferenceForm
  Caption = 'DocumentApproversReferenceForm'
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
        end
      end
    end
  end
end
