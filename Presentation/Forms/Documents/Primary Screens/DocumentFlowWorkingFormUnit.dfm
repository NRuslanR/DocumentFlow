object DocumentFlowWorkingForm: TDocumentFlowWorkingForm
  Left = 0
  Top = 0
  Hint = 'Close'
  Caption = 'DocumentFlowWorkingForm'
  ClientHeight = 726
  ClientWidth = 1065
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object SeparatorBetweenDocumentTypesAndRest: TSplitter
    Left = 290
    Top = 0
    Width = 6
    Height = 726
    Color = clGradientInactiveCaption
    ParentColor = False
    ExplicitLeft = 554
  end
  object DocumentTypesPanel: TPanel
    Left = 0
    Top = 0
    Width = 290
    Height = 726
    Align = alLeft
    BevelOuter = bvNone
    Color = clWindow
    ParentBackground = False
    TabOrder = 0
    DesignSize = (
      290
      726)
    object DocumentKindsLabel: TLabel
      Left = 8
      Top = 7
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
    end
    object DocumentKindTreeList: TcxDBTreeList
      Left = 8
      Top = 27
      Width = 276
      Height = 690
      Anchors = [akLeft, akTop, akRight, akBottom]
      Bands = <
        item
        end>
      DataController.DataSource = DocumentTypesDataSource
      DataController.ParentField = 'parent_type_id'
      DataController.KeyField = 'id'
      LookAndFeel.SkinName = 'UserSkin'
      OptionsBehavior.ExpandOnIncSearch = True
      OptionsData.Editing = False
      OptionsData.Deleting = False
      OptionsData.SyncMode = False
      OptionsSelection.CellSelect = False
      RootValue = -1
      TabOrder = 0
      OnCustomDrawDataCell = DocumentKindTreeListCustomDrawDataCell
      OnFocusedNodeChanged = DocumentKindTreeListFocusedNodeChanged
      OnResize = DocumentKindTreeListResize
      object DocumentKindNameColumn: TcxDBTreeListColumn
        Visible = False
        Caption.AlignHorz = taCenter
        Caption.Text = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
        DataBinding.FieldName = 'name'
        Width = 217
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
  object PanelForDocumentRecordsAndCard: TPanel
    Left = 296
    Top = 0
    Width = 769
    Height = 726
    Align = alClient
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 1
    object SeparatorBetweenDocumentRecordsAndDocumentCard: TSplitter
      Left = 0
      Top = 248
      Width = 769
      Height = 6
      Cursor = crVSplit
      Align = alTop
      Color = clGradientInactiveCaption
      ParentColor = False
      ExplicitWidth = 505
    end
    object DocumentListPanel: TPanel
      Left = 0
      Top = 0
      Width = 769
      Height = 248
      Align = alTop
      BevelOuter = bvNone
      BiDiMode = bdLeftToRight
      Color = clWindow
      ParentBiDiMode = False
      ParentBackground = False
      TabOrder = 0
      OnResize = DocumentListPanelResize
      object DocumentListLabel: TLabel
        Left = 167
        Top = 7
        Width = 73
        Height = 13
        Caption = #1044#1086#1082#1091#1084#1077#1085#1090#1099':'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object DocumentRecordsGridPanel: TPanel
        Left = 0
        Top = 26
        Width = 769
        Height = 222
        Align = alBottom
        Anchors = [akLeft, akTop, akRight, akBottom]
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 0
      end
    end
    object DocumentCardPanel: TPanel
      Left = 0
      Top = 254
      Width = 769
      Height = 472
      Align = alClient
      BevelOuter = bvNone
      Color = clInactiveCaptionText
      ParentBackground = False
      TabOrder = 1
      OnResize = DocumentCardPanelResize
      object DocumentCardLabel: TLabel
        Left = 142
        Top = 6
        Width = 128
        Height = 13
        Caption = #1050#1072#1088#1090#1086#1095#1082#1072' '#1076#1086#1082#1091#1084#1077#1085#1090#1072':'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        Visible = False
      end
      object DocumentCardFormPanel: TPanel
        Left = 0
        Top = 0
        Width = 769
        Height = 472
        Align = alClient
        BevelOuter = bvNone
        Color = clWindow
        ParentBackground = False
        TabOrder = 0
      end
    end
  end
  object DocumentTypesDataSource: TDataSource
    Left = 16
    Top = 544
  end
end
