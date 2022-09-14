inherited SignedDocumentMainInformationFrame: TSignedDocumentMainInformationFrame
  Width = 813
  ExplicitWidth = 813
  inherited ScrollBox: TScrollBox
    Width = 813
    ExplicitWidth = 813
    inherited DocumentInfoPanel: TPanel
      Width = 808
      OnResize = DocumentInfoPanelResize
      ExplicitWidth = 808
      DesignSize = (
        808
        299)
      inherited DocumentNumberLabel: TLabel
        Left = 363
        ExplicitLeft = 363
      end
      inherited DocumentCreationDateLabel: TLabel
        Left = 613
        ExplicitLeft = 613
      end
      inherited DocumentNameLabel: TLabel
        Top = 95
        ExplicitTop = 95
      end
      inherited DocumentContentLabel: TLabel
        Top = 120
        ExplicitTop = 120
      end
      inherited DocumentNoteLabel: TLabel
        Top = 199
        ExplicitTop = 175
      end
      inherited PerformerTelephoneNumberLabel: TLabel
        Left = 668
        Top = 34
        ExplicitLeft = 669
        ExplicitTop = 34
      end
      inherited DocumentCreationDateTimePicker: TDateTimePicker
        Left = 652
        ExplicitLeft = 652
      end
      inherited DocumentNumberDepartmentCodePartEdit: TRegExprValidateEdit
        Left = 404
        ExplicitLeft = 404
      end
      inherited DocumentNumberOrderPartEdit: TRegExprValidateEdit
        Left = 486
        Width = 106
        ExplicitLeft = 486
        ExplicitWidth = 106
      end
      inherited DocumentTypeEdit: TRegExprValidateEdit
        Width = 247
        ExplicitWidth = 247
      end
      inherited DocumentNameEdit: TRegExprValidateEdit
        Top = 95
        Width = 707
        ExplicitTop = 95
        ExplicitWidth = 707
      end
      inherited DocumentNoteMemo: TRegExprValidateMemo
        Top = 199
        Width = 707
        Height = 42
        ExplicitTop = 199
        ExplicitWidth = 707
        ExplicitHeight = 42
      end
      inherited DocumentContentMemo: TRegExprValidateRichEdit
        Top = 118
        Width = 707
        Height = 75
        ExplicitTop = 118
        ExplicitWidth = 707
        ExplicitHeight = 75
      end
      inherited PerformerDepartmentShortNameEdit: TRegExprValidateEdit
        Width = 164
        ExplicitWidth = 164
      end
      inherited PerformerFullNameEdit: TRegExprValidateEdit
        Left = 363
        Width = 282
        ExplicitLeft = 363
        ExplicitWidth = 282
      end
      inherited PerformerTelephoneNumberEdit: TRegExprValidateEdit
        Left = 698
        Top = 31
        Width = 104
        ExplicitLeft = 698
        ExplicitTop = 31
        ExplicitWidth = 104
      end
      inherited SignerNameEdit: TRegExprValidateEdit
        Left = 363
        Top = 64
        Width = 101
        ExplicitLeft = 363
        ExplicitTop = 64
        ExplicitWidth = 101
      end
      inherited SignerDepartmentShortNameEdit: TRegExprValidateEdit
        Top = 64
        Width = 164
        ExplicitTop = 64
        ExplicitWidth = 164
      end
      inherited SignerDepartmentCodeEdit: TRegExprValidateEdit
        Top = 64
        ExplicitTop = 64
      end
      inherited SignerChooseButton: TcxButton
        Top = 64
        ExplicitTop = 64
      end
    end
  end
end
