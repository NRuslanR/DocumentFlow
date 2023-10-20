unit unServiceNoteChargesFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unDocumentChargesFrame, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxCustomData, cxStyles, cxTL, cxMaskEdit, cxTextEdit,
  cxTLdxBarBuiltInMenu, dxSkinsCore, dxSkinsDefaultPainters, Menus, ActnList,
  DB, StdCtrls, cxButtons, cxInplaceContainer, cxDBTL, cxTLData, ExtCtrls;

type
  TServiceNoteChargesFrame = class(TDocumentChargesFrame)
  private

  public

  end;

var
  ServiceNoteChargesFrame: TServiceNoteChargesFrame;

implementation

{$R *.dfm}

end.
