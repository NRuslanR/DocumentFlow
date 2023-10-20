unit BaseApproveableDocumentsReferenceFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BaseDocumentsReferenceFormUnit, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters, Menus, dxSkinsCore, dxSkinsDefaultPainters, cxControls,
  cxStyles, dxSkinscxPCPainter, cxCustomData, cxFilter, cxData, cxDataStorage,
  cxEdit, DB, cxDBData, cxTextEdit, cxSpinEdit, cxLocalization, ActnList,
  ImgList, PngImageList, cxGridLevel, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxClasses, cxGridCustomView, cxGrid, ComCtrls, ExtCtrls,
  StdCtrls, cxButtons, ToolWin, DocumentSetHolder, ApproveableDocumentSetHolder,
  DocumentRecordViewModel, ApproveableDocumentRecordViewModel, cxCheckBox,
  cxImageComboBox;

type
  TBaseApproveableDocumentsReferenceForm = class(TBaseDocumentsReferenceForm)
    SenderDepartmentNameColumn: TcxGridDBColumn;
    ReceiverDepartmentNamesColumn: TcxGridDBColumn;
  private

  protected

    procedure UpdateDocumentToolButtonsVisibilityBy(DocumentSetHolder: TDocumentSetHolder); override;

  public

  end;

var
  BaseApproveableDocumentsReferenceForm: TBaseApproveableDocumentsReferenceForm;

implementation

uses DBDataTableFormUnit;

{$R *.dfm}

{ TBaseApproveableDocumentsReferenceForm }

procedure TBaseApproveableDocumentsReferenceForm.UpdateDocumentToolButtonsVisibilityBy(
  DocumentSetHolder: TDocumentSetHolder);
begin

  inherited;

  AddRecordActionVisible := DocumentSetHolder.AddingAllowed;

end;

end.
