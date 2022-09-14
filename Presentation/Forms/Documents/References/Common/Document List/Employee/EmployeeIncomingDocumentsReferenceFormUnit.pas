unit EmployeeIncomingDocumentsReferenceFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxGraphics,
  cxLookAndFeels, cxLookAndFeelPainters, Menus, cxControls, cxStyles,
  dxSkinsCore, dxSkinsDefaultPainters, dxSkinscxPCPainter, cxCustomData,
  cxFilter, cxData, cxDataStorage, cxEdit, DB, cxDBData, ZSqlUpdate,
  ZAbstractRODataset, ZAbstractDataset, ZDataset, ActnList, ImgList,
  PngImageList, cxGridLevel, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxClasses, cxGridCustomView, cxGrid, cxButtons, ComCtrls,
  pngimage, ExtCtrls, StdCtrls, ToolWin, cxSpinEdit,
  EmployeeDocumentChargesWorkStatistics, cxCheckBox,
  DocumentRecordViewModel,
  unDocumentCardFrame,
  DocumentSetHolder,
  IncomingDocumentSetHolder,
  NativeDocumentKindDto,
  IncomingDocumentRecordViewModel, cxLocalization, cxTextEdit,
  EmployeeIncomingDocumentRecordViewModel,
  EmployeeExtensionIncomingDocumentSetHolder,
  BaseIncomingDocumentsReferenceFormUnit,
  EmployeeExtensionDocumentSetHolder;

