inherited BaseDocumentsReferenceForm: TBaseDocumentsReferenceForm
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090#1099' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1072
  ClientWidth = 949
  ExplicitWidth = 965
  ExplicitHeight = 719
  PixelsPerInch = 96
  TextHeight = 13
  inherited DataOperationToolBar: TToolBar
    Width = 949
    Height = 115
    ButtonWidth = 108
    ExplicitWidth = 949
    ExplicitHeight = 115
    inherited ChooseRecordsToolButton: TToolButton
      ExplicitWidth = 108
    end
    inherited ChooseRecordsSeparator: TToolButton
      Left = 0
      Wrap = True
      Visible = False
      ExplicitLeft = 0
      ExplicitHeight = 41
    end
    inherited AddDataToolButton: TToolButton
      Left = 0
      Top = 43
      ExplicitLeft = 0
      ExplicitTop = 43
      ExplicitWidth = 108
    end
    inherited CopySelectedDataRecordsToolButton: TToolButton
      Left = 108
      Top = 43
      ExplicitLeft = 108
      ExplicitTop = 43
      ExplicitWidth = 108
    end
    inherited ChangeDataToolButton: TToolButton
      Left = 216
      Top = 43
      ExplicitLeft = 216
      ExplicitTop = 43
      ExplicitWidth = 108
    end
    inherited DeleteDataToolButton: TToolButton
      Left = 324
      Top = 43
      ExplicitLeft = 324
      ExplicitTop = 43
      ExplicitWidth = 108
    end
    inherited RefreshDataToolButton: TToolButton
      Left = 432
      Top = 43
      DropdownMenu = DocumentWorkCycleStageNamesPopupMenu
      Enabled = False
      Style = tbsDropDown
      ExplicitLeft = 432
      ExplicitTop = 43
      ExplicitWidth = 123
    end
    inherited ReserveToolButton1: TToolButton
      Left = 555
      Top = 43
      Wrap = True
      ExplicitLeft = 555
      ExplicitTop = 43
      ExplicitWidth = 108
    end
    inherited ReserveToolButton2: TToolButton
      Left = 0
      Top = 79
      ExplicitLeft = 0
      ExplicitTop = 79
      ExplicitWidth = 108
    end
    inherited SelectFilterDataToolButton: TToolButton
      Left = 108
      Top = 79
      ExplicitLeft = 108
      ExplicitTop = 79
      ExplicitWidth = 108
    end
    inherited SelectFilteredRecordsSeparator: TToolButton
      Left = 216
      Top = 79
      Wrap = False
      Visible = False
      ExplicitLeft = 216
      ExplicitTop = 79
      ExplicitHeight = 36
    end
    inherited PrintDataToolButton: TToolButton
      Left = 224
      Top = 79
      ExplicitLeft = 224
      ExplicitTop = 79
      ExplicitWidth = 108
    end
    inherited ExportDataToolButton: TToolButton
      Left = 332
      Top = 79
      ExplicitLeft = 332
      ExplicitTop = 79
      ExplicitWidth = 123
    end
    inherited ExportDataSeparator: TToolButton
      Left = 455
      Top = 79
      Visible = False
      ExplicitLeft = 455
      ExplicitTop = 79
    end
    inherited ExitToolButton: TToolButton
      Left = 463
      Top = 79
      Enabled = False
      ExplicitLeft = 463
      ExplicitTop = 79
      ExplicitWidth = 108
    end
    object RefreshDocumentCardToolButton: TToolButton
      Left = 571
      Top = 79
      Action = actRefreshDocumentCard
      AutoSize = True
      Enabled = False
    end
  end
  inherited StatisticsInfoStatusBar: TStatusBar
    Width = 949
    ExplicitWidth = 949
  end
  inherited SearchByColumnPanel: TScrollBox
    Top = 632
    Width = 949
    Height = 29
    Align = alBottom
    Visible = False
    ExplicitTop = 632
    ExplicitWidth = 949
    ExplicitHeight = 29
    inherited Label1: TLabel
      ExplicitLeft = -193
    end
    inherited SearchColumnNameLabel: TLabel
      Left = 120
      ExplicitLeft = 120
    end
    inherited SearchByENTERCheckBox: TCheckBox
      Left = 456
      ExplicitLeft = 456
    end
    inherited SearchColumnValueEdit: TEdit
      Left = 129
      Width = 253
      ExplicitLeft = 129
      ExplicitWidth = 253
    end
    inherited btnPrevFoundOccurrence: TcxButton
      Left = 388
      LookAndFeel.SkinName = ''
      ExplicitLeft = 388
    end
    inherited btnNextFoundOccurrence: TcxButton
      Left = 419
      LookAndFeel.SkinName = ''
      ExplicitLeft = 419
    end
  end
  inherited DataRecordMovingToolBar: TToolBar
    Top = 115
    Width = 949
    ExplicitTop = 115
    ExplicitWidth = 949
    inherited FirstDataRecordToolButton: TToolButton
      ExplicitWidth = 24
    end
    inherited PrevDataRecordToolButton: TToolButton
      ExplicitWidth = 24
    end
    inherited NextDataRecordToolButton: TToolButton
      ExplicitWidth = 24
    end
    inherited LastDataRecordToolButton: TToolButton
      ExplicitWidth = 24
    end
  end
  inherited ClientAreaPanel: TPanel
    Top = 137
    Width = 949
    Height = 495
    ExplicitTop = 137
    ExplicitWidth = 949
    ExplicitHeight = 495
    DesignSize = (
      949
      495)
    inherited DataLoadingCanceledPanel: TPanel
      Left = 126
      Top = 56
      ExplicitLeft = 126
      ExplicitTop = 56
    end
    inherited WaitDataLoadingPanel: TPanel
      Left = 79
      Top = 131
      ExplicitLeft = 79
      ExplicitTop = 131
    end
    inherited DataRecordGrid: TcxGrid
      Width = 949
      Height = 495
      ExplicitWidth = 949
      ExplicitHeight = 495
      inherited DataRecordGridTableView: TcxGridDBTableView
        DataController.KeyFieldNames = ''
        DataController.OnCompare = DataRecordGridTableViewDataControllerCompare
        OptionsView.GroupByBox = False
        object DocumentNumberColumn: TcxGridDBColumn
          Caption = #1053#1086#1084#1077#1088
          PropertiesClassName = 'TcxTextEditProperties'
          HeaderAlignmentHorz = taCenter
          MinWidth = 0
          Width = 75
        end
        object DocumentDateColumn: TcxGridDBColumn
          Caption = #1044#1072#1090#1072' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
          MinWidth = 0
          Width = 107
        end
        object DocumentNameColumn: TcxGridDBColumn
          Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
          HeaderAlignmentHorz = taCenter
          MinWidth = 0
          Width = 153
        end
        object DocumentCreationDateColumn: TcxGridDBColumn
          Caption = #1044#1072#1090#1072' '#1089#1086#1079#1076#1072#1085#1080#1103
          HeaderAlignmentHorz = taCenter
          MinWidth = 0
          Width = 129
        end
        object DocumentCreationDateYearColumn: TcxGridDBColumn
          Caption = #1043#1086#1076' '#1089#1086#1079#1076#1072#1085#1080#1103
          PropertiesClassName = 'TcxSpinEditProperties'
          Properties.Alignment.Horz = taLeftJustify
          HeaderAlignmentHorz = taCenter
          MinWidth = 0
          Width = 72
        end
        object DocumentCreationDateMonthColumn: TcxGridDBColumn
          Caption = #1052#1077#1089#1103#1094' '#1089#1086#1079#1076#1072#1085#1080#1103
          PropertiesClassName = 'TcxSpinEditProperties'
          Properties.Alignment.Horz = taLeftJustify
          HeaderAlignmentHorz = taCenter
          MinWidth = 0
          Width = 76
        end
        object DocumentTypeNameColumn: TcxGridDBColumn
          Caption = #1058#1080#1087' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
          HeaderAlignmentHorz = taCenter
          MinWidth = 0
          Width = 97
        end
        object CurrentWorkCycleStageNameColumn: TcxGridDBColumn
          Caption = #1057#1090#1072#1090#1091#1089
          HeaderAlignmentHorz = taCenter
          MinWidth = 0
          Width = 142
        end
        object CurrentWorkCycleStageNumberColumn: TcxGridDBColumn
          DataBinding.FieldName = 'current_work_cycle_stage_number'
          Visible = False
          VisibleForCustomization = False
        end
        object DocumentAuthorShortNameColumn: TcxGridDBColumn
          Caption = #1040#1074#1090#1086#1088
          DataBinding.FieldName = 'author_short_name'
          Visible = False
          MinWidth = 128
          Width = 128
        end
        object ChargePerformingStatsColumn: TcxGridDBColumn
          Caption = #1042#1099#1087#1086#1083#1085#1077#1085#1085#1099#1077' '#1087#1086#1088#1091#1095#1077#1085#1080#1103
          MinWidth = 0
          Width = 84
        end
        object IdColumn: TcxGridDBColumn
          DataBinding.FieldName = 'id'
          Visible = False
          VisibleForCustomization = False
        end
        object DocumentTypeIdColumn: TcxGridDBColumn
          DataBinding.FieldName = 'type_id'
          Visible = False
          VisibleForCustomization = False
        end
        object CanBeRemovedColumn: TcxGridDBColumn
          DataBinding.FieldName = 'can_be_removed'
          Visible = False
          VisibleForCustomization = False
        end
        object DocumentAuthorIdColumn: TcxGridDBColumn
          DataBinding.FieldName = 'author_id'
          Visible = False
          VisibleForCustomization = False
        end
        object IsDocumentViewedColumn: TcxGridDBColumn
          Caption = #1055#1088#1086#1089#1084#1086#1090#1088#1077#1085
          Visible = False
          MinWidth = 70
          VisibleForCustomization = False
        end
        object BaseDocumentIdColumn: TcxGridDBColumn
          Visible = False
          VisibleForCustomization = False
        end
        object OwnChargeSheetColumn: TcxGridDBColumn
          Caption = #1052#1085#1077
          Visible = False
          VisibleForCustomization = False
        end
        object AllChargeSheetsPerformedColumn: TcxGridDBColumn
          Visible = False
          VisibleForCustomization = False
        end
        object AllSubordinateChargeSheetsPerformedColumn: TcxGridDBColumn
          Visible = False
          VisibleForCustomization = False
        end
        object IsSelfRegisteredColumn: TcxGridDBColumn
          Caption = #1041#1091#1084#1072#1078#1085#1072#1103' '#1082#1086#1087#1080#1103
          Visible = False
          MinWidth = 100
          VisibleForCustomization = False
          Width = 200
        end
        object ApplicationsExistsColumn: TcxGridDBColumn
          Caption = #1042#1083#1086#1078#1077#1085#1080#1103
          PropertiesClassName = 'TcxImageComboBoxProperties'
          Properties.Images = ApplicationsImageList
          Properties.Items = <
            item
              ImageIndex = 0
              Value = True
            end>
          Visible = False
        end
        object ProductCodeColumn: TcxGridDBColumn
          Caption = #1064#1080#1092#1088' '#1080#1079#1076#1077#1083#1080#1103
          Visible = False
        end
      end
      object DataRecordGridDBTableView1: TcxGridDBTableView [1]
        NavigatorButtons.ConfirmDelete = False
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <>
        DataController.Summary.SummaryGroups = <>
      end
    end
  end
  inherited imgLstDisabled: TPngImageList
    Top = 352
  end
  inherited imgLstEnabled: TPngImageList
    Top = 352
  end
  inherited DataOperationActionList: TActionList
    Left = 72
    Top = 352
    inherited actAddData: TAction
      Visible = False
    end
    inherited actChangeData: TAction
      Visible = True
    end
    inherited actDeleteData: TAction
      Visible = False
    end
    inherited actExportData: TAction
      Visible = False
    end
    inherited actChooseRecords: TAction
      Visible = False
    end
    object actRefreshDocumentCard: TAction
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100' '#1082#1072#1088#1090#1086#1095#1082#1091
      ImageIndex = 4
      OnExecute = actRefreshDocumentCardExecute
    end
  end
  inherited DataOperationPopupMenu: TPopupMenu
    Left = 104
    Top = 352
    object N5: TMenuItem [7]
      Action = actRefreshDocumentCard
    end
  end
  inherited TargetDataSource: TDataSource
    Left = 136
    Top = 352
  end
  inherited ExportDataPopupMenu: TPopupMenu
    Left = 168
    Top = 352
  end
  inherited ExportDataDialog: TSaveDialog
    Left = 200
    Top = 352
  end
  inherited Localizer: TcxLocalizer
    Left = 232
    Top = 352
  end
  object ApplicationsImageList: TPngImageList
    PngImages = <
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000001974455874536F6674776172650041646F626520496D616765526561
          647971C9653C0000032069545874584D4C3A636F6D2E61646F62652E786D7000
          000000003C3F787061636B657420626567696E3D22EFBBBF222069643D225735
          4D304D7043656869487A7265537A4E54637A6B633964223F3E203C783A786D70
          6D65746120786D6C6E733A783D2261646F62653A6E733A6D6574612F2220783A
          786D70746B3D2241646F626520584D5020436F726520352E302D633036302036
          312E3133343737372C20323031302F30322F31322D31373A33323A3030202020
          2020202020223E203C7264663A52444620786D6C6E733A7264663D2268747470
          3A2F2F7777772E77332E6F72672F313939392F30322F32322D7264662D73796E
          7461782D6E7323223E203C7264663A4465736372697074696F6E207264663A61
          626F75743D222220786D6C6E733A786D703D22687474703A2F2F6E732E61646F
          62652E636F6D2F7861702F312E302F2220786D6C6E733A786D704D4D3D226874
          74703A2F2F6E732E61646F62652E636F6D2F7861702F312E302F6D6D2F222078
          6D6C6E733A73745265663D22687474703A2F2F6E732E61646F62652E636F6D2F
          7861702F312E302F73547970652F5265736F75726365526566232220786D703A
          43726561746F72546F6F6C3D2241646F62652050686F746F73686F7020435335
          2057696E646F77732220786D704D4D3A496E7374616E636549443D22786D702E
          6969643A37323234353132384233304331314542414230433833454438324632
          324239422220786D704D4D3A446F63756D656E7449443D22786D702E6469643A
          3732323435313239423330433131454241423043383345443832463232423942
          223E203C786D704D4D3A4465726976656446726F6D2073745265663A696E7374
          616E636549443D22786D702E6969643A37323234353132364233304331314542
          41423043383345443832463232423942222073745265663A646F63756D656E74
          49443D22786D702E6469643A3732323435313237423330433131454241423043
          383345443832463232423942222F3E203C2F7264663A4465736372697074696F
          6E3E203C2F7264663A5244463E203C2F783A786D706D6574613E203C3F787061
          636B657420656E643D2272223F3E0A0B938D000003754944415478DA6D937B4C
          536718C6DFEF1C7A80B6F486C5D2D216106BBC0790217312A7A8139229EE8222
          093243638C86C56DA80C9C326AC025A2C44D0486E906CE68B52E8CC579C16B82
          977A59BCA0D0F4427B5A905AC22AB6B4E7F4EC6036920DBE7FBFF7F9BDDFFBBC
          CF876A9A2D30D5C13104E4700836AC8A933B87C6BA9FD8DEA8847C0CE627F28F
          B55F1CD8A6498802601840BA96A901113882E599B1EF1D369237091CE0DD7942
          F08C04A1A3DB0BDB3E94838D1C4588AD437B8E3F9E241EBFD898A3C2EB0D2E2A
          3753EC950A09ADD91530C47071AB4C4CECFCEEB4C3A8CD8BEF8D9710EFA3F21F
          2603386C77B188CF08A239903A93B77D4F8BFD68F1EAB8610B19108FD397A78A
          0E1C3E4B567CBA4C3A882A1BFB2689172F103D6EBB3C38EFCB0265CA377ABB79
          E7278A9347CF3937457330A000634AF3E2CB1ACE914734095C4055CDD6093186
          01E466C57E5ED96AADAFD326669EB9E6B9B33085074FAD7F21DF28038539B2B9
          BAF6FE275F15283FAE37380DE99A1840E5C7FA26E6DEB452C6D7FD6CF76D5D2B
          EFF0F9E98C2B0F86653C8241C084816D0E342298340D3F28E045DCEEECF666E7
          664A0CE8EB46F384EB38813149F22848898FDEBD4F6FAF3DA84D4E335C1D7A88
          45002C98C10FDCEDF1456E58215DB4EBB8C554F399BAACB37BA001ED6D7DF156
          9CAE113B8CB73C093BF215295527ECE6F202A5BEEBBE773315C660F53BE2869A
          36FB8EDAD2A4D98D1DAE9EBCC5927E53EF2B351D86710FFA604D9654B75F6FAB
          A8D32629EEF7FA485E540458C8D7284803E4674F4FDDD56479B0AF58BDFB79FF
          9B5AE75010C6FC140AD1FFACFCFA23AFAEA573A0A2E483E997EE3CF5AC5A911E
          A72408DC73B6CBEDA7D8A2401863962D148D8862F08EEFCFBB8B2A8B54A2537F
          B846987F3373F01707D3E71C052A48239C4D1C620DE371D91C0810242BC48C99
          F4C3BA25D3169537594DBA92C42F7EBFF5F2D0F8D3274257ADB7312ECF18D0A1
          10F253EC1F4018281591B0324DD27EE894B3B0BA44AD6A30BAFA3F5A1A6B353D
          7B954CD1CC7F72836EFC39DCD4FCDB4069518EF4D79F2EB8D77138386CC99315
          7EDBE66CDF5BACDA2FE4429DCD1DBCFBC2FA7AFEFFC56F0195AD3D6CB7B8EA9A
          364755C62C01F0A331E87A340265F972D3E57B9E0C8930048E4104B355314087
          A70054FCF80C063D21589FAD6862F75C1AA0C2B064AEE0B6F1AA3B8B1B09304D
          C280F3250673D45303FE067E126DD04D59512D0000000049454E44AE426082}
        Name = 'PngImage0'
        Background = clWindow
      end>
    Left = 264
    Top = 352
  end
  object DocumentWorkCycleStageNamesPopupMenu: TPopupMenu
    Left = 680
    Top = 280
  end
end
