unit unOutcomingServiceNotesReferenceForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BaseOutcomingDocumentsReferenceFormUnit, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters, Menus, dxSkinsCore, dxSkinsDefaultPainters, cxControls,
  cxStyles, dxSkinscxPCPainter, cxCustomData, cxFilter, cxData, cxDataStorage,
  cxEdit, DB, cxDBData, cxTextEdit, cxSpinEdit, cxLocalization, ActnList,
  ImgList, PngImageList, cxGridLevel, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxClasses, cxGridCustomView, cxGrid, ComCtrls, ExtCtrls,
  StdCtrls, cxButtons, ToolWin, cxCheckBox, cxImageComboBox;

type
  TOutcomingServiceNotesReferenceForm = class(TBaseOutcomingDocumentsReferenceForm)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  OutcomingServiceNotesReferenceForm: TOutcomingServiceNotesReferenceForm;

implementation

{$R *.dfm}

end.
