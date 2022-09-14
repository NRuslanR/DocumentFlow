unit unApproveableServiceNotesReferenceForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BaseApproveableDocumentsReferenceFormUnit, cxGraphics,
  cxLookAndFeels, cxLookAndFeelPainters, Menus, dxSkinsCore,
  dxSkinsDefaultPainters, cxControls, cxStyles, dxSkinscxPCPainter,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, DB, cxDBData,
  cxTextEdit, cxSpinEdit, cxLocalization, ActnList, ImgList, PngImageList,
  cxGridLevel, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxClasses, cxGridCustomView, cxGrid, ComCtrls, ExtCtrls, StdCtrls, cxButtons,
  ToolWin;

type
  TApproveableServiceNotesReferenceForm = class(TBaseApproveableDocumentsReferenceForm)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ApproveableServiceNotesReferenceForm: TApproveableServiceNotesReferenceForm;

implementation

{$R *.dfm}

end.
