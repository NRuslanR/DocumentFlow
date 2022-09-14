inherited DocumentFlowSystemInputMemoForm: TDocumentFlowSystemInputMemoForm
  Caption = 'DocumentFlowSystemInputMemoForm'
  Color = clWhite
  Constraints.MinHeight = 175
  Constraints.MinWidth = 386
  Position = poMainFormCenter
  ExplicitWidth = 394
  ExplicitHeight = 209
  PixelsPerInch = 96
  TextHeight = 13
  inherited InputMemo: TMemo
    ScrollBars = ssBoth
    ExplicitHeight = 128
  end
  inherited OKButton: TcxButton
    Font.Style = [fsBold]
    ParentFont = False
    ExplicitTop = 142
  end
  inherited CancelButton: TcxButton
    Font.Style = [fsBold]
    ParentFont = False
    ExplicitTop = 142
  end
end
