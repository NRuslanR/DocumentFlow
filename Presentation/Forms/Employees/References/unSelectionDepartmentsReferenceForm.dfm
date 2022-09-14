inherited SelectionDepartmentsReferenceForm: TSelectionDepartmentsReferenceForm
  Caption = ''
  ClientWidth = 823
  Constraints.MinWidth = 290
  ExplicitWidth = 839
  PixelsPerInch = 96
  TextHeight = 13
  inherited DataOperationToolBar: TToolBar
    Width = 823
    ExplicitWidth = 823
    inherited ChooseRecordsSeparator: TToolButton
      Visible = False
    end
    inherited SelectFilteredRecordsSeparator: TToolButton
      Visible = False
    end
    inherited ExportDataSeparator: TToolButton
      Visible = False
    end
  end
  inherited StatisticsInfoStatusBar: TStatusBar
    Width = 823
    ExplicitWidth = 823
  end
  inherited SearchByColumnPanel: TScrollBox
    Width = 823
    Height = 84
    ExplicitWidth = 823
    ExplicitHeight = 84
    inherited SearchColumnNameLabel: TLabel
      Left = 120
      ExplicitLeft = 120
    end
    inherited SearchByENTERCheckBox: TCheckBox
      Left = 8
      Top = 58
      ExplicitLeft = 8
      ExplicitTop = 58
    end
    inherited SearchColumnValueEdit: TEdit
      Left = 8
      Top = 31
      Width = 192
      ExplicitLeft = 8
      ExplicitTop = 31
      ExplicitWidth = 192
    end
    inherited btnPrevFoundOccurrence: TcxButton
      Left = 206
      Top = 31
      LookAndFeel.SkinName = ''
      ExplicitLeft = 206
      ExplicitTop = 31
    end
    inherited btnNextFoundOccurrence: TcxButton
      Left = 237
      Top = 31
      LookAndFeel.SkinName = ''
      ExplicitLeft = 237
      ExplicitTop = 31
    end
  end
  inherited DataRecordMovingToolBar: TToolBar
    Width = 823
    ExplicitWidth = 823
  end
  inherited ClientAreaPanel: TPanel
    Top = 185
    Width = 823
    Height = 476
    ExplicitTop = 185
    ExplicitWidth = 823
    ExplicitHeight = 476
    inherited DataLoadingCanceledPanel: TPanel
      Left = 97
      Top = 52
      ExplicitLeft = 97
      ExplicitTop = 52
    end
    inherited WaitDataLoadingPanel: TPanel
      Left = 51
      Top = 125
      ExplicitLeft = 51
      ExplicitTop = 125
    end
    inherited DataRecordGrid: TcxGrid
      Width = 823
      Height = 476
      ExplicitWidth = 823
      ExplicitHeight = 476
      inherited DataRecordGridTableView: TcxGridDBTableView
        OptionsData.Editing = True
        inherited IsSelectedColumn: TcxGridDBColumn
          Properties.OnEditValueChanged = IsSelectedColumnPropertiesEditValueChanged
          Visible = True
        end
        object DepartmentCodeColumn: TcxGridDBColumn
          Caption = #1050#1086#1076
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 86
        end
        object DepartmentShortNameColumn: TcxGridDBColumn
          Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 149
        end
        object DepartmentFullNameColumn: TcxGridDBColumn
          Caption = #1055#1086#1083#1085#1086#1077' '#1085#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 451
        end
        object IdColumn: TcxGridDBColumn
          Visible = False
          Options.Editing = False
          VisibleForCustomization = False
        end
      end
    end
  end
  inherited imgLstDisabled: TPngImageList
    Left = 8
    Top = 616
  end
  inherited imgLstEnabled: TPngImageList
    Left = 40
    Top = 616
  end
  inherited DataOperationActionList: TActionList
    inherited actAddData: TAction
      Visible = False
    end
    inherited actDeleteData: TAction
      Visible = False
    end
    inherited actChooseRecords: TAction
      Visible = False
    end
  end
  inherited ExportDataPopupMenu: TPopupMenu
    Left = 104
    Top = 616
  end
  inherited ExportDataDialog: TSaveDialog
    Left = 72
    Top = 616
  end
  inherited Localizer: TcxLocalizer
    Left = 128
    Top = 616
  end
end
