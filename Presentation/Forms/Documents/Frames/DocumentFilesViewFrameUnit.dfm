inherited DocumentFilesViewFrame: TDocumentFilesViewFrame
  Width = 821
  Height = 548
  ParentFont = False
  ExplicitWidth = 821
  ExplicitHeight = 548
  inherited ScrollBox: TScrollBox
    Width = 821
    Height = 548
    ExplicitWidth = 821
    ExplicitHeight = 548
    inherited DocumentInfoPanel: TPanel
      Width = 821
      Height = 548
      ExplicitWidth = 821
      ExplicitHeight = 548
      object SplitterBetweenDocumentFileListPanelAndDocumentFileViewArea: TSplitter
        Left = 217
        Top = 0
        Width = 6
        Height = 548
      end
      object DocumentFileListPanel: TPanel
        Left = 0
        Top = 0
        Width = 217
        Height = 548
        Align = alLeft
        BevelOuter = bvNone
        Color = clWhite
        ParentBackground = False
        TabOrder = 0
        DesignSize = (
          217
          548)
        object DocumentFilesLabel: TLabel
          Left = 6
          Top = 5
          Width = 148
          Height = 13
          Caption = #1044#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1099#1077' '#1092#1072#1081#1083#1099':'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object DocumentFilesListBox: TListBox
          Left = 6
          Top = 24
          Width = 203
          Height = 519
          Anchors = [akLeft, akTop, akRight, akBottom]
          BevelInner = bvNone
          BevelKind = bkFlat
          BevelOuter = bvRaised
          BorderStyle = bsNone
          Color = clWhite
          ItemHeight = 13
          ParentShowHint = False
          ShowHint = False
          TabOrder = 0
          OnClick = DocumentFilesListBoxClick
        end
      end
      object DocumentFileViewAreaPanel: TPanel
        Left = 223
        Top = 0
        Width = 598
        Height = 548
        Align = alClient
        Color = clWhite
        ParentBackground = False
        TabOrder = 1
      end
    end
  end
end
