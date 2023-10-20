inherited DocumentKindsFrame: TDocumentKindsFrame
  Width = 347
  Height = 633
  ExplicitWidth = 347
  ExplicitHeight = 633
  inherited ScrollBox: TScrollBox
    Width = 347
    Height = 633
    ExplicitWidth = 347
    ExplicitHeight = 633
    object DocumentTypesPanel: TPanel
      Left = 0
      Top = 0
      Width = 347
      Height = 633
      Align = alClient
      BevelOuter = bvNone
      Color = clWindow
      ParentBackground = False
      TabOrder = 0
      object DocumentKindsLabel: TLabel
        Left = 7
        Top = 8
        Width = 111
        Height = 13
        Caption = #1042#1080#1076#1099' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074':'
        Color = clWindow
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        Visible = False
      end
      object DocumentKindTreeList: TcxDBTreeList
        Left = 0
        Top = 0
        Width = 347
        Height = 633
        Margins.Top = 15
        Align = alClient
        Bands = <
          item
          end>
        DataController.DataSource = DocumentKindsDataSource
        LookAndFeel.Kind = lfFlat
        LookAndFeel.NativeStyle = False
        LookAndFeel.SkinName = 'UserSkin'
        OptionsBehavior.ExpandOnIncSearch = True
        OptionsData.Editing = False
        OptionsData.Deleting = False
        OptionsData.SyncMode = False
        OptionsSelection.CellSelect = False
        OptionsView.Headers = False
        RootValue = -1
        TabOrder = 0
        OnCustomDrawDataCell = DocumentKindTreeListCustomDrawDataCell
        OnFocusedNodeChanged = DocumentKindTreeListFocusedNodeChanged
        OnResize = DocumentKindTreeListResize
        object DocumentKindNameColumn: TcxDBTreeListColumn
          Caption.AlignHorz = taCenter
          Caption.Text = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
          DataBinding.FieldName = 'name'
          Width = 226
          Position.ColIndex = 0
          Position.RowIndex = 0
          Position.BandIndex = 0
          Summary.FooterSummaryItems = <>
          Summary.GroupFooterSummaryItems = <>
        end
        object DocumentKindIdColumn: TcxDBTreeListColumn
          Visible = False
          DataBinding.FieldName = 'id'
          Position.ColIndex = 1
          Position.RowIndex = 0
          Position.BandIndex = 0
          Summary.FooterSummaryItems = <>
          Summary.GroupFooterSummaryItems = <>
        end
        object TopLevelDocumentKindIdColumn: TcxDBTreeListColumn
          Visible = False
          DataBinding.FieldName = 'parent_type_id'
          Position.ColIndex = 2
          Position.RowIndex = 0
          Position.BandIndex = 0
          Summary.FooterSummaryItems = <>
          Summary.GroupFooterSummaryItems = <>
        end
        object DocumentKindOriginalNameColumn: TcxDBTreeListColumn
          Visible = False
          Caption.Text = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
          DataBinding.FieldName = 'original_name'
          Width = 264
          Position.ColIndex = 3
          Position.RowIndex = 0
          Position.BandIndex = 0
          Summary.FooterSummaryItems = <>
          Summary.GroupFooterSummaryItems = <>
        end
      end
    end
  end
  object DocumentKindsDataSource: TDataSource
    Left = 16
    Top = 584
  end
end
