inherited DocumentCardListFrame: TDocumentCardListFrame
  Width = 629
  Height = 780
  Hint = 'Close'
  Color = clWhite
  ParentColor = False
  ExplicitWidth = 629
  ExplicitHeight = 780
  inherited ScrollBox: TScrollBox
    Width = 629
    Height = 780
    ExplicitWidth = 629
    ExplicitHeight = 780
    object PanelForDocumentRecordsAndCard: TPanel
      Left = 0
      Top = 0
      Width = 629
      Height = 780
      Align = alClient
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 0
      object SeparatorBetweenDocumentRecordsAndDocumentCard: TSplitter
        Left = 0
        Top = 345
        Width = 629
        Height = 6
        Cursor = crVSplit
        Align = alTop
        Color = clGradientInactiveCaption
        ParentColor = False
        ExplicitTop = 248
        ExplicitWidth = 505
      end
      object DocumentListPanel: TPanel
        Left = 0
        Top = 0
        Width = 629
        Height = 345
        Align = alTop
        BevelOuter = bvNone
        BiDiMode = bdLeftToRight
        Color = clWindow
        ParentBiDiMode = False
        ParentBackground = False
        TabOrder = 0
        OnResize = DocumentListPanelResize
        object DocumentListLabel: TLabel
          Left = 279
          Top = 5
          Width = 73
          Height = 13
          Caption = #1044#1086#1082#1091#1084#1077#1085#1090#1099':'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          Visible = False
        end
        object DocumentRecordsGridPanel: TPanel
          Left = 0
          Top = 0
          Width = 629
          Height = 345
          Align = alClient
          BevelOuter = bvNone
          ParentColor = True
          TabOrder = 0
        end
      end
      object DocumentCardPanel: TPanel
        Left = 0
        Top = 351
        Width = 629
        Height = 429
        Align = alClient
        BevelOuter = bvNone
        Color = clInactiveCaptionText
        ParentBackground = False
        TabOrder = 1
        object DocumentCardFormPanel: TPanel
          Left = 0
          Top = 0
          Width = 629
          Height = 429
          Align = alClient
          BevelOuter = bvNone
          Color = clWindow
          ParentBackground = False
          TabOrder = 0
        end
      end
    end
  end
end
