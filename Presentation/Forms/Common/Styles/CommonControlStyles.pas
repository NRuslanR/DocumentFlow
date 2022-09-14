{ Refactor: преобразовать в AmbientContext-класс }
unit CommonControlStyles;

interface

uses

  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, ExtCtrls, cxButtons, StdCtrls,
  ComCtrls, DBDataTableFormUnit;

type

  TDocumentFlowCommonControlStyles = class

    const

      BUTTON_BACKGROUND_COLOR = $00ebb99d;
      SPLITTER_COLOR = $00c8b594;
      CONTAINTER_CONTROL_BACKGROUND_COLOR = clWhite;
      PAGE_CONTROL_TAB_COLOR = $00f8e4d8;
      PAGE_CONTROL_ACTIVE_PAGE_TAB_COLOR = $00ebb99d;

    private

      class procedure ApplyStylesToDBDataTableForm(DBDataTableForm: TDBDataTableForm); static;

    public

      class function GetButtonBackgroundColor: TColor; static;
      class function GetFormBackgroundColor: TColor; static;
      class function GetPanelBackgroundColor: TColor; static;
      class function GetFrameBackgroundColor: TColor; static;
      class function GetDockPanelBackground: TColor; static;
      class function GetLabelFontStyle: TFontStyles; static;
      class function GetButtonCaptionFontStyle: TFontStyles; static;
      class function GetSplitterColor: TColor; static;
      class function GetTableFormToolBarColor: TColor; static;
      class function GetTableFormToolBarGradientColorStart: TColor; static;
      class function GetTableFormToolBarGradientColorEnd: TColor; static;
      class function GetSplitterThickness: Integer; static;
      class function GetPrimaryFrameBackgroundColor: TColor; static;
      class function GetPageControlTabColor: TColor; static;
      class function GetActivePageControlTabColor: TColor; static;

    public

      class function GetDocumentFlowBaseReferenceFormSelectedRecordColor: TColor; static;
      class function GetDocumentFlowBaseReferenceFormFocusedRecordColor: TColor; static;
      class function GetDocumentFlowBaseReferenceFormSelectedCellTextColor: TColor; static;
      class function GetDocumentFlowBaseReferenceFormFocusedCellTextColor: TColor; static;

    public

      class procedure ApplyStylesToWinControl(WinControl: TWinControl); static;

      class procedure ApplyStylesToLabel(LabelControl: TLabel); static;
      class procedure ApplyStylesToButton(Button: TButton); static;
      class procedure ApplyStylesToPanel(Panel: TPanel); static;
      class procedure ApplyStylesToForm(Form: TForm); static;
      class procedure ApplyStylesToFrame(Frame: TFrame); static;
      class procedure ApplyStylesToSplitter(Splitter: TSplitter); static;

  end;

implementation

uses

  AuxDebugFunctionsUnit,
  AuxWindowsFunctionsUnit,
  cxTL,
  cxGrid,
  cxControls,
  cxLookAndFeels;
  
{ TDocumentFlowCommonControlStyles }

class procedure TDocumentFlowCommonControlStyles.ApplyStylesToButton(
  Button: TButton);
var Bitmap: TBitmap;
begin
                
  if Button is TcxButton then begin

    (Button as TcxButton).Colors.Default := GetButtonBackgroundColor;

  end;
  
  Button.Font.Style := GetButtonCaptionFontStyle;

  Bitmap := TBitmap.Create;

  try

    Bitmap.Canvas.Font := Button.Font;

    AdjustControlSizeByContentIfClipped(
      Button, Bitmap.Canvas, Rect(10, 6, 10, 6)
    );

  finally

    FreeAndNil(Bitmap);

  end;
                              
end;

class procedure TDocumentFlowCommonControlStyles.ApplyStylesToDBDataTableForm(
  DBDataTableForm: TDBDataTableForm);
begin

  with DBDataTableForm do begin

    DataRecordGrid.LookAndFeel.SkinName := 'UserSkin';
    DataRecordMovingToolBar.Visible := False;

    FocusedCellColor :=
      TDocumentFlowCommonControlStyles
        .GetDocumentFlowBaseReferenceFormFocusedRecordColor;

    SelectedRecordsColor :=
      TDocumentFlowCommonControlStyles
        .GetDocumentFlowBaseReferenceFormSelectedRecordColor;

    FocusedCellTextColor :=
      TDocumentFlowCommonControlStyles
        .GetDocumentFlowBaseReferenceFormFocusedCellTextColor;

    SelectedRecordsTextColor :=
      TDocumentFlowCommonControlStyles
        .GetDocumentFlowBaseReferenceFormSelectedCellTextColor;
    
  end;

end;

class procedure TDocumentFlowCommonControlStyles.ApplyStylesToForm(Form: TForm);
begin

  Form.Color := GetFormBackgroundColor;

  ApplyStylesToWinControl(Form);

end;

class procedure TDocumentFlowCommonControlStyles.ApplyStylesToFrame(
  Frame: TFrame);
begin

  Frame.Color := GetFrameBackgroundColor;

  ApplyStylesToWinControl(Frame);

end;

class procedure TDocumentFlowCommonControlStyles.ApplyStylesToLabel(
  LabelControl: TLabel);
begin

  LabelControl.Font.Style := GetLabelFontStyle;

end;

class procedure TDocumentFlowCommonControlStyles.ApplyStylesToPanel(
  Panel: TPanel);
begin

  Panel.Color := GetPanelBackgroundColor;

  ApplyStylesToWinControl(Panel);

end;

class procedure TDocumentFlowCommonControlStyles.ApplyStylesToSplitter(
  Splitter: TSplitter);
