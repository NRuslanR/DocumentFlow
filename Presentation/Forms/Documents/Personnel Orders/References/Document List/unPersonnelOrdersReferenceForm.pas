unit unPersonnelOrdersReferenceForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BaseOutcomingDocumentsReferenceFormUnit, cxGraphics,
  cxLookAndFeels, cxLookAndFeelPainters, Menus, dxSkinsCore,
  dxSkinsDefaultPainters, cxControls, cxStyles, dxSkinscxPCPainter,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, DB, cxDBData,
  cxTextEdit, cxSpinEdit, cxLocalization, ActnList, ImgList, PngImageList,
  cxGridLevel, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxClasses, cxGridCustomView, cxGrid, ComCtrls, ExtCtrls, StdCtrls, cxButtons,
  ToolWin, cxCheckBox, cxImageComboBox;

type
  TPersonnelOrdersReferenceForm = class(TBaseOutcomingDocumentsReferenceForm)
    SubKindNameColumn: TcxGridDBColumn;
    SubKindIdColumn: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PersonnelOrdersReferenceForm: TPersonnelOrdersReferenceForm;

implementation

{$R *.dfm}

end.
