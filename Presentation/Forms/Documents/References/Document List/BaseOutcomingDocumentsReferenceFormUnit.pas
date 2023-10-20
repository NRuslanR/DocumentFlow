
unit BaseOutcomingDocumentsReferenceFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BaseDocumentsReferenceFormUnit, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters, Menus, dxSkinsCore, dxSkinsDefaultPainters, cxControls,
  cxStyles, dxSkinscxPCPainter, cxCustomData, cxFilter, cxData, cxDataStorage,
  cxEdit, DB, cxDBData, cxTextEdit, cxSpinEdit, cxLocalization, ActnList,
  ImgList, PngImageList, cxGridLevel, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxClasses, cxGridCustomView, cxGrid, ComCtrls, ExtCtrls,
  StdCtrls, cxButtons, ToolWin, DocumentSetHolder, OutcomingDocumentSetHolder,
  cxCheckBox, cxImageComboBox;

type
  TBaseOutcomingDocumentsReferenceForm = class(TBaseDocumentsReferenceForm)
    ReceivingDepartmentNamesColumn: TcxGridDBColumn;
  private

  public

  end;

var
  BaseOutcomingDocumentsReferenceForm: TBaseOutcomingDocumentsReferenceForm;

implementation

{$R *.dfm}



end.