begin

  with Splitter do begin

    Color := GetSplitterColor;

    if Align in [alLeft, alRight] then
      Width := GetSplitterThickness

    else Height := GetSplitterThickness;

    AutoSnap := False;

  end;

end;

class procedure TDocumentFlowCommonControlStyles.ApplyStylesToWinControl(
  WinControl: TWinControl);
var Control: TControl;
    I: Integer;
    LookAndFeel: TcxLookAndFeel;
begin
  
  if WinControl is TDBDataTableForm then begin

    ApplyStylesToDBDataTableForm(TDBDataTableForm(WinControl));

    Exit;
    
  end

  else if WinControl is TForm then begin

    TForm(WinControl).Color :=
      TDocumentFlowCommonControlStyles.GetFormBackgroundColor;

  end

  else if WinControl is TFrame then begin

    TFrame(WinControl).Color :=
      TDocumentFlowCommonControlStyles.GetFrameBackgroundColor;

  end

  else if WinControl is TPanel then begin

    TPanel(WinControl).Color :=
      TDocumentFlowCommonControlStyles.GetPanelBackgroundColor;

  end

  else if WinControl is TScrollBox then begin

    TScrollBox(WinControl).Color :=
      TDocumentFlowCommonControlStyles.GetPanelBackgroundColor;

  end

  else if
    (WinControl is TcxCustomGrid) or
    (WinControl is TcxCustomTreeList)
  then begin

    if WinControl is TcxCustomGrid then
      LookAndFeel := TcxCustomGrid(WinControl).LookAndFeel

    else LookAndFeel := TcxCustomTreeList(WinControl).LookAndFeel;

    LookAndFeel.SkinName := 'UserSkin';

  end;

  for I := 0 to WinControl.ControlCount - 1 do begin

    Control := WInControl.Controls[I];
    
    if Control is TLabel then
      ApplyStylesToLabel(Control as TLabel)

    else if Control is TButton then
      ApplyStylesToButton(Control as TButton)

    else if Control is TPanel then
      ApplyStylesToPanel(Control as TPanel)

    else if Control is TForm then
      ApplyStylesToForm(Control as TForm)

    else if Control is TFrame then
      ApplyStylesToFrame(Control as TFrame)

    else if Control is TSplitter then
      ApplyStylesToSplitter(Control as TSplitter)

    else if Control is TWinControl then
      ApplyStylesToWinControl(Control as TWinControl)

    else ;

  end;

end;

class function TDocumentFlowCommonControlStyles.GetActivePageControlTabColor: TColor;
begin

  Result := PAGE_CONTROL_ACTIVE_PAGE_TAB_COLOR;
  
end;

class function TDocumentFlowCommonControlStyles.GetButtonBackgroundColor: TColor;
begin

  Result := BUTTON_BACKGROUND_COLOR;

end;

class function TDocumentFlowCommonControlStyles.GetButtonCaptionFontStyle: TFontStyles;
begin

  Result := [fsBold];

end;

class function TDocumentFlowCommonControlStyles.GetDockPanelBackground: TColor;
begin

  Result := $00f2d0a7;

end;

class function TDocumentFlowCommonControlStyles.
  GetDocumentFlowBaseReferenceFormFocusedCellTextColor: TColor;
begin

  Result :=  $00ffffff;

end;

class function TDocumentFlowCommonControlStyles.
  GetDocumentFlowBaseReferenceFormFocusedRecordColor: TColor;
begin

  Result := $00c56a31;

end;

class function TDocumentFlowCommonControlStyles.
  GetDocumentFlowBaseReferenceFormSelectedCellTextColor: TColor;
begin

  Result := $00ffffff;
  
end;

class function TDocumentFlowCommonControlStyles.
  GetDocumentFlowBaseReferenceFormSelectedRecordColor: TColor;
begin

  Result := $00c56a31;
  
end;

class function TDocumentFlowCommonControlStyles.GetFormBackgroundColor: TColor;
begin

  Result := CONTAINTER_CONTROL_BACKGROUND_COLOR;

end;

class function TDocumentFlowCommonControlStyles.GetFrameBackgroundColor: TColor;
begin

  Result := CONTAINTER_CONTROL_BACKGROUND_COLOR;

end;

class function TDocumentFlowCommonControlStyles.GetLabelFontStyle: TFontStyles;
begin

  Result := [];
  
end;

class function TDocumentFlowCommonControlStyles.GetPageControlTabColor: TColor;
begin

  Result := PAGE_CONTROL_TAB_COLOR;
  
end;

class function TDocumentFlowCommonControlStyles.GetPanelBackgroundColor: TColor;
begin

  Result := CONTAINTER_CONTROL_BACKGROUND_COLOR;
  
end;

class function TDocumentFlowCommonControlStyles.GetPrimaryFrameBackgroundColor: TColor;
begin

  Result := $00f8e4d8;
  
end;

class function TDocumentFlowCommonControlStyles.GetSplitterColor: TColor;
begin

  Result := SPLITTER_COLOR;
  
end;

class function TDocumentFlowCommonControlStyles.GetSplitterThickness: Integer;
begin

  Result := 6;
  
end;

class function TDocumentFlowCommonControlStyles.
  GetTableFormToolBarColor: TColor;
begin

  Result := $00fffceb;
  
end;

class function TDocumentFlowCommonControlStyles.
  GetTableFormToolBarGradientColorEnd: TColor;
begin

  Result := GetTableFormToolBarColor;
  
end;

class function TDocumentFlowCommonControlStyles.
  GetTableFormToolBarGradientColorStart: TColor;
begin

  Result := $00ffffff;
  
end;

end.
