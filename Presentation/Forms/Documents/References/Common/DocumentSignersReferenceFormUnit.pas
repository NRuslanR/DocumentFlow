unit DocumentSignersReferenceFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, EmployeesReferenceFormUnit, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters, Menus, cxControls, cxStyles, dxSkinsCore,
  dxSkinsDefaultPainters, dxSkinscxPCPainter, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, DB, cxDBData, ActnList, ImgList, PngImageList,
  cxGridLevel, cxClasses, cxGridCustomView, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxGrid, cxButtons, ComCtrls, pngimage,
  ExtCtrls, StdCtrls, ToolWin, ZAbstractRODataset, ZAbstractDataset, ZDataset,
  cxLocalization, cxCheckBox;

type
  TDocumentSignersReferenceForm = class(TEmployeesReferenceForm)

  public

    constructor Create(AOwner: TComponent); overload; override;

  end;

implementation
  
{$R *.dfm}

{ TDocumentApprovingLeadersDBTableForm }

constructor TDocumentSignersReferenceForm.Create(AOwner: TComponent);
begin

  inherited;

end;

end.