type
    
  TEmployeeIncomingDocumentsReferenceForm = class(TBaseIncomingDocumentsReferenceForm)

    procedure DataRecordGridTableViewCustomDrawCell(
      Sender: TcxCustomGridTableView; ACanvas: TcxCanvas;
      AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);

  protected

    procedure Init(const Caption: String; ADataSet: TDataSet); override;
    
  protected

    function FetchEmployeeIncomingDocumentRecordViewModel(
      DocumentRecordViewModel: TDocumentRecordViewModel
    ): TEmployeeIncomingDocumentRecordViewModel;

  protected

    function GetIncomingDocumentGridRecordColor(GridRecord: TcxCustomGridRecord): TColor; override;

  protected

    function AreAllChargePerformed(
      const TotalChargeCount, PerformedChargeCount: Integer
    ): boolean; override;
    
  public

    procedure FillIncomingDocumentDataSetRecordFieldsFrom(
      DocumentRecordViewModel:  TDocumentRecordViewModel
    ); override;

  public

    procedure FillIncomingDocumentRecordViewModelFromGridRecord(
      DocumentRecordViewModel: TDocumentRecordViewModel;
      GridRecord: TcxCustomGridRecord
    ); override;

  protected

    procedure InternalChangeIncomingDocumentRecordByIndexFromViewModel(
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
    procedure SetEmployeeExtensionTableColumnLayoutFrom(EmployeeExtensionFieldDefs: TEmployeeExtensionDocumentSetFieldDefs); override;
    procedure SetIncomingDocumentTableColumnLayoutFrom(FieldDefs: TDocumentSetFieldDefs); override;

  protected

    procedure OnDocumentChargeWorkStatisticsRecordCellChanging(
      const RecordIndex: Integer;
      const TotalChargeCount: Integer;
      const PerformedChargeCount: Integer
    ); override;

    procedure UpdateAllSubordinateChargeSheetsPerformedFieldValue(
      const RecordIndex: Integer;
      const TotalChargeCount: Integer;
      const PerformedChargeCount: Integer
    ); virtual;

  protected

    procedure SetViewOnly(const Value: Boolean); override;
    
  protected

    procedure SetActivatedDataOperationControls(const Activated: Boolean); override;
    procedure UpdateDataOperationControls; override;

  end;

var
  EmployeeIncomingDocumentsReferenceForm: TEmployeeIncomingDocumentsReferenceForm;

implementation

uses

  RespondingDocumentCreatingAppService,
  ApplicationServiceRegistries,
  DocumentCardFormViewModelMapperFactories,
  DocumentCardFrameFactories,
  UIDocumentKinds,
  DocumentKinds,
  WorkingEmployeeUnit,
  AuxWindowsFunctionsUnit,
  DocumentFullInfoDTO,
  DocumentUsageEmployeeAccessRightsInfoDTO,
  DBDataTableFormUnit,
  DocumentCardFormViewModelMapperFactory,
  DocumentCardFormViewModelMapper,
  DocumentCardFrameFactory,
  DocumentCardFormUnit,
  unApplicationMainForm,
  DocumentBusinessProcessServiceRegistry,
  unDocumentFlowWorkingFrame, BaseDocumentsReferenceFormUnit;

{$R *.dfm}

{ TEmployeeIncommingServiceNotesReferenceForm }

function TEmployeeIncomingDocumentsReferenceForm.FetchEmployeeIncomingDocumentRecordViewModel(
  DocumentRecordViewModel: TDocumentRecordViewModel): TEmployeeIncomingDocumentRecordViewModel;
begin

  Result :=
    TEmployeeIncomingDocumentRecordViewModel(
      FDocumentRecordViewModelMapper.FetchTypedDocumentRecordViewModel(
        DocumentRecordViewModel,
        TEmployeeIncomingDocumentRecordViewModel
      )
    );
    
end;

procedure TEmployeeIncomingDocumentsReferenceForm.FillEmployeeFieldsOfDocumentRecordFrom(
  DocumentRecordViewModel: TDocumentRecordViewModel);
begin

  inherited FillEmployeeFieldsOfDocumentRecordFrom(DocumentRecordViewModel);

  with
    TEmployeeExtensionIncomingDocumentSetHolder(
      DocumentSetHolder.ExtensionSetHolder
    ),
    FetchEmployeeIncomingDocumentRecordViewModel(DocumentRecordViewModel)
  do begin

    if VarIsNull(AllChargeSheetsPerformed) or VarIsNull(AllSubordinateChargeSheetsPerformed)
    then Exit;

    AllChargeSheetsPerformedFieldValue := AllChargeSheetsPerformed;
    AllSubordinateChargeSheetsPerformedFieldValue := AllSubordinateChargeSheetsPerformed;

  end;
  
end;

procedure TEmployeeIncomingDocumentsReferenceForm.FillEmployeeFieldsOfDocumentRecordViewModelFrom(
  DocumentRecordViewModel: TDocumentRecordViewModel;
  GridRecord: TcxCustomGridRecord);
begin

  inherited FillEmployeeFieldsOfDocumentRecordViewModelFrom(
    DocumentRecordViewModel, GridRecord
  );

  with FetchEmployeeIncomingDocumentRecordViewModel(DocumentRecordViewModel)
  do begin

    AllChargeSheetsPerformed :=
      GetRecordCellValue(
        GridRecord,
        AllChargeSheetsPerformedColumn.Index
      );

    AllSubordinateChargeSheetsPerformed :=
      GetRecordCellValue(
        GridRecord,
        AllSubordinateChargeSheetsPerformedColumn.Index
      );
      
  end;

end;

function TEmployeeIncomingDocumentsReferenceForm.AreAllChargePerformed(
  const TotalChargeCount, PerformedChargeCount: Integer): boolean;
begin

  Result :=
    TEmployeeExtensionIncomingDocumentSetHolder(
      DocumentSetHolder.ExtensionSetHolder
    ).AllChargeSheetsPerformedFieldValue

    or (
      (TotalChargeCount = 0) and (PerformedChargeCount = 0)
    );
    
end;

procedure TEmployeeIncomingDocumentsReferenceForm.ChangeEmployeeFieldsOfDocumentRecordFrom(
  const RecordIndex: Integer;
  DocumentRecordViewModel: TDocumentRecordViewModel);
begin

  inherited ChangeEmployeeFieldsOfDocumentRecordFrom(
    RecordIndex, DocumentRecordViewModel
  );

end;

procedure TEmployeeIncomingDocumentsReferenceForm.DataRecordGridTableViewCustomDrawCell(
  Sender: TcxCustomGridTableView; ACanvas: TcxCanvas;
  AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
begin

  inherited;

  //

end;

procedure TEmployeeIncomingDocumentsReferenceForm.FillIncomingDocumentDataSetRecordFieldsFrom(
  DocumentRecordViewModel: TDocumentRecordViewModel);
begin

  inherited FillIncomingDocumentDataSetRecordFieldsFrom(
    DocumentRecordViewModel
  );

  FillEmployeeFieldsOfDocumentRecordFrom(DocumentRecordViewModel);
  
end;

procedure TEmployeeIncomingDocumentsReferenceForm.FillIncomingDocumentRecordViewModelFromGridRecord(
  DocumentRecordViewModel: TDocumentRecordViewModel;
  GridRecord: TcxCustomGridRecord);
begin

  inherited FillIncomingDocumentRecordViewModelFromGridRecord(
    DocumentRecordViewModel, GridRecord
  );

  FillEmployeeFieldsOfDocumentRecordViewModelFrom(
    DocumentRecordViewModel, GridRecord
  );

end;

procedure TEmployeeIncomingDocumentsReferenceForm.Init(const Caption: String;
  ADataSet: TDataSet);
begin

  inherited;

  IsDocumentViewedColumn.VisibleForCustomization := True;
  
end;

procedure TEmployeeIncomingDocumentsReferenceForm.InternalChangeIncomingDocumentRecordByIndexFromViewModel(
  const RecordIndex: Integer;
  DocumentRecordViewModel: TDocumentRecordViewModel
);
begin

  inherited InternalChangeIncomingDocumentRecordByIndexFromViewModel(
    RecordIndex, DocumentRecordViewModel
  );

  ChangeEmployeeFieldsOfDocumentRecordFrom(RecordIndex, DocumentRecordViewModel);
  
  with DocumentRecordViewModel as TEmployeeIncomingDocumentRecordViewModel
  do begin

  end;

end;

procedure TEmployeeIncomingDocumentsReferenceForm.
  OnDocumentChargeWorkStatisticsRecordCellChanging(
    const RecordIndex: Integer;
    const TotalChargeCount, PerformedChargeCount: Integer
  );
begin

  UpdateAllSubordinateChargeSheetsPerformedFieldValue(
    RecordIndex, TotalChargeCount, PerformedChargeCount
  );

  inherited OnDocumentChargeWorkStatisticsRecordCellChanging(
    RecordIndex, TotalChargeCount, PerformedChargeCount
  );

end;

procedure TEmployeeIncomingDocumentsReferenceForm.
  UpdateAllSubordinateChargeSheetsPerformedFieldValue(
    const RecordIndex, TotalChargeCount, PerformedChargeCount: Integer
  );
begin

  if RecordIndex = -1 then Exit;

  with
    TEmployeeExtensionIncomingDocumentSetHolder(DocumentSetHolder.ExtensionSetHolder)
  do begin

    AllSubordinateChargeSheetsPerformedFieldValue :=
      (TotalChargeCount <> 0) and (TotalChargeCount = PerformedChargeCount);

  end;

end;

procedure TEmployeeIncomingDocumentsReferenceForm.UpdateDataOperationControls;
begin

  inherited;

  actCreateRespondingDocument.Enabled := HasDataSetRecords;

end;

procedure TEmployeeIncomingDocumentsReferenceForm.SetViewOnly(
  const Value: Boolean);
begin

  inherited;

  actCreateRespondingDocument.Visible := not Value;
  
end;

procedure TEmployeeIncomingDocumentsReferenceForm.SetActivatedDataOperationControls(
  const Activated: Boolean);
begin

  inherited;

  actCreateRespondingDocument.Enabled := Activated;
  
end;

procedure TEmployeeIncomingDocumentsReferenceForm.SetEmployeeExtensionTableColumnLayoutFrom(
  EmployeeExtensionFieldDefs: TEmployeeExtensionDocumentSetFieldDefs
);
begin

  inherited SetEmployeeExtensionTableColumnLayoutFrom(EmployeeExtensionFieldDefs);

  with TEmployeeExtensionIncomingDocumentSetFieldDefs(EmployeeExtensionFieldDefs)
  do begin

    OwnDocumentChargeColumn.DataBinding.FieldName := OwnChargeFieldName;
    
    AllChargeSheetsPerformedColumn.DataBinding.FieldName :=
      AllChargeSheetsPerformedFieldName;

    AllSubordinateChargeSheetsPerformedColumn.DataBinding.FieldName :=
      AllSubordinateChargeSheetsPerformedFieldName;
      
  end;

end;

procedure TEmployeeIncomingDocumentsReferenceForm.SetIncomingDocumentTableColumnLayoutFrom(
  FieldDefs: TDocumentSetFieldDefs);
begin

  inherited SetIncomingDocumentTableColumnLayoutFrom(FieldDefs);

  SetEmployeeExtensionTableColumnLayoutFrom(
    TEmployeeExtensionDocumentSetFieldDefs(FieldDefs.ExtensionFieldDefs)
  );
  
end;

procedure TEmployeeIncomingDocumentsReferenceForm.SetTableColumnLayoutFrom(
  FieldDefs: TDocumentSetFieldDefs);
begin

  inherited SetTableColumnLayoutFrom(FieldDefs);

end;

function TEmployeeIncomingDocumentsReferenceForm.GetIncomingDocumentGridRecordColor(
  GridRecord: TcxCustomGridRecord
): TColor;
begin

end;

end.
