unit DocumentApproversReferenceFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, EmployeesReferenceFormUnit, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters, Menus, cxControls, cxStyles, dxSkinsCore,
  dxSkinsDefaultPainters, dxSkinscxPCPainter, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, DB, cxDBData, ZAbstractRODataset, ZAbstractDataset,
  ZDataset, ActnList, ImgList, PngImageList, cxGridLevel, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxClasses, cxGridCustomView, cxGrid,
  cxButtons, ComCtrls, pngimage, ExtCtrls, StdCtrls, ToolWin, cxLocalization,
  cxCheckBox;

type
  TDocumentApproversReferenceForm = class(TEmployeesReferenceForm)
  private

  protected

    procedure Init(
      const Caption: String = ''; ADataSet:
      TDataSet = nil
    ); override;

  public

  end;

var
  DocumentApproversReferenceForm: TDocumentApproversReferenceForm;

implementation

{$R *.dfm}

{ TDocumentApproversReferenceForm }

procedure TDocumentApproversReferenceForm.Init(const Caption: String;
  ADataSet: TDataSet);
begin

  inherited;

  EnableSelectionColumn := True;

end;

end.
