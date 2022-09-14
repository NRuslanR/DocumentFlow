unit StandardDocumentFlowStyle;

interface

uses

  UIControlStyle,
  Controls,
  SysUtils;

type

  TStandardDocumentFlowStyle = class (TUIControlStyle)

    public

      procedure Apply(Control: TWinControl); override;

  end;

implementation

uses

  CommonControlStyles;

{ TStandardDocumentFlowStyle }

procedure TStandardDocumentFlowStyle.Apply(Control: TWinControl);
begin

  TDocumentFlowCommonControlStyles.ApplyStylesToWinControl(Control);

end;

end.
