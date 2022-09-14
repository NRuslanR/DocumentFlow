object frxDocumentPrintFormReports: TfrxDocumentPrintFormReports
  OldCreateOrder = False
  Height = 343
  Width = 699
  object ServiceNotePrintFormReport: TfrxReport
    Version = '4.8.27'
    DotMatrixReport = False
    IniFile = '\Software\Fast Reports'
    PreviewOptions.Buttons = [pbPrint, pbLoad, pbSave, pbExport, pbZoom, pbFind, pbOutline, pbPageSetup, pbTools, pbEdit, pbNavigator]
    PreviewOptions.Zoom = 1.000000000000000000
    PrintOptions.Printer = #1055#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102
    PrintOptions.PrintOnSheet = 0
    ReportOptions.CreateDate = 43641.633046701400000000
    ReportOptions.LastChange = 43641.633046701400000000
    ScriptLanguage = 'PascalScript'
    ScriptText.Strings = (
      'begin'
      ''
      'end.')
    Left = 72
    Top = 16
    Datasets = <
      item
        DataSet = ServiceNoteContentReportDataSet
        DataSetName = 'frxDBDataset1'
      end
      item
        DataSet = frxDocumentApprovingListRecordSet
        DataSetName = 'frxDocumentApprovingListRecordSet'
      end
      item
        DataSet = frxDocumentApprovingListSet
        DataSetName = 'frxDocumentApprovingListSet'
      end>
    Variables = <
      item
        Name = ' Service Note Print Form Variables'
        Value = Null
      end
      item
        Name = 'DepartmentFullName'
        Value = Null
      end
      item
        Name = 'PerformerInfoList'
        Value = #39#39
      end
      item
        Name = 'ServiceNoteNumber'
        Value = Null
      end
      item
        Name = 'ServiceNoteContent'
        Value = Null
      end
      item
        Name = 'LeaderSpeciality'
        Value = Null
      end
      item
        Name = 'LeaderFullName'
        Value = Null
      end
      item
        Name = 'PerformerFullName'
        Value = Null
      end
      item
        Name = 'PerformerTelephoneNumber'
        Value = Null
      end
      item
        Name = 'ServiceNoteCreationDate'
        Value = Null
      end
      item
        Name = 'ProgrammaticalySignedLabel'
        Value = #39#39
      end
      item
        Name = 'ActualSignerName'
        Value = #39#39
      end
      item
        Name = 'ApprovingListTitle'
        Value = #39#39
      end
      item
        Name = 'ForAcquaintanceLabel'
        Value = Null
      end
      item
        Name = 'AcquainterInfoList'
        Value = Null
      end>
    Style = <>
    object Data: TfrxDataPage
      Height = 1000.000000000000000000
      Width = 1000.000000000000000000
    end
    object Page1: TfrxReportPage
      PaperWidth = 210.000000000000000000
      PaperHeight = 297.000000000000000000
      PaperSize = 9
      LeftMargin = 10.000000000000000000
      RightMargin = 10.000000000000000000
      TopMargin = 10.000000000000000000
      BottomMargin = 10.000000000000000000
      object ReportTitle1: TfrxReportTitle
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        Height = 177.637910000000000000
        ParentFont = False
        Top = 18.897650000000000000
        Width = 718.110700000000000000
        Stretched = True
        object Memo3: TfrxMemoView
          Left = 37.795300000000000000
          Top = 64.252010000000000000
          Width = 264.567100000000000000
          Height = 22.677180000000000000
          ShowHint = False
          StretchMode = smActualHeight
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -19
          Font.Name = 'Times New Roman'
          Font.Style = []
          Memo.UTF8 = (
            '[DepartmentFullName]')
          ParentFont = False
          WordBreak = True
        end
        object Memo1: TfrxMemoView
          Left = 37.795300000000000000
          Top = 37.795300000000000000
          Width = 102.047310000000000000
          Height = 18.897650000000000000
          ShowHint = False
          StretchMode = smActualHeight
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -19
          Font.Name = 'Times New Roman'
          Font.Style = [fsBold]
          Memo.UTF8 = (
            #1056#1106#1056#1115' '#1042#171#1056#1032#1056#1114#1056#8212#1042#187)
          ParentFont = False
        end
        object Memo2: TfrxMemoView
          Left = 491.338900000000000000
          Top = 37.795300000000000000
          Width = 188.976500000000000000
          Height = 18.897650000000000000
          ShowHint = False
          StretchMode = smActualHeight
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -19
          Font.Name = 'Times New Roman'
          Font.Style = []
          Memo.UTF8 = (
            '[PerformerInfoList]')
          ParentFont = False
          WordBreak = True
        end
        object Memo4: TfrxMemoView
          ShiftMode = smWhenOverlapped
          Left = 75.590600000000000000
          Top = 132.283550000000000000
          Width = 604.724800000000000000
          Height = 18.897650000000000000
          ShowHint = False
          StretchMode = smActualHeight
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -19
          Font.Name = 'Times New Roman'
          Font.Style = [fsBold]
          Memo.UTF8 = (
            #1056#1038#1056#8250#1056#1032#1056#8211#1056#8226#1056#8216#1056#1116#1056#1106#1056#1031'  '#1056#8212#1056#1106#1056#1119#1056#152#1056#1038#1056#1113#1056#1106)
          ParentFont = False
        end
        object Memo5: TfrxMemoView
          ShiftMode = smWhenOverlapped
          Left = 317.480520000000000000
          Top = 132.283550000000000000
          Width = 408.189240000000000000
          Height = 18.897650000000000000
          ShowHint = False
          StretchMode = smActualHeight
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -19
          Font.Name = 'Times New Roman'
          Font.Style = []
          Memo.UTF8 = (
            #1074#8222#8211)
          ParentFont = False
        end
        object Memo6: TfrxMemoView
          ShiftMode = smWhenOverlapped
          Left = 343.937230000000000000
          Top = 132.283550000000000000
          Width = 385.512060000000000000
          Height = 18.897650000000000000
          ShowHint = False
          StretchMode = smActualHeight
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -19
          Font.Name = 'Times New Roman'
          Font.Style = []
          Memo.UTF8 = (
            '[ServiceNoteNumber]')
          ParentFont = False
        end
        object Memo7: TfrxMemoView
          ShiftMode = smWhenOverlapped
          Left = 75.590600000000000000
          Top = 158.740260000000000000
          Width = 604.724800000000000000
          Height = 18.897650000000000000
          ShowHint = False
          StretchMode = smActualHeight
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -19
          Font.Name = 'Times New Roman'
          Font.Style = []
          Memo.UTF8 = (
            #1056#1109#1057#8218' [ServiceNoteDate] '#1056#1110'. ')
          ParentFont = False
        end
        object ForAcquaintanceMemo: TfrxMemoView
          ShiftMode = smWhenOverlapped
          Left = 377.953000000000000000
          Top = 75.590600000000000000
          Width = 158.740260000000000000
          Height = 18.897650000000000000
          ShowHint = False
          StretchMode = smActualHeight
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -19
          Font.Name = 'Times New Roman'
          Font.Style = []
          GapY = 15.000000000000000000
          HAlign = haCenter
          Memo.UTF8 = (
            '[ForAcquaintanceLabel]')
          ParentFont = False
        end
        object AcquainterInfoListMemo: TfrxMemoView
          ShiftMode = smWhenOverlapped
          Left = 491.338900000000000000
          Top = 75.590600000000000000
          Width = 188.976500000000000000
          Height = 18.897650000000000000
          ShowHint = False
          StretchMode = smActualHeight
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -19
          Font.Name = 'Times New Roman'
          Font.Style = []
          GapY = 15.000000000000000000
          Memo.UTF8 = (
            '[AcquainterInfoList]')
          ParentFont = False
        end
      end
      object MasterData1: TfrxMasterData
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -16
        Font.Name = 'Arial'
        Font.Style = []
        Height = 60.472480000000000000
        ParentFont = False
        Top = 257.008040000000000000
        Width = 718.110700000000000000
        AllowSplit = True
        DataSet = ServiceNoteContentReportDataSet
        DataSetName = 'frxDBDataset1'
        RowCount = 0
        Stretched = True
        object Memo8: TfrxMemoView
          ShiftMode = smDontShift
          Left = 75.590600000000000000
          Top = 22.677180000000000000
          Width = 604.724800000000000000
          Height = 37.795300000000000000
          ShowHint = False
          StretchMode = smActualHeight
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -19
          Font.Name = 'Times New Roman'
          Font.Style = []
          HAlign = haBlock
          LineSpacing = 8.000000000000000000
          Memo.UTF8 = (
            '[frxDBDataSet1."content"]')
          ParentFont = False
          WordBreak = True
        end
      end
      object Footer1: TfrxFooter
        Height = 83.149660000000000000
        Top = 340.157700000000000000
        Width = 718.110700000000000000
        Stretched = True
        object Memo9: TfrxMemoView
          ShiftMode = smWhenOverlapped
          Left = 37.795300000000000000
          Top = 11.338590000000000000
          Width = 192.756030000000000000
          Height = 41.574830000000000000
          ShowHint = False
          StretchMode = smActualHeight
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -19
          Font.Name = 'Times New Roman'
          Font.Style = []
          Memo.UTF8 = (
            '[LeaderSpeciality]')
          ParentFont = False
        end
        object Memo10: TfrxMemoView
          ShiftMode = smWhenOverlapped
          Left = 442.205010000000000000
          Top = 11.338590000000000000
          Width = 215.433210000000000000
          Height = 49.133890000000000000
          ShowHint = False
          StretchMode = smActualHeight
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -19
          Font.Name = 'Times New Roman'
          Font.Style = []
          Memo.UTF8 = (
            '[LeaderFullName]')
          ParentFont = False
        end
        object Memo13: TfrxMemoView
          ShiftMode = smWhenOverlapped
          Left = -26.456710000000000000
          Top = 30.236240000000000000
          Width = 718.110700000000000000
          Height = 18.897650000000000000
          ShowHint = False
          StretchMode = smActualHeight
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -16
          Font.Name = 'Times New Roman'
          Font.Style = [fsBold, fsItalic]
          HAlign = haCenter
          Memo.UTF8 = (
            '[ProgrammaticalySignedLabel]')
          ParentFont = False
        end
        object Memo14: TfrxMemoView
          ShiftMode = smWhenOverlapped
          Left = -26.456710000000000000
          Top = 52.913420000000000000
          Width = 718.110700000000000000
          Height = 22.677180000000000000
          ShowHint = False
          StretchMode = smActualHeight
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -16
          Font.Name = 'Times New Roman'
          Font.Style = [fsBold, fsItalic]
          HAlign = haCenter
          Memo.UTF8 = (
            '[ActualSignerName]')
          ParentFont = False
        end
      end
      object ApprovingListsBand: TfrxMasterData
        Height = 45.354360000000000000
        Top = 445.984540000000000000
        Width = 718.110700000000000000
        DataSet = frxDocumentApprovingListSet
        DataSetName = 'frxDocumentApprovingListSet'
        KeepTogether = True
        RowCount = 0
        Stretched = True
        object Memo15: TfrxMemoView
          Left = 37.795300000000000000
          Top = 11.338590000000000000
          Width = 253.228510000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -19
          Font.Name = 'Times New Roman'
          Font.Style = [fsBold]
          Memo.UTF8 = (
            '[frxDocumentApprovingListSet."title"]')
          ParentFont = False
        end
      end
      object ReportSummary1: TfrxReportSummary
        Height = 75.590600000000000000
        Top = 616.063390000000000000
        Width = 718.110700000000000000
        Stretched = True
        object Memo11: TfrxMemoView
          ShiftMode = smWhenOverlapped
          Left = 37.795300000000000000
          Top = 18.897650000000000000
          Width = 188.976500000000000000
          Height = 18.897650000000000000
          ShowHint = False
          StretchMode = smActualHeight
          AutoWidth = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -16
          Font.Name = 'Times New Roman'
          Font.Style = []
          Memo.UTF8 = (
            #1056#1105#1057#1027#1056#1111'. [PerformerFullName]')
          ParentFont = False
        end
        object Memo12: TfrxMemoView
          Left = 37.795300000000000000
          Top = 37.795300000000000000
          Width = 234.330860000000000000
          Height = 18.897650000000000000
          ShowHint = False
          StretchMode = smActualHeight
          AutoWidth = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -16
          Font.Name = 'Times New Roman'
          Font.Style = []
          Memo.UTF8 = (
            #1057#8218#1056#181#1056#187'. [PerformerTelephoneNumber]')
          ParentFont = False
        end
      end
      object ApprovingListRecordDetailBand: TfrxDetailData
        Height = 41.574830000000000000
        Top = 514.016080000000000000
        Width = 718.110700000000000000
        DataSet = frxDocumentApprovingListRecordSet
        DataSetName = 'frxDocumentApprovingListRecordSet'
        RowCount = 0
        Stretched = True
        object Memo16: TfrxMemoView
          ShiftMode = smWhenOverlapped
          Left = 480.000310000000000000
          Top = 15.118120000000000000
          Width = 162.519790000000000000
          Height = 18.897650000000000000
          ShowHint = False
          StretchMode = smActualHeight
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -19
          Font.Name = 'Times New Roman'
          Font.Style = []
          Memo.UTF8 = (
            '[frxDocumentApprovingListRecordSet."approver_name"]')
          ParentFont = False
        end
        object Memo17: TfrxMemoView
          ShiftMode = smWhenOverlapped
          Left = 75.590600000000000000
          Top = 15.118120000000000000
          Width = 192.756030000000000000
          Height = 18.897650000000000000
          ShowHint = False
          StretchMode = smActualHeight
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -19
          Font.Name = 'Times New Roman'
          Font.Style = []
          Memo.UTF8 = (
            '[frxDocumentApprovingListRecordSet."approver_speciality"]')
          ParentFont = False
        end
        object Memo18: TfrxMemoView
          ShiftMode = smWhenOverlapped
          Left = 285.354515000000000000
          Top = 15.118120000000000000
          Width = 177.637910000000000000
          Height = 18.897650000000000000
          ShowHint = False
          StretchMode = smActualHeight
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -16
          Font.Name = 'Times New Roman'
          Font.Style = [fsBold, fsItalic]
          HAlign = haCenter
          Memo.UTF8 = (
            '[frxDocumentApprovingListRecordSet."approving_result_name"]')
          ParentFont = False
        end
      end
    end
    object DialogPage1: TfrxDialogPage
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      Height = 407.000000000000000000
      ClientHeight = 368.000000000000000000
      Left = 381.000000000000000000
      Top = 147.000000000000000000
      Width = 673.000000000000000000
      ClientWidth = 657.000000000000000000
    end
  end
  object ServiceNoteContentReportDataSet: TfrxDBDataset
    UserName = 'frxDBDataset1'
    CloseDataSource = False
    DataSource = ServiceNoteContentDataSource
    BCDToCurrency = False
    Left = 256
    Top = 16
  end
  object ServiceNoteContentDataSource: TDataSource
    DataSet = ContentDataSet
    Left = 432
    Top = 16
  end
  object ContentDataSet: TdxMemData
    Active = True
    Indexes = <>
    SortOptions = []
    Left = 560
    Top = 16
    object ContentDataSetcontent: TStringField
      FieldName = 'content'
      Size = 16384
    end
  end
  object DocumentPrintFormPDFExport: TfrxPDFExport
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
    Left = 72
    Top = 280
  end
  object DocumentPrintFormRTFExport: TfrxRTFExport
    UseFileCache = True
    ShowProgress = True
    OverwritePrompt = False
    ExportEMF = True
    Wysiwyg = True
    Creator = 'FastReport'
    SuppressPageHeadersFooters = False
    HeaderFooterMode = hfText
    AutoSize = False
    Left = 232
    Top = 280
  end
  object frxDocumentApprovingListRecordSet: TfrxDBDataset
    UserName = 'frxDocumentApprovingListRecordSet'
    CloseDataSource = False
    DataSource = DocumentApprovingListRecordSource
    BCDToCurrency = False
    Left = 80
    Top = 176
  end
  object DocumentApprovingListRecordSource: TDataSource
    DataSet = DocumentApprovingListRecordSet
    Left = 288
    Top = 176
  end
  object frxDocumentApprovingListSet: TfrxDBDataset
    UserName = 'frxDocumentApprovingListSet'
    CloseDataSource = False
    DataSource = DocumentApprovingListSource
    BCDToCurrency = False
    Left = 72
    Top = 96
  end
  object DocumentApprovingListSource: TDataSource
    DataSet = DocumentApprovingListSet
    Left = 280
    Top = 96
  end
  object DocumentApprovingListSet: TClientDataSet
    Active = True
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'title'
        DataType = ftString
        Size = 100
      end>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    Left = 504
    Top = 96
    Data = {
      340000009619E0BD010000001800000001000000000003000000340005746974
      6C6501004900000001000557494454480200020064000000}
    object DocumentApprovingListSettitle: TStringField
      FieldName = 'title'
      Size = 100
    end
  end
  object DocumentApprovingListRecordSet: TClientDataSet
    Active = True
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'title'
        DataType = ftString
        Size = 200
      end
      item
        Name = 'approver_name'
        DataType = ftString
        Size = 250
      end
      item
        Name = 'approver_speciality'
        DataType = ftString
        Size = 300
      end
      item
        Name = 'approving_result_name'
        DataType = ftString
        Size = 50
      end>
    IndexDefs = <>
    IndexFieldNames = 'title'
    MasterFields = 'title'
    MasterSource = DocumentApprovingListSource
    Params = <>
    StoreDefs = True
    Left = 504
    Top = 176
    Data = {
      A80000009619E0BD010000001800000004000000000003000000A80005746974
      6C65010049000000010005574944544802000200C8000D617070726F7665725F
      6E616D65010049000000010005574944544802000200FA0013617070726F7665
      725F7370656369616C6974790200490000000100055749445448020002002C01
      15617070726F76696E675F726573756C745F6E616D6501004900000001000557
      494454480200020032000000}
    object DocumentApprovingListRecordSettitle: TStringField
      FieldName = 'title'
      Size = 200
    end
    object DocumentApprovingListRecordSetapprover_speciality: TStringField
      FieldName = 'approver_speciality'
      Size = 300
    end
    object DocumentApprovingListRecordSetapproving_result_name: TStringField
      FieldName = 'approving_result_name'
      Size = 50
    end
    object DocumentApprovingListRecordSetapprover_name: TStringField
      FieldName = 'approver_name'
      Size = 250
    end
  end
end
