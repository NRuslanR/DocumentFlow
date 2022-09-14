inherited DocumentApprovingsFrame: TDocumentApprovingsFrame
  Width = 822
  Height = 478
  ExplicitWidth = 822
  ExplicitHeight = 478
  inherited ScrollBox: TScrollBox
    Width = 822
    Height = 478
    ExplicitWidth = 822
    ExplicitHeight = 478
    inherited DocumentInfoPanel: TPanel
      Width = 822
      Height = 478
      ExplicitWidth = 822
      ExplicitHeight = 478
      object Splitter1: TSplitter
        Left = 233
        Top = 0
        Height = 478
      end
      object DocumentApprovingCyclesInfoArea: TPanel
        Left = 0
        Top = 0
        Width = 233
        Height = 478
        Align = alLeft
        TabOrder = 0
        object DocumentApprovingCyclesLabel: TLabel
          Left = 1
          Top = 1
          Width = 38
          Height = 13
          Align = alTop
          Alignment = taCenter
          Caption = #1062#1080#1082#1083#1099':'
        end
        object DocumentApprovingCyclesFormPanel: TPanel
          Left = 1
          Top = 14
          Width = 231
          Height = 463
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 0
        end
      end
      object DocumentApproversInfoArea: TPanel
        Left = 236
        Top = 0
        Width = 586
        Height = 478
        Align = alClient
        TabOrder = 1
        object DocumentApproversLabel: TLabel
          Left = 1
          Top = 1
          Width = 77
          Height = 13
          Align = alTop
          Alignment = taCenter
          Caption = #1057#1086#1075#1083#1072#1089#1086#1074#1072#1085#1090#1099':'
        end
        object DocumentApproversFormPanel: TPanel
          Left = 1
          Top = 14
          Width = 584
          Height = 463
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 0
        end
      end
    end
  end
end
