inherited DocumentChargesFrame: TDocumentChargesFrame
  Width = 451
  Height = 304
  Align = alClient
  AutoScroll = True
  ExplicitWidth = 451
  ExplicitHeight = 304
  inherited ScrollBox: TScrollBox
    Width = 451
    Height = 304
    ExplicitWidth = 451
    ExplicitHeight = 304
    inherited DocumentInfoPanel: TPanel
      Width = 451
      Height = 304
      ExplicitWidth = 451
      ExplicitHeight = 304
      object DocumentReceiversTreeList: TcxDBTreeList
        Left = 0
        Top = 41
        Width = 451
        Height = 263
        Align = alClient
        Bands = <
          item
            Caption.AlignHorz = taCenter
          end>
        DataController.DataSource = DataSource1
        DataController.ParentField = 'sender_id'
        DataController.KeyField = 'id'
        LookAndFeel.SkinName = 'UserSkin'
        OptionsBehavior.CellHints = True
        OptionsBehavior.HeaderHints = True
        OptionsCustomizing.BandCustomizing = False
        OptionsCustomizing.ColumnsQuickCustomization = True
        OptionsData.Deleting = False
        OptionsSelection.HideFocusRect = False
        OptionsSelection.MultiSelect = True
        OptionsView.CellAutoHeight = True
        OptionsView.ColumnAutoWidth = True
        OptionsView.GridLines = tlglBoth
        OptionsView.HeaderAutoHeight = True
        PopupMenu = ChargeRecordsHandlingPopupMenu
        RootValue = -1
        TabOrder = 0
        OnCustomDrawDataCell = DocumentReceiversTreeListCustomDrawDataCell
        OnEditValueChanged = DocumentReceiversTreeListEditValueChanged
        OnSelectionChanged = DocumentReceiversTreeListSelectionChanged
        object ReceiverFullNameColumn: TcxDBTreeListColumn
          Caption.Text = #1060#1048#1054
          DataBinding.FieldName = 'full_name'
          Options.Editing = False
          Width = 100
          Position.ColIndex = 1
          Position.RowIndex = 0
          Position.BandIndex = 0
          Summary.FooterSummaryItems = <>
          Summary.GroupFooterSummaryItems = <>
        end
        object ReceiverSpecialityColumn: TcxDBTreeListColumn
          Caption.Text = #1044#1086#1083#1078#1085#1086#1089#1090#1100
          DataBinding.FieldName = 'speciality'
          Options.Editing = False
          Width = 100
          Position.ColIndex = 2
          Position.RowIndex = 0
          Position.BandIndex = 0
          Summary.FooterSummaryItems = <>
          Summary.GroupFooterSummaryItems = <>
        end
        object ReceiverDepartmentColumn: TcxDBTreeListColumn
          Caption.Text = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
          DataBinding.FieldName = 'department_short_name'
          Options.Editing = False
          Width = 100
          Position.ColIndex = 3
          Position.RowIndex = 0
          Position.BandIndex = 0
          Summary.FooterSummaryItems = <>
          Summary.GroupFooterSummaryItems = <>
        end
        object DocumentReceiverResolutionColumn: TcxDBTreeListColumn
          PropertiesClassName = 'TcxTextEditProperties'
          Properties.OnEditValueChanged = DocumentReceiverResolutionColumnPropertiesEditValueChanged
          Caption.MultiLine = True
          Caption.Text = #1050#1086#1084#1084#1077#1085#1090#1072#1088#1080#1081
          DataBinding.FieldName = 'comment'
          Options.Editing = False
          Width = 100
          Position.ColIndex = 5
          Position.RowIndex = 0
          Position.BandIndex = 0
          Summary.FooterSummaryItems = <>
          Summary.GroupFooterSummaryItems = <>
        end
        object ReceiverIdColumn: TcxDBTreeListColumn
          Visible = False
          DataBinding.FieldName = 'employee_id'
          Options.Customizing = False
          Options.Editing = False
          Width = 100
          Position.ColIndex = 6
          Position.RowIndex = 0
          Position.BandIndex = 0
          Summary.FooterSummaryItems = <>
          Summary.GroupFooterSummaryItems = <>
        end
        object TopLevelChargeIdColumn: TcxDBTreeListColumn
          Visible = False
          DataBinding.FieldName = 'sender_id'
          Options.Customizing = False
          Options.Editing = False
          Width = 100
          Position.ColIndex = 7
          Position.RowIndex = 0
          Position.BandIndex = 0
          Summary.FooterSummaryItems = <>
          Summary.GroupFooterSummaryItems = <>
        end
        object RecordIdColumn: TcxDBTreeListColumn
          Visible = False
          DataBinding.FieldName = 'id'
          Options.Customizing = False
          Options.Editing = False
          Width = 100
          Position.ColIndex = 8
          Position.RowIndex = 0
          Position.BandIndex = 0
          Summary.FooterSummaryItems = <>
          Summary.GroupFooterSummaryItems = <>
        end
        object PerformingDateTimeColumn: TcxDBTreeListColumn
          Caption.Text = #1044#1072#1090#1072' '#1080#1089#1087#1086#1083#1085#1077#1085#1080#1103
          DataBinding.FieldName = 'performing_date'
          Options.Editing = False
          Width = 100
          Position.ColIndex = 9
          Position.RowIndex = 0
          Position.BandIndex = 0
          Summary.FooterSummaryItems = <>
          Summary.GroupFooterSummaryItems = <>
        end
        object RecordStatusColumn: TcxDBTreeListColumn
          Visible = False
          DataBinding.FieldName = 'status'
          Options.Customizing = False
          Options.Editing = False
          Width = 100
          Position.ColIndex = 10
          Position.RowIndex = 0
          Position.BandIndex = 0
          Summary.FooterSummaryItems = <>
          Summary.GroupFooterSummaryItems = <>
        end
        object IsReceiverForeignColumn: TcxDBTreeListColumn
          Visible = False
          DataBinding.FieldName = 'is_receiver_foreign'
          Options.Customizing = False
          Options.Editing = False
          Width = 100
          Position.ColIndex = 11
          Position.RowIndex = 0
          Position.BandIndex = 0
          Summary.FooterSummaryItems = <>
          Summary.GroupFooterSummaryItems = <>
        end
        object ViewingDateByPerformerColumn: TcxDBTreeListColumn
          Visible = False
          Caption.Text = #1044#1072#1090#1072' '#1087#1088#1086#1089#1084#1086#1090#1088#1072
          DataBinding.FieldName = 'viewing_date_by_performer'
          Options.Editing = False
          Width = 100
          Position.ColIndex = 13
          Position.RowIndex = 0
          Position.BandIndex = 0
          Summary.FooterSummaryItems = <>
          Summary.GroupFooterSummaryItems = <>
        end
        object ReceiverLeaderIdColumn: TcxDBTreeListColumn
          Visible = False
          DataBinding.FieldName = 'leader_id'
          Options.Customizing = False
          Options.Editing = False
          Position.ColIndex = 14
          Position.RowIndex = 0
          Position.BandIndex = 0
          Summary.FooterSummaryItems = <>
          Summary.GroupFooterSummaryItems = <>
        end
        object IsAccessbleChargeColumn: TcxDBTreeListColumn
          Visible = False
          DataBinding.FieldName = 'is_accessible_charge'
          Options.Customizing = False
          Options.Editing = False
          Position.ColIndex = 15
          Position.RowIndex = 0
          Position.BandIndex = 0
          Summary.FooterSummaryItems = <>
          Summary.GroupFooterSummaryItems = <>
        end
        object ReceiverDocumentIdColumn: TcxDBTreeListColumn
          Visible = False
          DataBinding.FieldName = 'document_id'
          Options.Customizing = False
          Position.ColIndex = 16
          Position.RowIndex = 0
          Position.BandIndex = 0
          Summary.FooterSummaryItems = <>
          Summary.GroupFooterSummaryItems = <>
        end
        object PerformedEmployeeNameColumn: TcxDBTreeListColumn
          Caption.Text = #1042#1099#1087#1086#1083#1085#1080#1074#1096#1080#1081
          DataBinding.FieldName = 'performed_employee_name'
          Options.Editing = False
          Position.ColIndex = 12
          Position.RowIndex = 0
          Position.BandIndex = 0
          Summary.FooterSummaryItems = <>
          Summary.GroupFooterSummaryItems = <>
        end
        object IsForAcquaitanceColumn: TcxDBTreeListColumn
          Caption.Text = #1050#1086#1087#1080#1103
          DataBinding.FieldName = 'is_for_acquaitance'
          Position.ColIndex = 0
          Position.RowIndex = 0
          Position.BandIndex = 0
          Summary.FooterSummaryItems = <>
          Summary.GroupFooterSummaryItems = <>
        end
        object DocumentChargeTextColumn: TcxDBTreeListColumn
          Visible = False
          Caption.Text = #1055#1086#1088#1091#1095#1077#1085#1080#1077
          DataBinding.FieldName = 'charge'
          Options.Customizing = False
          Options.Editing = False
          Position.ColIndex = 4
          Position.RowIndex = 0
          Position.BandIndex = 0
          Summary.FooterSummaryItems = <>
          Summary.GroupFooterSummaryItems = <>
        end
        object IssuingDateTimeColumn: TcxDBTreeListColumn
          Visible = False
          Caption.Text = #1044#1072#1090#1072' '#1074#1099#1076#1072#1095#1080
          DataBinding.FieldName = 'issuing_datetime'
          Options.Customizing = False
          Options.Editing = False
          Position.ColIndex = 17
          Position.RowIndex = 0
          Position.BandIndex = 0
          Summary.FooterSummaryItems = <>
          Summary.GroupFooterSummaryItems = <>
        end
      end
      object ReceiverControlToolPanel: TPanel
        Left = 0
        Top = 0
        Width = 451
        Height = 41
        Align = alTop
        BevelEdges = [beTop]
        BevelKind = bkFlat
        BevelOuter = bvNone
        TabOrder = 1
        object AddDocumentReceiverButton: TcxButton
          Left = 8
          Top = 8
          Width = 161
          Height = 25
          Margins.Right = 20
          Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1087#1086#1083#1091#1095#1072#1090#1077#1083#1077#1081
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
          OnClick = actAddReceiversExecute
          Colors.Default = clGradientInactiveCaption
        end
        object RemoveDocumentReceiverButton: TcxButton
          Left = 191
          Top = 8
          Width = 170
          Height = 25
          Margins.Right = 20
          Caption = #1054#1090#1086#1079#1074#1072#1090#1100' '#1087#1086#1083#1091#1095#1072#1090#1077#1083#1077#1081
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 1
          OnClick = actRemoveSelectedReceiversExecute
          Colors.Default = clGradientInactiveCaption
        end
      end
    end
  end
  object DataSource1: TDataSource
    Left = 512
    Top = 320
  end
  object ChargeRecordsHandlingPopupMenu: TPopupMenu
    Left = 576
    Top = 320
    object N1: TMenuItem
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1087#1086#1083#1091#1095#1072#1090#1077#1083#1077#1081
      OnClick = actAddReceiversExecute
    end
    object N3: TMenuItem
      Action = actChangeSelectedChargeTexts
    end
    object N2: TMenuItem
      Caption = #1054#1090#1086#1079#1074#1072#1090#1100' '#1074#1099#1073#1088#1072#1085#1085#1099#1093' '#1087#1086#1083#1091#1095#1072#1090#1077#1083#1077#1081
      OnClick = actRemoveSelectedReceiversExecute
    end
  end
  object ChargeActionList: TActionList
    Left = 16
    Top = 176
    object actChangeSelectedChargeTexts: TAction
      Caption = #1053#1072#1079#1085#1072#1095#1080#1090#1100' '#1087#1086#1088#1091#1095#1077#1085#1080#1077'...'
      OnExecute = actChangeSelectedChargeTextsExecute
    end
    object actAddReceivers: TAction
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1087#1086#1083#1091#1095#1072#1090#1077#1083#1077#1081
      OnExecute = actAddReceiversExecute
    end
    object actRemoveSelectedReceivers: TAction
      Caption = #1054#1090#1086#1079#1074#1072#1090#1100' '#1074#1099#1073#1088#1072#1085#1085#1099#1093' '#1087#1086#1083#1091#1095#1072#1090#1077#1083#1077#1081
      OnExecute = actRemoveSelectedReceiversExecute
    end
  end
end
