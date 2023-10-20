inherited DocumentFlowBaseReferenceForm: TDocumentFlowBaseReferenceForm
  Caption = 'DocumentFlowBaseReferenceForm'
  PixelsPerInch = 96
  TextHeight = 13
  inherited DataOperationToolBar: TToolBar
    Height = 79
    Color = clWhite
    EdgeInner = esNone
    EdgeOuter = esNone
    Flat = False
    GradientEndColor = clGradientInactiveCaption
    GradientStartColor = clWhite
    ParentColor = False
    ExplicitHeight = 79
    inherited ChooseRecordsToolButton: TToolButton
      Top = 2
      ExplicitTop = 2
    end
    inherited ChooseRecordsSeparator: TToolButton
      Top = 2
      ExplicitTop = 2
    end
    inherited AddDataToolButton: TToolButton
      Top = 2
      ExplicitTop = 2
    end
    inherited CopySelectedDataRecordsToolButton: TToolButton
      Top = 2
      ExplicitTop = 2
    end
    inherited ChangeDataToolButton: TToolButton
      Top = 2
      ExplicitTop = 2
    end
    inherited DeleteDataToolButton: TToolButton
      Top = 2
      ExplicitTop = 2
    end
    inherited RefreshDataToolButton: TToolButton
      Top = 2
      ExplicitTop = 2
    end
    inherited ReserveToolButton1: TToolButton
      Top = 2
      ExplicitTop = 2
    end
    inherited ReserveToolButton2: TToolButton
      Top = 2
      ExplicitTop = 2
    end
    inherited SelectFilterDataToolButton: TToolButton
      Top = 2
      ExplicitTop = 2
    end
    inherited SelectFilteredRecordsSeparator: TToolButton
      Top = 2
      Enabled = False
      ExplicitTop = 2
      ExplicitHeight = 41
    end
    inherited PrintDataToolButton: TToolButton
      Top = 43
      Enabled = False
      ExplicitTop = 43
    end
    inherited ExportDataToolButton: TToolButton
      Top = 43
      ExplicitTop = 43
    end
    inherited ExportDataSeparator: TToolButton
      Top = 43
      ExplicitTop = 43
    end
    inherited ExitToolButton: TToolButton
      Top = 43
      ExplicitTop = 43
    end
  end
  inherited SearchByColumnPanel: TScrollBox
    Top = 101
    Align = alTop
    ExplicitTop = 101
    inherited Label1: TLabel
      Width = 109
      Font.Style = [fsBold]
      ParentFont = False
      ExplicitWidth = 109
    end
    inherited SearchColumnNameLabel: TLabel
      Left = 117
      ExplicitLeft = 117
    end
    inherited SearchByENTERCheckBox: TCheckBox
      Width = 193
      Font.Style = [fsBold]
      ParentFont = False
      ExplicitWidth = 193
    end
    inherited SearchColumnValueEdit: TEdit
      Left = 126
      Width = 224
      ExplicitLeft = 126
      ExplicitWidth = 224
    end
    inherited btnPrevFoundOccurrence: TcxButton
      Height = 20
      Font.Height = -17
      LookAndFeel.SkinName = ''
      LookAndFeel.SkinName = ''
      ExplicitHeight = 20
    end
    inherited btnNextFoundOccurrence: TcxButton
      Height = 20
      Font.Height = -17
      LookAndFeel.SkinName = ''
      LookAndFeel.SkinName = ''
      ExplicitHeight = 20
    end
  end
  inherited DataRecordMovingToolBar: TToolBar
    Top = 79
    Visible = False
    ExplicitTop = 79
  end
  inherited ClientAreaPanel: TPanel
    Top = 132
    Height = 555
    BevelOuter = bvNone
    ExplicitTop = 132
    ExplicitHeight = 555
    DesignSize = (
      833
      555)
    inherited DataLoadingCanceledPanel: TPanel
      Top = 62
      ExplicitTop = 62
    end
    inherited WaitDataLoadingPanel: TPanel
      Top = 144
      ExplicitTop = 144
    end
    inherited DataRecordGrid: TcxGrid
      Left = 0
      Top = 0
      Width = 833
      Height = 555
      LookAndFeel.SkinName = 'UserSkin'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 753
      ExplicitHeight = 529
      inherited DataRecordGridTableView: TcxGridDBTableView
        OnCellDblClick = DataRecordGridTableViewCellDblClick
        DataController.KeyFieldNames = 'id'
        OptionsData.Deleting = False
        OptionsData.Editing = False
        OptionsData.Inserting = False
        OptionsView.CellEndEllipsis = True
        OptionsView.CellAutoHeight = True
        OptionsView.ColumnAutoWidth = True
        OptionsView.HeaderAutoHeight = True
        OptionsView.Indicator = True
        OnCustomDrawColumnHeader = DataRecordGridTableViewCustomDrawColumnHeader
      end
    end
  end
  inherited DataOperationActionList: TActionList
    inherited actCopySelectedDataRecords: TAction
      Visible = False
    end
    inherited actChangeData: TAction
      Visible = False
    end
    inherited actExit: TAction
      Visible = False
    end
  end
  inherited Localizer: TcxLocalizer
    Active = True
    FileName = '\\server-file\Prog_UMZ\Delphi\OMO\DevExRus100Proc.ini'
    Locale = 1049
  end
end
