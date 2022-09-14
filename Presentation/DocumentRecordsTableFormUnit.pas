unit DocumentRecordsTableFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DBDataTableFormUnit, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters, Menus, cxControls, cxStyles, dxSkinsCore,
  dxSkinsDefaultPainters, dxSkinscxPCPainter, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, DB, cxDBData, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, ActnList, ImgList, PngImageList, cxGridLevel, cxClasses,
  cxGridCustomView, cxGrid, cxButtons, ComCtrls, pngimage, ExtCtrls, StdCtrls,
  ToolWin, ZAbstractRODataset, ZAbstractDataset, ZDataset,
  DocumentFlowSystemBaseTableFormUnit;

type
  TDocumentRecordsTableForm = class(TDocumentFlowSystemBaseTableForm)
    DocumentNameColumn: TcxGridDBColumn;
    DocumentNumberColumn: TcxGridDBColumn;
    DocumentCreationDateColumn: TcxGridDBColumn;
    DocumentPerformerEmployeeColumn: TcxGridDBColumn;
    DocumentPerformerDepartmentColumn: TcxGridDBColumn;
    ZQuery1: TZQuery;
  private
    { Private declarations }
  public
    { Public declarations }

  end;

var
  DocumentRecordsTableForm: TDocumentRecordsTableForm;

implementation

{$R *.dfm}

{ TDocumentRecordsTableForm }

end.
