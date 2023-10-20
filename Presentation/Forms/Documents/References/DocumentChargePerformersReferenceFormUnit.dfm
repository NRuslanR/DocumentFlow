inherited DocumentChargePerformersReferenceForm: TDocumentChargePerformersReferenceForm
  Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' '#1087#1086#1083#1091#1095#1072#1090#1077#1083#1077#1081' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
  ExplicitTop = 8
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
        inherited SurnameColumn: TcxGridDBColumn
          Width = 94
        end
        inherited NameColumn: TcxGridDBColumn
          Width = 96
        end
        inherited PatronymicColumn: TcxGridDBColumn
          Width = 96
        end
        inherited SpecialityColumn: TcxGridDBColumn
          Width = 189
        end
        inherited DepartmentCodeColumn: TcxGridDBColumn
          Width = 133
        end
        inherited DepartmentShortNameColumn: TcxGridDBColumn
          Width = 138
        end
      end
    end
  end
end
