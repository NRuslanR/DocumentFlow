unit CreateableDocumentMainInformationFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters, Menus, StdCtrls, cxButtons, ValidateMemoUnit,
  RegExprValidateMemoUnit, ValidateEditUnit, RegExprValidateEditUnit, ComCtrls,
  ExtCtrls, DocumentMainInformationFrameUnit,
  ExtendedDocumentMainInformationFrameUnit, ValidateRichEdit,
  RegExprValidateRichEdit, dxSkinsCore, dxSkinsDefaultPainters;

type
  TCreatableDocumentMainInformationFrame = class(TExtendedDocumentMainInformationFrame)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  CreatableDocumentMainInformationFrame: TCreatableDocumentMainInformationFrame;

implementation

{$R *.dfm}

end.
