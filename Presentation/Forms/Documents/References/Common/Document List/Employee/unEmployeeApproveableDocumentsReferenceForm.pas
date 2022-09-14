unit unEmployeeApproveableDocumentsReferenceForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters, Menus, cxControls, cxStyles, dxSkinsCore,
  dxSkinsDefaultPainters, dxSkinscxPCPainter, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, DB, cxDBData, cxCheckBox, cxSpinEdit, ZSqlUpdate,
  ZAbstractRODataset, ZAbstractDataset, ZDataset, ActnList, ImgList,
  PngImageList, cxGridLevel, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxClasses, cxGridCustomView, cxGrid, cxButtons, ComCtrls,
  pngimage, ExtCtrls, StdCtrls, ToolWin, cxLocalization, cxTextEdit,
  unEmployeeOutcomingDocumentsReferenceForm, BaseDocumentsReferenceFormUnit,
  DocumentRecordViewModel, BaseApproveableDocumentsReferenceFormUnit,
  DocumentSetHolder;
  

type

  TEmployeeApproveableDocumentsReferenceForm =
    class(TBaseApproveableDocumentsReferenceForm)

      protected

        procedure Init(const Caption: String; ADataSet: TDataSet); override;

        procedure SetTableColumnLayoutFrom(FieldDefs: TDocumentSetFieldDefs); override;

      protected

        procedure FillDocumentRecordViewModelFromGridRecord(
          DocumentRecordViewModel: TDocumentRecordViewModel;
          GridRecord: TcxCustomGridRecord
        ); override;

        procedure FillDocumentDataSetRecordFrom(
          DocumentRecordViewModel:  TDocumentRecordViewModel
        ); override;

        procedure ChangeDocumentRecordByIndexFromViewModel(
          const RecordIndex: Integer;
          DocumentRecordViewModel: TDocumentRecordViewModel
        ); override;

      public

    end;

var
  EmployeeApproveableDocumentsReferenceForm: TEmployeeApproveableDocumentsReferenceForm;

implementation

uses

  DBDataTableFormUnit,
  EmployeeExtensionDocumentSetHolder;

{$R *.dfm}

{ TEmployeeDocumentsForApprovingReferenceForm }

procedure TEmployeeApproveableDocumentsReferenceForm.ChangeDocumentRecordByIndexFromViewModel(
  const RecordIndex: Integer;
  DocumentRecordViewModel: TDocumentRecordViewModel
);
begin

  inherited;

  ChangeEmployeeFieldsOfDocumentRecordFrom(RecordIndex, DocumentRecordViewModel);

end;

procedure TEmployeeApproveableDocumentsReferenceForm.FillDocumentDataSetRecordFrom(
  DocumentRecordViewModel: TDocumentRecordViewModel
);
begin

  inherited;

  FillEmployeeFieldsOfDocumentRecordFrom(DocumentRecordViewModel);

end;

procedure TEmployeeApproveableDocumentsReferenceForm.FillDocumentRecordViewModelFromGridRecord(
  DocumentRecordViewModel: TDocumentRecordViewModel;
  GridRecord: TcxCustomGridRecord
);
begin

  inherited;

  FillEmployeeFieldsOfDocumentRecordViewModelFrom(DocumentRecordViewModel, GridRecord);

end;

procedure TEmployeeApproveableDocumentsReferenceForm.Init(const Caption: String;
  ADataSet: TDataSet);
begin

  inherited;

  IsDocumentViewedColumn.VisibleForCustomization := True;
  
end;

procedure TEmployeeApproveableDocumentsReferenceForm.SetTableColumnLayoutFrom(
  FieldDefs: TDocumentSetFieldDefs);
begin

  inherited SetTableColumnLayoutFrom(FieldDefs);

  SetEmployeeExtensionTableColumnLayoutFrom(
    TEmployeeExtensionDocumentSetFieldDefs(FieldDefs.ExtensionFieldDefs)
  );
  
end;

end.
