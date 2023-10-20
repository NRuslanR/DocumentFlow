inherited DocumentChargeSheetsFrame: TDocumentChargeSheetsFrame
  inherited ScrollBox: TScrollBox
    inherited DocumentInfoPanel: TPanel
      Width = 849
      ExplicitWidth = 849
      inherited ChargeTreeList: TcxDBTreeList
        Width = 849
        Margins.Left = 0
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 0
        OptionsBehavior.ExpandOnDblClick = False
        TabOrder = 1
        OnDblClick = ChargeTreeListDblClick
        ExplicitWidth = 849
        inherited PerformerFullNameColumn: TcxDBTreeListColumn
          Width = 82
        end
        inherited PerformerSpecialityColumn: TcxDBTreeListColumn
          Width = 83
          Position.ColIndex = 3
        end
        inherited PerformerDepartmentNameColumn: TcxDBTreeListColumn
          Visible = False
          Position.ColIndex = 13
        end
        inherited PerformerResolutionColumn: TcxDBTreeListColumn
          Width = 82
          Position.ColIndex = 6
        end
        inherited PerformerIdColumn: TcxDBTreeListColumn
          Position.ColIndex = 7
        end
        inherited IdColumn: TcxDBTreeListColumn
          Position.ColIndex = 8
        end
        inherited PerformingDateTimeColumn: TcxDBTreeListColumn
          Position.ColIndex = 9
        end
        inherited RecordStatusColumn: TcxDBTreeListColumn
          Position.ColIndex = 10
        end
        inherited IsPerformerForeignColumn: TcxDBTreeListColumn
          Position.ColIndex = 11
        end
        inherited PerformedEmployeeNameColumn: TcxDBTreeListColumn
          Width = 73
          Position.ColIndex = 12
        end
        inherited IsForAcquaitanceColumn: TcxDBTreeListColumn
          Options.Editing = False
          Width = 83
        end
        inherited ChargeTextColumn: TcxDBTreeListColumn
          Visible = True
          Options.Customizing = True
          Width = 83
        end
        object ViewDateByPerformerColumn: TcxDBTreeListColumn
          Caption.Text = #1044#1072#1090#1072' '#1087#1088#1086#1089#1084#1086#1090#1088#1072
          Width = 71
          Position.ColIndex = 15
          Position.RowIndex = 0
          Position.BandIndex = 0
          Summary.FooterSummaryItems = <>
          Summary.GroupFooterSummaryItems = <>
        end
        object IssuingDateTimeColumn: TcxDBTreeListColumn
          Caption.Text = #1044#1072#1090#1072' '#1074#1099#1076#1072#1095#1080
          Options.Editing = False
          Width = 95
          Position.ColIndex = 5
          Position.RowIndex = 0
          Position.BandIndex = 0
          Summary.FooterSummaryItems = <>
          Summary.GroupFooterSummaryItems = <>
        end
        object IssuerNameColumn: TcxDBTreeListColumn
          Caption.Text = #1054#1090#1087#1088#1072#1074#1080#1090#1077#1083#1100
          DataBinding.FieldName = 'charge_sender'
          Options.Editing = False
          Width = 83
          Position.ColIndex = 2
          Position.RowIndex = 0
          Position.BandIndex = 0
          Summary.FooterSummaryItems = <>
          Summary.GroupFooterSummaryItems = <>
        end
        object TopLevelChargeSheetIdColumn: TcxDBTreeListColumn
          Visible = False
          Options.Customizing = False
          Position.ColIndex = 14
          Position.RowIndex = 0
          Position.BandIndex = 0
          Summary.FooterSummaryItems = <>
          Summary.GroupFooterSummaryItems = <>
        end
        object DocumentIdColumn: TcxDBTreeListColumn
          Visible = False
          Options.Customizing = False
          Position.ColIndex = 16
          Position.RowIndex = 0
          Position.BandIndex = 0
          Summary.FooterSummaryItems = <>
          Summary.GroupFooterSummaryItems = <>
        end
        object PerformingAllowedColumn: TcxDBTreeListColumn
          Visible = False
          Options.Customizing = False
          Position.ColIndex = 17
          Position.RowIndex = 0
          Position.BandIndex = 0
          Summary.FooterSummaryItems = <>
          Summary.GroupFooterSummaryItems = <>
        end
        object IsEmployeePerformerColumn: TcxDBTreeListColumn
          Visible = False
          Options.Customizing = False
          Position.ColIndex = 18
          Position.RowIndex = 0
          Position.BandIndex = 0
          Summary.FooterSummaryItems = <>
          Summary.GroupFooterSummaryItems = <>
        end
        object ChargeSectionAccessibleColumn: TcxDBTreeListColumn
          Visible = False
          Options.Customizing = False
          Position.ColIndex = 19
          Position.RowIndex = 0
          Position.BandIndex = 0
          Summary.FooterSummaryItems = <>
          Summary.GroupFooterSummaryItems = <>
        end
        object SubordinateChargeSheetsIssuingAllowedColumn: TcxDBTreeListColumn
          Visible = False
          Options.Customizing = False
          Position.ColIndex = 20
          Position.RowIndex = 0
          Position.BandIndex = 0
          Summary.FooterSummaryItems = <>
          Summary.GroupFooterSummaryItems = <>
        end
      end
      inherited PerformerControlToolPanel: TPanel
        Width = 849
        TabOrder = 0
        ExplicitWidth = 849
        inherited AddChargesButton: TcxButton
          Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1080#1089#1087#1086#1083#1085#1080#1090#1077#1083#1077#1081
        end
        inherited RemoveChargesButton: TcxButton
          Caption = #1054#1090#1086#1079#1074#1072#1090#1100' '#1080#1089#1087#1086#1083#1085#1080#1090#1077#1083#1077#1081
        end
        object SaveChargesChangesButton: TcxButton
          Left = 375
          Top = 8
          Width = 148
          Height = 25
          Margins.Right = 20
          Action = actSaveChargeSheetRecordsChanges
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 2
        end
      end
    end
  end
  inherited ChargeSetSource: TDataSource
    Left = 72
    Top = 272
  end
  inherited ChargeRecordsHandlingPopupMenu: TPopupMenu
    Left = 40
    Top = 272
    inherited N1: TMenuItem
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1080#1089#1087#1086#1083#1085#1080#1090#1077#1083#1077#1081
    end
  end
  inherited ChargeActionList: TActionList
    Top = 272
    object actSaveChargeSheetRecordsChanges: TAction
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1080#1079#1084#1077#1085#1077#1085#1080#1103
      OnExecute = actSaveChargeSheetRecordsChangesExecute
    end
  end
end
