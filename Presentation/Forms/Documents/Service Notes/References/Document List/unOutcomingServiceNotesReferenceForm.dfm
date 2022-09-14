inherited OutcomingServiceNotesReferenceForm: TOutcomingServiceNotesReferenceForm
  Caption = 'OutcomingServiceNotesReferenceForm'
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
        inherited IsSelfRegisteredColumn: TcxGridDBColumn
          Visible = True
        end
      end
    end
  end
end
