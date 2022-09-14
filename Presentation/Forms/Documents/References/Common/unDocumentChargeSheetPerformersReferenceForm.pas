unit unDocumentChargeSheetPerformersReferenceForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DocumentChargePerformersReferenceFormUnit, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters, Menus, cxControls, cxStyles, dxSkinsCore,
  dxSkinsDefaultPainters, dxSkinscxPCPainter, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, DB, cxDBData, ZAbstractRODataset, ZAbstractDataset,
  ZDataset, ActnList, ImgList, PngImageList, cxGridLevel, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxClasses, cxGridCustomView, cxGrid,
  cxButtons, ComCtrls, pngimage, ExtCtrls, StdCtrls, ToolWin, cxLocalization,
  cxCheckBox;

type
  TDocumentChargeSheetPerformersReferenceForm = class(TDocumentChargePerformersReferenceForm)
  private
    { Private declarations }

  public
    { Public declarations }
  end;

var
  DocumentChargeSheetPerformersReferenceForm: TDocumentChargeSheetPerformersReferenceForm;

implementation

{$R *.dfm}

end.
