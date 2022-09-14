inherited DocumentChargeSheetsFrame: TDocumentChargeSheetsFrame
  inherited ScrollBox: TScrollBox
    inherited DocumentInfoPanel: TPanel
      Width = 831
      ExplicitWidth = 831
      inherited DocumentReceiversTreeList: TcxDBTreeList
        Width = 831
        Margins.Left = 0
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 0
        OptionsBehavior.ExpandOnDblClick = False
        TabOrder = 1
        OnDblClick = DocumentReceiversTreeListDblClick
        ExplicitWidth = 831
        inherited ReceiverFullNameColumn: TcxDBTreeListColumn
          Width = 87
        end
        inherited ReceiverSpecialityColumn: TcxDBTreeListColumn
          Width = 87
          Position.ColIndex = 3
        end
        inherited ReceiverDepartmentColumn: TcxDBTreeListColumn
          Visible = False
          Position.ColIndex = 13
        end
        inherited DocumentReceiverResolutionColumn: TcxDBTreeListColumn
          Width = 86
        end
        inherited PerformingDateTimeColumn: TcxDBTreeListColumn
          Width = 87
        end
        inherited ViewingDateByPerformerColumn: TcxDBTreeListColumn
          Width = 83
          Position.ColIndex = 18
        end
        inherited PerformedEmployeeNameColumn: TcxDBTreeListColumn
          Width = 87
        end
        inherited IsForAcquaitanceColumn: TcxDBTreeListColumn
          Options.Editing = False
          Width = 87
        end
        inherited DocumentChargeTextColumn: TcxDBTreeListColumn
          Visible = True
          Options.Customizing = True
          Width = 87
        end
        inherited IssuingDateTimeColumn: TcxDBTreeListColumn
          Options.Customizing = True
        end
        object DocumentChargeSenderColumn: TcxDBTreeListColumn
          Caption.Text = #1054#1090#1087#1088#1072#1074#1080#1090#1077#1083#1100
          DataBinding.FieldName = 'charge_sender'
          Options.Editing = False
          Width = 87
          Position.ColIndex = 2
          Position.RowIndex = 0
          Position.BandIndex = 0
          Summary.FooterSummaryItems = <>
          Summary.GroupFooterSummaryItems = <>
        end
      end
      inherited ReceiverControlToolPanel: TPanel
        Width = 831
        TabOrder = 0
        ExplicitWidth = 831
        inherited AddDocumentReceiverButton: TcxButton
          Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1080#1089#1087#1086#1083#1085#1080#1090#1077#1083#1077#1081
        end
        inherited RemoveDocumentReceiverButton: TcxButton
          Caption = #1054#1090#1086#1079#1074#1072#1090#1100' '#1080#1089#1087#1086#1083#1085#1080#1090#1077#1083#1077#1081
        end
        object SaveChargesChangesButton: TcxButton
          Left = 375
          Top = 8
          Width = 148
          Height = 25
          Margins.Right = 20
          Action = actSaveChargeRecordsChanges
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
  inherited DataSource1: TDataSource
    Left = 72
    Top = 272
  end
  inherited ChargeRecordsHandlingPopupMenu: TPopupMenu
    Left = 40
    Top = 272
    inherited N1: TMenuItem
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1080#1089#1087#1086#1083#1085#1080#1090#1077#1083#1077#1081
    end
    inherited N2: TMenuItem
      Action = actRemoveSelectedReceivers
    end
  end
  inherited ChargeActionList: TActionList
    Left = 8
    Top = 272
    object actSaveChargeRecordsChanges: TAction
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1080#1079#1084#1077#1085#1077#1085#1080#1103
      OnExecute = actSaveChargeRecordsChangesExecute
    end
  end
end
