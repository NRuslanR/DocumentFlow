unit unServiceNoteCardFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unDocumentCardFrame, StdCtrls, ExtCtrls, ComCtrls;

type
  TServiceNoteCardFrame = class(TDocumentCardFrame)
  private

  public

    procedure RestoreUIControlProperties; override;
    procedure SaveUIControlProperties; override;

  end;

var
  ServiceNoteCardFrame: TServiceNoteCardFrame;

implementation

{$R *.dfm}

{ TServiceNoteCardFrame }

procedure TServiceNoteCardFrame.RestoreUIControlProperties;
begin

  inherited RestoreUIControlProperties;

end;

procedure TServiceNoteCardFrame.SaveUIControlProperties;
begin

  inherited SaveUIControlProperties;

end;

end.
