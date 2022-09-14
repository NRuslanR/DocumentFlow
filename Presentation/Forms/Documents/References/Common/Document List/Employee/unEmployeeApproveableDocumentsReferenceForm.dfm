inherited EmployeeApproveableDocumentsReferenceForm: TEmployeeApproveableDocumentsReferenceForm
  Caption = 'EmployeeApproveableDocumentsReferenceForm'
  ExplicitWidth = 965
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
        inherited ChargePerformingStatsColumn: TcxGridDBColumn
          Visible = False
          VisibleForCustomization = False
        end
        inherited IsDocumentViewedColumn: TcxGridDBColumn
          Visible = True
        end
      end
    end
  end
end
