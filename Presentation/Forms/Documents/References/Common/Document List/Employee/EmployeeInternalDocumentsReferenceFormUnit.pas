unit EmployeeInternalDocumentsReferenceFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters, Menus, dxSkinsCore, dxSkinsDefaultPainters, cxControls,
  cxStyles, dxSkinscxPCPainter, cxCustomData, cxFilter, cxData, cxDataStorage,
  cxEdit, DB, cxDBData, cxCheckBox, cxSpinEdit, cxLocalization, ActnList,
  ImgList, PngImageList, cxGridLevel, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxClasses, cxGridCustomView, cxGrid, ComCtrls, pngimage,
  ExtCtrls, StdCtrls, cxButtons, ToolWin,
  DocumentRecordViewModel,
  DocumentSetHolder,
  EmployeeIncomingDocumentsReferenceFormUnit, cxTextEdit;

type
  TEmployeeInternalDocumentsReferenceForm = class(TEmployeeIncomingDocumentsReferenceForm)

  end;

var
  EmployeeInternalDocumentsReferenceForm: TEmployeeInternalDocumentsReferenceForm;

implementation

{$R *.dfm}

end.
