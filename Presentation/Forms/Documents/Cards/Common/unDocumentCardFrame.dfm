inherited DocumentCardFrame: TDocumentCardFrame
  Width = 722
  Height = 378
  Color = clWhite
  ParentBackground = False
  ParentColor = False
  ExplicitWidth = 722
  ExplicitHeight = 378
  inherited ScrollBox: TScrollBox
    Width = 722
    Height = 378
    ExplicitWidth = 722
    ExplicitHeight = 378
    inherited DocumentInfoPanel: TPanel
      Width = 722
      Height = 378
      Align = alClient
      ExplicitWidth = 722
      ExplicitHeight = 378
      object DocumentCardPageControl: TPageControl
        Left = 0
        Top = 0
        Width = 722
        Height = 340
        ActivePage = DocumentRelationsAndFilesPage
        Align = alClient
        MultiLine = True
        OwnerDraw = True
        TabOrder = 0
        OnChange = DocumentCardPageControlChange
        OnDrawTab = DocumentCardPageControlDrawTab
        object DocumentMainInfoAndReceiversPage: TTabSheet
          Caption = #1054#1089#1085#1086#1074#1085#1099#1077' '#1089#1074#1077#1076#1077#1085#1080#1103' '#1080' '#1087#1086#1083#1091#1095#1072#1090#1077#1083#1080
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 0
          ExplicitHeight = 0
          object SplitterBetweenMainInfoAndReceiversAreas: TSplitter
            Left = 0
            Top = 153
            Width = 714
            Height = 4
            Cursor = crVSplit
            Align = alTop
            OnMoved = SplitterBetweenMainInfoAndReceiversAreasMoved
            ExplicitWidth = 622
          end
          object DocumentMainInfoArea: TPanel
            Left = 0
            Top = 0
            Width = 714
            Height = 153
            Align = alTop
            BevelOuter = bvNone
            Color = clWhite
            ParentBackground = False
            TabOrder = 0
            object DocumentMainInfoLabel: TLabel
              Left = 0
              Top = 0
              Width = 121
              Height = 13
              Align = alTop
              Alignment = taCenter
              Caption = #1054#1089#1085#1086#1074#1085#1099#1077' '#1089#1074#1077#1076#1077#1085#1080#1103':'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object DocumentMainInfoFormArea: TPanel
              Left = 0
              Top = 13
              Width = 714
              Height = 140
              Align = alClient
              BevelOuter = bvNone
              Color = clWhite
              TabOrder = 0
            end
          end
          object DocumentChargesInfoArea: TPanel
            Left = 0
            Top = 157
            Width = 714
            Height = 155
            Align = alClient
            BevelOuter = bvNone
            Color = clWhite
            ParentBackground = False
            TabOrder = 1
            object DocumentChargesLabel: TLabel
              Left = 0
              Top = 0
              Width = 73
              Height = 13
              Align = alTop
              Alignment = taCenter
              Caption = #1055#1086#1083#1091#1095#1072#1090#1077#1083#1080':'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object DocumentChargesFormArea: TPanel
              Left = 0
              Top = 13
              Width = 714
              Height = 142
              Align = alClient
              BevelOuter = bvNone
              Color = clWhite
              TabOrder = 0
            end
          end
        end
        object DocumentRelationsAndFilesPage: TTabSheet
          Caption = #1057#1074#1103#1079#1072#1085#1085#1099#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1099' '#1080' '#1092#1072#1081#1083#1099
          ImageIndex = 2
          OnShow = DocumentRelationsAndFilesPageShow
          object RelatedDocumentsAndFilesVerticalSplitter: TSplitter
            Left = 401
            Top = 0
            Height = 312
            OnMoved = RelatedDocumentsAndFilesVerticalSplitterMoved
            ExplicitLeft = 375
            ExplicitTop = 3
          end
          object DocumentFilesViewArea: TPanel
            Left = 404
            Top = 0
            Width = 310
            Height = 312
            Align = alClient
            BevelEdges = [beTop]
            BevelOuter = bvNone
            Caption = 'DocumentFilesViewArea'
            Color = clWhite
            ParentBackground = False
            TabOrder = 1
            object DocumentPreviewLabel: TLabel
              Left = 0
              Top = 0
              Width = 310
              Height = 13
              Align = alTop
              Alignment = taCenter
              Caption = #1055#1088#1077#1076#1074#1072#1088#1080#1090#1077#1083#1100#1085#1099#1081' '#1087#1088#1086#1089#1084#1086#1090#1088
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
              ExplicitWidth = 168
            end
            object DocumentFilesViewFormPanel: TPanel
              Left = 0
              Top = 13
              Width = 310
              Height = 299
              Align = alClient
              BevelEdges = [beTop]
              BevelOuter = bvNone
              TabOrder = 0
            end
          end
          object RelatedDocumentsAndFilesPanel: TPanel
            Left = 0
            Top = 0
            Width = 401
            Height = 312
            Align = alLeft
            BevelOuter = bvNone
            Caption = 'RelatedDocumentsAndFilesPanel'
            TabOrder = 0
            object SplitterBetweenRelationsAndFilesAreas: TSplitter
              Left = 0
              Top = 145
              Width = 401
              Height = 3
              Cursor = crVSplit
              Align = alTop
              OnCanResize = SplitterBetweenRelationsAndFilesAreasCanResize
              OnMoved = SplitterBetweenRelationsAndFilesAreasMoved
              ExplicitLeft = -6
              ExplicitTop = 127
            end
            object DocumentRelationsInfoArea: TPanel
              Left = 0
              Top = 0
              Width = 401
              Height = 145
              Align = alTop
              BevelOuter = bvNone
              Caption = 'DocumentRelationsInfoArea'
              Color = clWhite
              ParentBackground = False
              TabOrder = 0
              object DocumentRelationsLabel: TLabel
                Left = 0
                Top = 0
                Width = 401
                Height = 13
                Align = alTop
                Alignment = taCenter
                Caption = #1057#1074#1103#1079#1072#1085#1085#1099#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1099':'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'Tahoma'
                Font.Style = [fsBold]
                ParentFont = False
                ExplicitWidth = 140
              end
              object DocumentRelationsFormArea: TPanel
                Left = 0
                Top = 13
                Width = 401
                Height = 132
                Align = alClient
                AutoSize = True
                BevelEdges = [beTop]
                BevelOuter = bvNone
                Color = clWhite
                TabOrder = 0
              end
            end
            object DocumentFilesInfoArea: TPanel
              Left = 0
              Top = 148
              Width = 401
              Height = 164
              Align = alClient
              BevelOuter = bvNone
              Caption = 'DocumentFilesInfoArea'
              Color = clWhite
              ParentBackground = False
              TabOrder = 1
              object DocumentFilesLabel: TLabel
                Left = 0
                Top = 0
                Width = 401
                Height = 13
                Align = alTop
                Alignment = taCenter
                Caption = #1044#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1099#1077' '#1092#1072#1081#1083#1099':'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'Tahoma'
                Font.Style = [fsBold]
                ParentFont = False
                ExplicitWidth = 148
              end
              object DocumentFilesFormArea: TPanel
                Left = 0
                Top = 13
                Width = 401
                Height = 151
                Align = alClient
                BevelEdges = [beTop]
                BevelOuter = bvNone
                Color = clWhite
                TabOrder = 0
              end
            end
          end
        end
        object DocumentApprovingPage: TTabSheet
          Caption = #1057#1086#1075#1083#1072#1089#1086#1074#1072#1085#1080#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
          ImageIndex = 3
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 0
          ExplicitHeight = 0
          object DocumentApprovingsPagePanel: TPanel
            Left = 0
            Top = 0
            Width = 714
            Height = 312
            Align = alClient
            BevelOuter = bvNone
            Color = clWhite
            TabOrder = 0
          end
        end
        object DocumentPreviewPage: TTabSheet
          Caption = #1055#1088#1077#1076#1074#1072#1088#1080#1090#1077#1083#1100#1085#1099#1081' '#1087#1088#1086#1089#1084#1086#1090#1088
          ImageIndex = 2
          TabVisible = False
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 0
          ExplicitHeight = 0
        end
        object DocumentMainInfoPage: TTabSheet
          Caption = #1054#1089#1085#1086#1074#1085#1099#1077' '#1089#1074#1077#1076#1077#1085#1080#1103
          ImageIndex = 5
          TabVisible = False
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 0
          ExplicitHeight = 0
        end
        object DocumentChargesPage: TTabSheet
          Caption = #1055#1086#1083#1091#1095#1072#1090#1077#1083#1080
          ImageIndex = 4
          TabVisible = False
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 0
          ExplicitHeight = 0
        end
      end
      object FooterButtonPanel: TPanel
        Left = 0
        Top = 340
        Width = 722
        Height = 38
        Align = alBottom
        ParentColor = True
        TabOrder = 1
      end
    end
  end
end
