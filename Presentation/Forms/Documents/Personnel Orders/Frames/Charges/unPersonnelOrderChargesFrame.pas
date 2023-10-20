unit unPersonnelOrderChargesFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unDocumentChargesFrame, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxCustomData, cxStyles, cxTL, cxMaskEdit, cxTextEdit,
  cxTLdxBarBuiltInMenu, dxSkinsCore, dxSkinsDefaultPainters, Menus, ActnList,
  DB, StdCtrls, cxButtons, cxInplaceContainer, cxDBTL, cxTLData, ExtCtrls;

type
  TPersonnelOrderChargesFrame = class(TDocumentChargesFrame)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PersonnelOrderChargesFrame: TPersonnelOrderChargesFrame;

implementation

{$R *.dfm}

end.
