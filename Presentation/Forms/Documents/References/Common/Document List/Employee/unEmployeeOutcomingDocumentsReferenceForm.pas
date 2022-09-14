unit unEmployeeOutcomingDocumentsReferenceForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters, Menus, cxControls, cxStyles, dxSkinsCore,
  dxSkinsDefaultPainters, dxSkinscxPCPainter, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, DB, cxDBData, ZSqlUpdate, ZAbstractRODataset,
  ZAbstractDataset, ZDataset, ActnList, ImgList, PngImageList, cxGridLevel,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxClasses,
  cxGridCustomView, cxGrid, cxButtons, ComCtrls, pngimage, ExtCtrls,
  StdCtrls,
  ToolWin,
  cxSpinEdit,
  cxTextEdit,
  BaseOutcomingDocumentsReferenceFormUnit,
  cxCheckBox,
  UIDocumentKindResolver,
  DocumentSetHolder,
  OutcomingDocumentSetHolder,
  OutcomingDocumentRecordViewModel,
  EmployeeDocumentChargesWorkStatistics,
  DocumentRecordViewModel, cxLocalization, BaseDocumentsReferenceFormUnit;

type

  TEmployeeOutcomingDocumentsReferenceForm = class(TBaseOutcomingDocumentsReferenceForm)
    
  protected
      
    procedure Init(const Caption: String; ADataSet: TDataSet); override;

  protected

    function FetchOutcomingDocumentRecordViewModel(
      DocumentRecordViewModel: TDocumentRecordViewModel
    ): TOutcomingDocumentRecordViewModel;

  protected

    procedure FillDocumentRecordViewModelFromGridRecord(
      DocumentRecordViewModel: TDocumentRecordViewModel;
      GridRecord: TcxCustomGridRecord
    ); override;

    procedure FillDocumentDataSetRecordFrom(
      DocumentRecordViewModel:  TDocumentRecordViewModel
    ); override;

    procedure InternalChangeDocumentRecordByIndexFromViewModel(
      const RecordIndex: Integer;
      DocumentRecordViewModel: TDocumentRecordViewModel
    ); override;

  protected

    procedure FillEmployeeFieldsOfDocumentRecordFrom(
      DocumentRecordViewModel:  TDocumentRecordViewModel
    ); override;

    procedure FillEmployeeFieldsOfDocumentRecordViewModelFrom(
      DocumentRecordViewModel: TDocumentRecordViewModel;
      GridRecord: TcxCustomGridRecord
    ); override;

    procedure ChangeEmployeeFieldsOfDocumentRecordFrom(
      const RecordIndex: Integer;
      DocumentRecordViewModel: TDocumentRecordViewModel
    ); override;
    
  protected

    procedure SetTableColumnLayoutFrom(FieldDefs: TDocumentSetFieldDefs); override;

  public
    { Public declarations }

    destructor Destroy; override;

  end;

var
  EmployeeDocumentsReferenceForm: TEmployeeOutcomingDocumentsReferenceForm;

implementation

uses

  unDocumentCardFrame,
  DocumentCardFormUnit,
  AuxDebugFunctionsUnit,
  AuxiliaryStringFunctions,
  ZConnection,
  WorkingEmployeeUnit,
  EmployeeExtensionDocumentSetHolder,
  ApplicationPropertiesStorageRegistry,
  DBDataTableFormUnit;

{$R *.dfm}

{ TEditableEmployeeDocumentsReferenceForm }

function TEmployeeOutcomingDocumentsReferenceForm.FetchOutcomingDocumentRecordViewModel(
  DocumentRecordViewModel: TDocumentRecordViewModel): TOutcomingDocumentRecordViewModel;
begin

  Result :=
    TOutcomingDocumentRecordViewModel(
      FDocumentRecordViewModelMapper.FetchTypedDocumentRecordViewModel(
        DocumentRecordViewModel, TOutcomingDocumentRecordViewModel
      )
    );
    
end;

