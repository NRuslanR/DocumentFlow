unit unServiceNoteChargeSheetsFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unDocumentChargeSheetsFrame, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxCustomData, cxStyles, cxTL, cxMaskEdit, cxTextEdit,
  cxTLdxBarBuiltInMenu, dxSkinsCore, dxSkinsDefaultPainters, Menus, ActnList,
  DB, StdCtrls, cxButtons, cxInplaceContainer, cxDBTL, cxTLData, ExtCtrls;

type
  TServiceNoteChargeSheetsFrame = class(TDocumentChargeSheetsFrame)
  private

  public

  end;

var
  ServiceNoteChargeSheetsFrame: TServiceNoteChargeSheetsFrame;

implementation

{$R *.dfm}

end.
