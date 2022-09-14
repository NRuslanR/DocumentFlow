inherited AdminDocumentCardListFrame: TAdminDocumentCardListFrame
  Width = 451
  Height = 304
  Align = alClient
  OnResize = FrameResize
  ExplicitWidth = 451
  ExplicitHeight = 304
  inherited ScrollBox: TScrollBox
    Width = 973
    Height = 540
    ExplicitWidth = 973
    ExplicitHeight = 540
    object SplitterBetweenDocumentsAndDepartments: TSplitter [0]
      Left = 233
      Top = 0
      Width = 6
      Height = 540
      ExplicitLeft = 200
      ExplicitHeight = 304
    end
    inherited PanelForDocumentRecordsAndCard: TPanel
      Left = 239
      Width = 734
      Height = 540
      ExplicitLeft = 263
      ExplicitWidth = 188
      ExplicitHeight = 304
      inherited SeparatorBetweenDocumentRecordsAndDocumentCard: TSplitter
        Top = 257
        Width = 734
        ExplicitTop = 289
        ExplicitWidth = 641
      end
      inherited DocumentListPanel: TPanel
        Width = 734
        Height = 257
        ExplicitWidth = 710
        ExplicitHeight = 257
        inherited DocumentRecordsGridPanel: TPanel
          Width = 734
          Height = 225
          ExplicitWidth = 188
          ExplicitHeight = 257
        end
      end
      inherited DocumentCardPanel: TPanel
        Top = 263
        Width = 734
        Height = 277
        ExplicitTop = 295
        ExplicitWidth = 188
        ExplicitHeight = 9
        inherited DocumentCardFormPanel: TPanel
          Width = 734
          Height = 277
          ExplicitWidth = 188
          ExplicitHeight = 9
        end
      end
    end
    object DepartmentsPanel: TPanel
      Left = 0
      Top = 0
      Width = 233
      Height = 540
      Align = alLeft
      BevelOuter = bvNone
      ParentBackground = False
      TabOrder = 1
      object DepartmentsChooseFormPanel: TPanel
        Left = 0
        Top = 32
        Width = 233
        Height = 508
        Align = alClient
        BevelOuter = bvNone
        ParentBackground = False
        TabOrder = 0
        ExplicitWidth = 6
        ExplicitHeight = 272
      end
      object DepartmentsLabelPanel: TPanel
        Left = 0
        Top = 0
        Width = 233
        Height = 32
        Align = alTop
        BevelOuter = bvNone
        ParentBackground = False
        TabOrder = 1
        OnResize = DepartmentsLabelPanelResize
        ExplicitWidth = 257
        object DepartmentsLabel: TLabel
          Left = 80
          Top = 5
          Width = 97
          Height = 13
          Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103':'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
      end
    end
  end
end