procedure TEmployeeOutcomingDocumentsReferenceForm.FillDocumentDataSetRecordFrom(
  DocumentRecordViewModel: TDocumentRecordViewModel
);
begin

  inherited FillDocumentDataSetRecordFrom(DocumentRecordViewModel);

  FillEmployeeFieldsOfDocumentRecordFrom(DocumentRecordViewModel);

  with
    DocumentSetHolder as TOutcomingDocumentSetHolder,
    FetchOutcomingDocumentRecordViewModel(DocumentRecordViewModel)
  do begin

    IsSelfRegisteredFieldValue := IsSelfRegistered;

  end;

end;

procedure TEmployeeOutcomingDocumentsReferenceForm.
  FillDocumentRecordViewModelFromGridRecord(
    DocumentRecordViewModel: TDocumentRecordViewModel;
    GridRecord: TcxCustomGridRecord
  );
begin

  inherited FillDocumentRecordViewModelFromGridRecord(
    DocumentRecordViewModel, GridRecord
  );

  FillEmployeeFieldsOfDocumentRecordViewModelFrom(
    DocumentRecordViewModel, GridRecord
  );
  
  with FetchOutcomingDocumentRecordViewModel(DocumentRecordViewModel) do begin

    IsSelfRegistered := GetRecordCellValue(GridRecord, DocumentIsSelfRegisteredColumn.Index);

  end;

end;

procedure TEmployeeOutcomingDocumentsReferenceForm.ChangeEmployeeFieldsOfDocumentRecordFrom(
  const RecordIndex: Integer;
  DocumentRecordViewModel: TDocumentRecordViewModel);
begin

  inherited ChangeEmployeeFieldsOfDocumentRecordFrom(
    RecordIndex, DocumentRecordViewModel
  );

end;

procedure TEmployeeOutcomingDocumentsReferenceForm.FillEmployeeFieldsOfDocumentRecordFrom(
  DocumentRecordViewModel: TDocumentRecordViewModel
);
begin

  inherited FillEmployeeFieldsOfDocumentRecordFrom(DocumentRecordViewModel);

end;

procedure TEmployeeOutcomingDocumentsReferenceForm.FillEmployeeFieldsOfDocumentRecordViewModelFrom(
  DocumentRecordViewModel: TDocumentRecordViewModel;
  GridRecord: TcxCustomGridRecord);
begin

  inherited FillEmployeeFieldsOfDocumentRecordViewModelFrom(
    DocumentRecordViewModel, GridRecord
  );

end;

destructor TEmployeeOutcomingDocumentsReferenceForm.Destroy;
begin

  inherited;

end;

procedure TEmployeeOutcomingDocumentsReferenceForm.Init(const Caption: String;
  ADataSet: TDataSet);
begin

  inherited Init(Caption, ADataSet);

  IsDocumentViewedColumn.VisibleForCustomization := True;
  
end;

procedure TEmployeeOutcomingDocumentsReferenceForm.InternalChangeDocumentRecordByIndexFromViewModel(
  const RecordIndex: Integer;
  DocumentRecordViewModel: TDocumentRecordViewModel);

begin

  inherited;

  ChangeEmployeeFieldsOfDocumentRecordFrom(RecordIndex, DocumentRecordViewModel);

  with
    DataRecordGridTableView.DataController,
    FetchOutcomingDocumentRecordViewModel(DocumentRecordViewModel)
  do begin

    Values[RecordIndex, DocumentIsSelfRegisteredColumn.Index] :=
      IsSelfRegistered;

  end;

end;

procedure TEmployeeOutcomingDocumentsReferenceForm.SetTableColumnLayoutFrom(
  FieldDefs: TDocumentSetFieldDefs);
begin

  inherited SetTableColumnLayoutFrom(FieldDefs);

  SetEmployeeExtensionTableColumnLayoutFrom(
    TEmployeeExtensionDocumentSetFieldDefs(FieldDefs.ExtensionFieldDefs)
  );
  
  with FieldDefs as TOutcomingDocumentSetFieldDefs do begin

    DocumentIsSelfRegisteredColumn.DataBinding.FieldName :=
      IsSelfRegisteredFieldName;
      
  end;
  
end;

end.
