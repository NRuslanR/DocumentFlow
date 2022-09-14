inherited DocumentFlowWorkingFrame: TDocumentFlowWorkingFrame
  Width = 799
  Height = 562
  OnResize = FormResize
  ExplicitWidth = 799
  ExplicitHeight = 562
  inherited ScrollBox: TScrollBox
    Width = 799
    Height = 562
    ExplicitWidth = 799
    ExplicitHeight = 562
    object SeparatorBetweenDocumentTypesAndRest: TSplitter
      Left = 233
      Top = 0
      Width = 6
      Height = 562
      Color = clGradientInactiveCaption
      ParentColor = False
      ExplicitLeft = 6
      ExplicitHeight = 559
    end
    object DocumentKindsFrameArea: TPanel
      Left = 0
      Top = 0
      Width = 233
      Height = 562
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 0
    end
    object DocumentCardListFrameArea: TPanel
      Left = 239
      Top = 0
      Width = 560
      Height = 562
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
    end
  end
end
