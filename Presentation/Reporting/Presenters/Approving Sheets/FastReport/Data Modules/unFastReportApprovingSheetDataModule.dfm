object FastReportApprovingSheetDataModule: TFastReportApprovingSheetDataModule
  OldCreateOrder = False
  Height = 309
  Width = 659
  object ApprovingSheetReport: TfrxReport
    Version = '4.8.27'
    DotMatrixReport = False
    IniFile = '\Software\Fast Reports'
    PreviewOptions.Buttons = [pbPrint, pbLoad, pbSave, pbExport, pbZoom, pbFind, pbOutline, pbPageSetup, pbTools, pbEdit, pbNavigator, pbExportQuick]
    PreviewOptions.Zoom = 1.000000000000000000
    PrintOptions.Printer = #1055#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102
    PrintOptions.PrintOnSheet = 0
    ReportOptions.CreateDate = 44194.526449675900000000
    ReportOptions.LastChange = 44265.648637037040000000
    ScriptLanguage = 'PascalScript'
    ScriptText.Strings = (
      'begin'
      ''
      'end.')
    Left = 48
    Top = 16
    Datasets = <
      item
        DataSet = ApprovingSet
        DataSetName = 'ApprovingSet'
      end>
    Variables = <
      item
        Name = ' Approving Sheet Title'
        Value = Null
      end
      item
        Name = 'DocumentKindName'
        Value = ''
      end
      item
        Name = 'DocumentName'
        Value = ''
      end
      item
        Name = ' Approving List'
        Value = Null
      end
      item
        Name = 'IsApprovedWithNotes'
        Value = ''
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
        Height = 102.047310000000000000
        Top = 18.897650000000000000
        Width = 718.110700000000000000
        Stretched = True
        object Memo1: TfrxMemoView
          Align = baCenter
          Left = 251.338745000000000000
          Top = 18.897650000000000000
          Width = 215.433210000000000000
          Height = 22.677180000000000000
          ShowHint = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -19
          Font.Name = 'Arial'
          Font.Style = []
          Memo.UTF8 = (
            #1056#8250#1056#152#1056#1038#1056#1118' '#1056#1038#1056#1115#1056#8220#1056#8250#1056#1106#1056#1038#1056#1115#1056#8217#1056#1106#1056#1116#1056#152#1056#1031)
          ParentFont = False
        end
        object Memo2: TfrxMemoView
          Left = 597.165740000000000000
          Width = 83.149660000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Memo.UTF8 = (
            '('#1057#1036#1056#187#1056#181#1056#1108#1057#8218#1057#1026#1056#1109#1056#1029#1056#1029#1056#1109')')
          ParentFont = False
        end
        object Memo5: TfrxMemoView
          Align = baCenter
          Left = 102.047310000000000000
          Top = 49.133890000000000000
          Width = 514.016080000000000000
          Height = 22.677180000000000000
          ShowHint = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -16
          Font.Name = 'Arial'
          Font.Style = []
          Memo.UTF8 = (
            
              #1056#1108' [DocumentKindName] '#1056#1109#1057#8218' "____" ____________ 20___'#1056#1110'. '#1074#8222#8211' ____' +
              '____')
          ParentFont = False
        end
        object Memo3: TfrxMemoView
          Align = baCenter
          Left = 292.913575000000000000
          Top = 79.370130000000000000
          Width = 132.283550000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -16
          Font.Name = 'Arial'
          Font.Style = []
          Memo.UTF8 = (
            '[DocumentName]')
          ParentFont = False
        end
      end
      object Header1: TfrxHeader
        Height = 41.574830000000000000
        Top = 181.417440000000000000
        Width = 718.110700000000000000
        Stretched = True
        object Memo10: TfrxMemoView
          Left = 536.693260000000000000
          Width = 181.417440000000000000
          Height = 41.574830000000000000
          ShowHint = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -16
          Font.Name = 'Arial'
          Font.Style = []
          HAlign = haCenter
          Memo.UTF8 = (
            #1056#8212#1056#176#1056#1112#1056#181#1057#8225'. '#1057#1107#1057#1027#1057#8218#1057#1026#1056#176#1056#1029#1056#181#1056#1029#1057#8249
            '   '#1056#1111#1056#1109#1056#1169#1056#1111#1056#1105#1057#1027#1057#1034', '#1056#1169#1056#176#1057#8218#1056#176)
          ParentFont = False
        end
      end
      object ApprovingListBand: TfrxMasterData
        Height = 56.692950000000000000
        Top = 245.669450000000000000
        Width = 718.110700000000000000
        DataSet = ApprovingSet
        DataSetName = 'ApprovingSet'
        RowCount = 0
        Stretched = True
        object ApproverSpecialityMemo: TfrxMemoView
          ShiftMode = smWhenOverlapped
          Top = 18.897650000000000000
          Width = 207.874150000000000000
          Height = 22.677180000000000000
          ShowHint = False
          StretchMode = smActualHeight
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -16
          Font.Name = 'Arial'
          Font.Style = []
          Memo.UTF8 = (
            'approver_speciality')
          ParentFont = False
        end
        object ApprovingPerformingResultNameMemo: TfrxMemoView
          Left = 249.448980000000000000
          Top = 18.897650000000000000
          Width = 109.606370000000000000
          Height = 18.897650000000000000
          ShowHint = False
          StretchMode = smActualHeight
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold, fsItalic]
          HAlign = haRight
          Highlight.Font.Charset = DEFAULT_CHARSET
          Highlight.Font.Color = clBlack
          Highlight.Font.Height = -13
          Highlight.Font.Name = 'Arial'
          Highlight.Font.Style = [fsBold, fsItalic, fsUnderline]
          Highlight.Condition = '<ApprovingSet."is_approved_with_notes"> = true'
          Memo.UTF8 = (
            'approving_performing_result_name')
          ParentFont = False
        end
        object ApprovingPerformingDateMemo: TfrxMemoView
          Left = 249.448980000000000000
          Top = 37.795300000000000000
          Width = 109.606370000000000000
          Height = 18.897650000000000000
          ShowHint = False
          StretchMode = smActualHeight
          HAlign = haRight
          HideZeros = True
          Memo.UTF8 = (
            'approving_performing_date')
        end
        object ApproverNameMemo: TfrxMemoView
          Left = 396.850650000000000000
          Top = 18.897650000000000000
          Width = 139.842610000000000000
          Height = 22.677180000000000000
          ShowHint = False
          StretchMode = smActualHeight
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -16
          Font.Name = 'Arial'
          Font.Style = []
          Memo.UTF8 = (
            'approver_name')
          ParentFont = False
        end
        object IsApprovedWithNotesMemo: TfrxMemoView
          ShiftMode = smDontShift
          Top = 41.574830000000000000
          Width = 151.181200000000000000
          Height = 15.118120000000000000
          Visible = False
          ShowHint = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          HAlign = haRight
          Memo.UTF8 = (
            '[is_approved_with_notes]')
          ParentFont = False
        end
      end
    end
  end
  object ApprovingSet: TfrxDBDataset
    UserName = 'ApprovingSet'
    CloseDataSource = False
    BCDToCurrency = False
    Left = 160
    Top = 16
  end
  object ApprovingSetDataSource: TDataSource
    Left = 288
    Top = 16
  end
end
