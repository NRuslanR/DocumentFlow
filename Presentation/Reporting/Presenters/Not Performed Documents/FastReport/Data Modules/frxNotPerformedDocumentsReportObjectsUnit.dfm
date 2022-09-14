object frxNotPerformedDocumentsReportObjects: TfrxNotPerformedDocumentsReportObjects
  OldCreateOrder = False
  Height = 369
  Width = 714
  object NotPerformedDocumentsReport: TfrxReport
    Version = '4.8.27'
    DotMatrixReport = False
    IniFile = '\Software\Fast Reports'
    PreviewOptions.AllowEdit = False
    PreviewOptions.Buttons = [pbPrint, pbLoad, pbSave, pbExport, pbZoom, pbFind, pbOutline, pbPageSetup, pbTools, pbEdit, pbNavigator, pbExportQuick]
    PreviewOptions.Zoom = 1.000000000000000000
    PrintOptions.Printer = #1055#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102
    PrintOptions.PrintOnSheet = 0
    ReportOptions.CreateDate = 43612.601939201400000000
    ReportOptions.LastChange = 44169.408067129600000000
    ScriptLanguage = 'PascalScript'
    ScriptText.Strings = (
      'begin'
      ''
      'end.')
    Left = 72
    Top = 16
    Datasets = <
      item
        DataSet = NotPerformedDocumentsReportDataSet
        DataSetName = 'frxDBDataset1'
      end>
    Variables = <
      item
        Name = ' Period'
        Value = Null
      end
      item
        Name = 'PeriodStart'
        Value = Null
      end
      item
        Name = 'PeriodEnd'
        Value = Null
      end
      item
        Name = ' Department'
        Value = Null
      end
      item
        Name = 'ReportCreationDepartment'
        Value = Null
      end
      item
        Name = ' NotPerformedDocumentCount'
        Value = Null
      end
      item
        Name = 'NotPerformedDocumentCount'
        Value = Null
      end>
    Style = <>
    object Data: TfrxDataPage
      Height = 1000.000000000000000000
      Width = 1000.000000000000000000
    end
    object Page1: TfrxReportPage
      Orientation = poLandscape
      PaperWidth = 297.000000000000000000
      PaperHeight = 210.000000000000000000
      PaperSize = 9
      LeftMargin = 10.000000000000000000
      RightMargin = 10.000000000000000000
      TopMargin = 10.000000000000000000
      BottomMargin = 10.000000000000000000
      object ReportTitle1: TfrxReportTitle
        Height = 18.897650000000000000
        Top = 18.897650000000000000
        Width = 1046.929810000000000000
        object SysMemo1: TfrxSysMemoView
          ShiftMode = smWhenOverlapped
          Width = 113.385900000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Memo.UTF8 = (
            '[DATE]')
        end
        object SysMemo2: TfrxSysMemoView
          ShiftMode = smWhenOverlapped
          Left = 75.590600000000000000
          Width = 113.385900000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Memo.UTF8 = (
            '[TIME]')
        end
      end
      object Header1: TfrxHeader
        Height = 22.677180000000000000
        Top = 143.622140000000000000
        Width = 1046.929810000000000000
        ReprintOnNewPage = True
        object Memo6: TfrxMemoView
          Width = 86.929190000000000000
          Height = 22.677180000000000000
          ShowHint = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8 = (
            #1074#8222#8211)
          ParentFont = False
        end
        object Memo7: TfrxMemoView
          Left = 86.929190000000000000
          Width = 71.811070000000000000
          Height = 22.677180000000000000
          ShowHint = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8 = (
            #1056#8221#1056#176#1057#8218#1056#176' '#1056#1169#1056#1109#1056#1108'.')
          ParentFont = False
        end
        object Memo8: TfrxMemoView
          Left = 158.740260000000000000
          Width = 309.921460000000000000
          Height = 22.677180000000000000
          ShowHint = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8 = (
            #1056#1116#1056#176#1056#1105#1056#1112#1056#181#1056#1029#1056#1109#1056#1030#1056#176#1056#1029#1056#1105#1056#181)
          ParentFont = False
        end
        object Memo14: TfrxMemoView
          Left = 468.661720000000000000
          Width = 147.401670000000000000
          Height = 22.677180000000000000
          ShowHint = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8 = (
            #1056#160#1057#1107#1056#1108#1056#1109#1056#1030#1056#1109#1056#1169#1056#1105#1057#8218#1056#181#1056#187#1057#1034)
          ParentFont = False
        end
        object Memo17: TfrxMemoView
          Left = 616.063390000000000000
          Width = 430.866420000000000000
          Height = 22.677180000000000000
          ShowHint = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8 = (
            #1056#1119#1056#1109#1056#187#1057#1107#1057#8225#1056#176#1057#8218#1056#181#1056#187#1056#1105)
          ParentFont = False
        end
      end
      object MasterData1: TfrxMasterData
        Height = 22.677180000000000000
        Top = 188.976500000000000000
        Width = 1046.929810000000000000
        DataSet = NotPerformedDocumentsReportDataSet
        DataSetName = 'frxDBDataset1'
        RowCount = 0
        Stretched = True
        object NumberMemo: TfrxMemoView
          Width = 86.929190000000000000
          Height = 22.677180000000000000
          ShowHint = False
          StretchMode = smMaxHeight
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8 = (
            '[frxDBDataset1."outcomming_number"]')
          ParentFont = False
        end
        object CreationDateMemo: TfrxMemoView
          Left = 86.929190000000000000
          Width = 71.811070000000000000
          Height = 22.677180000000000000
          ShowHint = False
          StretchMode = smMaxHeight
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8 = (
            '[frxDBDataset1."creation_date"]')
          ParentFont = False
        end
        object NameMemo: TfrxMemoView
          Left = 158.740260000000000000
          Width = 309.921460000000000000
          Height = 22.677180000000000000
          ShowHint = False
          StretchMode = smMaxHeight
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8 = (
            '[frxDBDataSet1."name"]')
          ParentFont = False
        end
        object LeaderNameMemo: TfrxMemoView
          Left = 468.661720000000000000
          Width = 147.401670000000000000
          Height = 22.677180000000000000
          ShowHint = False
          StretchMode = smMaxHeight
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8 = (
            '[frxDBDataSet1."leader_short_name"]')
          ParentFont = False
        end
        object PerformerNamesMemo: TfrxMemoView
          Left = 616.063390000000000000
          Width = 430.866420000000000000
          Height = 22.677180000000000000
          ShowHint = False
          StretchMode = smMaxHeight
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8 = (
            '[frxDBDataSet1."performer_short_names"]')
          ParentFont = False
        end
      end
      object PageHeader1: TfrxPageHeader
        Height = 22.677180000000000000
        Top = 60.472480000000000000
        Width = 1046.929810000000000000
        object Memo1: TfrxMemoView
          Width = 1046.929810000000000000
          Height = 22.677180000000000000
          ShowHint = False
          Memo.UTF8 = (
            
              #1056#1116#1056#181' '#1056#1030#1057#8249#1056#1111#1056#1109#1056#187#1056#1029#1056#181#1056#1029#1056#1029#1057#8249#1056#181' '#1056#1169#1056#1109#1056#1108#1057#1107#1056#1112#1056#181#1056#1029#1057#8218#1057#8249' '#1056#183#1056#176' '#1056#1111#1056#181#1057#1026#1056#1105#1056#1109#1056#1169 +
              ' '#1057#1027' [PeriodStart] '#1056#1111#1056#1109' [PeriodEnd] '#1056#1110'.')
        end
        object Memo5: TfrxMemoView
          Left = 453.543600000000000000
          Width = 600.945270000000000000
          Height = 22.677180000000000000
          ShowHint = False
          Memo.UTF8 = (
            '[ReportCreationDepartment]')
        end
      end
      object PageFooter1: TfrxPageFooter
        Height = 22.677180000000000000
        Top = 336.378170000000000000
        Width = 1046.929810000000000000
        object SysMemo3: TfrxSysMemoView
          Top = 3.779530000000020000
          Width = 1046.929810000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          HAlign = haCenter
          Memo.UTF8 = (
            '[PAGE#]')
          ParentFont = False
        end
      end
      object ReportSummary1: TfrxReportSummary
        Height = 41.574830000000000000
        Top = 272.126160000000000000
        Width = 1046.929810000000000000
        object Memo9: TfrxMemoView
          Top = 18.897650000000000000
          Width = 1046.929810000000000000
          Height = 22.677180000000000000
          ShowHint = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          HAlign = haRight
          Memo.UTF8 = (
            
              #1056#1115#1056#177#1057#8240#1056#181#1056#181' '#1056#1108#1056#1109#1056#187'-'#1056#1030#1056#1109' '#1056#1029#1056#181' '#1056#1030#1057#8249#1056#1111#1056#1109#1056#187#1056#1029#1056#181#1056#1029#1056#1029#1057#8249#1057#8230' '#1056#1169#1056#1109#1056#1108#1057#1107#1056#1112#1056#181#1056 +
              #1029#1057#8218#1056#1109#1056#1030': [NotPerformedDocumentCount]')
          ParentFont = False
        end
      end
    end
  end
  object NotPerformedDocumentsReportDataSet: TfrxDBDataset
    UserName = 'frxDBDataset1'
    CloseDataSource = False
    DataSource = NotPerformedDocumentsDataSource
    BCDToCurrency = False
    Left = 272
    Top = 16
  end
  object NotPerformedDocumentsDataSource: TDataSource
    Left = 480
    Top = 16
  end
  object NotPerformedDocumentsReportPDFExport: TfrxPDFExport
    UseFileCache = True
    ShowProgress = True
    OverwritePrompt = False
    PrintOptimized = False
    Outline = False
    Background = False
    HTMLTags = True
    Author = 'FastReport'
    Subject = 'FastReport PDF export'
    ProtectionFlags = [ePrint, eModify, eCopy, eAnnot]
    HideToolbar = False
    HideMenubar = False
    HideWindowUI = False
    FitWindow = False
    CenterWindow = False
    PrintScaling = False
    Left = 96
    Top = 296
  end
  object NotPerformedDocumentsReportRTFExport: TfrxRTFExport
    UseFileCache = True
    ShowProgress = True
    OverwritePrompt = False
    ExportEMF = True
    Wysiwyg = True
    Creator = 'FastReport'
    SuppressPageHeadersFooters = False
    HeaderFooterMode = hfText
    AutoSize = False
    Left = 320
    Top = 296
  end
end
