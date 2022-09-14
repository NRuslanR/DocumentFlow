unit DocumentRelationsReferenceFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DBDataTableFormUnit, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters, Menus, cxControls, cxStyles, dxSkinsCore,
  dxSkinsDefaultPainters, dxSkinscxPCPainter, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, DB, cxDBData, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, ActnList, ImgList, PngImageList, cxGridLevel, cxClasses,
  cxGridCustomView, cxGrid, cxButtons, ComCtrls, pngimage, ExtCtrls, StdCtrls,
  ToolWin, ZSqlUpdate, ZAbstractRODataset,
  ZAbstractDataset, ZDataset, ApplicationDataModuleUnit,
  DocumentRelationSetHolder,
  DocumentRecordViewModel,
  cxLocalization,
  DocumentFlowBaseReferenceFormUnit, cxCheckBox;

type

  TDocumentRelationTableRecord = class (TDBDataTableRecord)

    protected

      FFieldDefs: TDocumentRelationSetFieldDefs;

      function GetDocumentCreationDate: TDateTime;
      function GetDocumentId: Variant;
      function GetDocumentName: String;
      function GetDocumentNumber: String;
      function GetDocumentKindId: Variant;
      function GetDocumentKindName: String;

      property FieldDefs: TDocumentRelationSetFieldDefs
      read FFieldDefs;
      
    public

      property DocumentId: Variant read GetDocumentId;
      property DocumentKindId: Variant read GetDocumentKindId;
      property DocumentNumber: String read GetDocumentNumber;
      property DocumentName: String read GetDocumentName;
      property DocumentCreationDate: TDateTime read GetDocumentCreationDate;
      property DocumentKindName: String read GetDocumentKindName;
      
  end;

  TDocumentRelationTableRecords = class;

  TDocumentRelationTableRecordsEnumerator = class (TDBDataTableRecordsEnumerator)

    protected

      function GetCurrentDocumentRelationTableRecord:
        TDocumentRelationTableRecord;

      constructor Create(
        DocumentRelationTableRecords: TDocumentRelationTableRecords
      );

    public

      property Current: TDocumentRelationTableRecord
      read GetCurrentDocumentRelationTableRecord;

  end;

  TDocumentRelationTableRecords = class (TDBDataTableRecords)

    protected

      FFieldDefs: TDocumentRelationSetFieldDefs;

      function GetDocumentRelationTableRecordByIndex(Index: Integer):
        TDocumentRelationTableRecord;

      property FieldDefs: TDocumentRelationSetFieldDefs
      read FFieldDefs;
      
    public

      function GetEnumerator: TDocumentRelationTableRecordsEnumerator;

      property Items[Index: Integer]: TDocumentRelationTableRecord
      read GetDocumentRelationTableRecordByIndex; default;


  end;

  TOnDocumentSelectionFormRequestedEventHandler =
    procedure (
      Sender: TObject;
      var DocumentSelectionForm: TForm
    ) of object;

  TOnRelatedDocumentCardOpeningRequestedEventHandler =
    procedure (
      Sender: TObject;
      SelectedRelatedDocumentTableRecord: TDocumentRelationTableRecord
    ) of object;

  TDocumentRelationsReferenceForm = class(TDocumentFlowBaseReferenceForm)
    DocumentNumberColumn: TcxGridDBColumn;
    DocumentNameColumn: TcxGridDBColumn;
    DocumentDateColumn: TcxGridDBColumn;
    DocumentIdColumn: TcxGridDBColumn;
    DocumentKindIdColumn: TcxGridDBColumn;
    DocumentKindNameColumn: TcxGridDBColumn;
    actOpenRelatedDocumentCard: TAction;
    OpenRelatedDocumentCardMenuItem: TMenuItem;
    BaseDocumentIdColumn: TcxGridDBColumn;
    IdColumn: TcxGridDBColumn;
    procedure DataRecordGridTableViewCellDblClick(
      Sender: TcxCustomGridTableView;
      ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
      AShift: TShiftState; var AHandled: Boolean);
    procedure actOpenRelatedDocumentCardExecute(Sender: TObject);
    procedure DataOperationPopupMenuPopup(Sender: TObject);
  private

  protected

    FEmployeeId: Variant;
    FDocumentId: Variant;
    FOnDocumentSelectionFormRequestedEventHandler: TOnDocumentSelectionFormRequestedEventHandler;
    FOnRelatedDocumentCardOpeningRequestedEventHandler: TOnRelatedDocumentCardOpeningRequestedEventHandler;
    FDocumentRelationSetHolder: TDocumentRelationSetHolder;

    class function GetDBDataTableRecordClass: TDBDataTableRecordClass; override;
    class function GetDBDataTableRecordsClass: TDBDataTableRecordsClass; override;

    function OnAddRecord: Boolean; override;
    procedure Init(const Caption: String; ADataSet: TDataSet); override;

    procedure SetDocumentId(const DocumentId: Variant);

    function IsRelatedDocumentDataAlreadyAdded(
      const DocumentId, DocumentKindId: Variant
    ): Boolean;

    procedure InsertRelatedDocumentDataFromSelectedRecord(
      SelectedDocumentRecord: TDocumentRecordViewModel
    );

    procedure AddRelatedDocumentDataFromSelectedRecord(
      SelectedDocumentRecords: TDocumentRecordViewModels
    );
    
    procedure SetDocumentRelationSetHolder(
      const Value: TDocumentRelationSetHolder
    );

    procedure SetTableColumnLayout(const FieldDefs: TDocumentRelationSetFieldDefs);
    
    function GetSelectedDocumentRelationRecords: TDocumentRelationTableRecords;

    procedure AddRelatedDocumentsFromDocumentSelectionReference;

    procedure RaiseEventAboutThatRelatedDocumentCardOpeningRequested;

  public

    property EmployeeId: Variant read FEmployeeId write FEmployeeId;
    property DocumentId: Variant read FDocumentId write SetDocumentId;

    property DocumentRelationSetHolder: TDocumentRelationSetHolder
    read FDocumentRelationSetHolder
    write SetDocumentRelationSetHolder;

    property OnDocumentSelectionFormRequestedEventHandler:
      TOnDocumentSelectionFormRequestedEventHandler
    read FOnDocumentSelectionFormRequestedEventHandler
    write FOnDocumentSelectionFormRequestedEventHandler;

    property OnRelatedDocumentCardOpeningRequestedEventHandler:
      TOnRelatedDocumentCardOpeningRequestedEventHandler
    read FOnRelatedDocumentCardOpeningRequestedEventHandler
    write FOnRelatedDocumentCardOpeningRequestedEventHandler;

    property SelectedDocumentRelationRecords: TDocumentRelationTableRecords
    read GetSelectedDocumentRelationRecords;
    
  end;

var
  DocumentRelationsReferenceForm: TDocumentRelationsReferenceForm;

implementation

uses

  AuxWindowsFunctionsUnit,
  AuxDebugFunctionsUnit,
  unSelectionDocumentsForm, AbstractDataSetHolder;

{$R *.dfm}

{ TDocumentRelationsReferenceForm }

procedure TDocumentRelationsReferenceForm.actOpenRelatedDocumentCardExecute(
  Sender: TObject);
begin

  OnChooseRecords;

  RaiseEventAboutThatRelatedDocumentCardOpeningRequested;

end;

procedure TDocumentRelationsReferenceForm.
  AddRelatedDocumentsFromDocumentSelectionReference;
  
var
    SelectedRecord: TDBDataTableRecord;
    DocumentSelectionForm: TSelectionDocumentsForm;
    DocumentSelectionFormPlaceholder: TForm;
begin

  if not Assigned(FOnDocumentSelectionFormRequestedEventHandler) then
    raise Exception.Create(
            'Неизвестно, как получить справочник ' +
            'выбора связных документов'
          );

  FOnDocumentSelectionFormRequestedEventHandler(
    Self, DocumentSelectionFormPlaceholder
  );

  DocumentSelectionForm :=
    DocumentSelectionFormPlaceholder as TSelectionDocumentsForm;
  
  try

    Screen.Cursor := crHourGlass;
    
    if DocumentSelectionForm.ShowModal <> mrOk then Exit;

    AddRelatedDocumentDataFromSelectedRecord(
      DocumentSelectionForm.SelectedDocumentRecords
    );

  finally

    Screen.Cursor := crDefault;
    
    FreeAndNil(DocumentSelectionForm);
    
  end;

end;

procedure TDocumentRelationsReferenceForm.
  AddRelatedDocumentDataFromSelectedRecord(
    SelectedDocumentRecords: TDocumentRecordViewModels
  );
var SelectedDocumentRecord: TDocumentRecordViewModel;
    ErrorMessage, DuplicateRelatedDocumentDataString: String;
begin

  ErrorMessage := '';
    DuplicateRelatedDocumentDataString := '';

  for SelectedDocumentRecord in SelectedDocumentRecords do begin

    if IsRelatedDocumentDataAlreadyAdded(
          SelectedDocumentRecord.DocumentId,
          SelectedDocumentRecord.KindId
         )
    then
        DuplicateRelatedDocumentDataString :=
          DuplicateRelatedDocumentDataString +
          'Номер "' + SelectedDocumentRecord.Number + '" от ' +
          DateTimeToStr(SelectedDocumentRecord.CreationDate) + sLineBreak

    else InsertRelatedDocumentDataFromSelectedRecord(SelectedDocumentRecord);

  end;

  if DuplicateRelatedDocumentDataString <> '' then begin

      ErrorMessage :=
        'Не удалось добавить некоторые документы, ' +
        'поскольку они уже были добавлены ранее:' +
        sLineBreak + DuplicateRelatedDocumentDataString;

      ShowWarningMessage(Self.Handle, ErrorMessage, 'Предупреждение');

  end;

end;

procedure TDocumentRelationsReferenceForm.
  InsertRelatedDocumentDataFromSelectedRecord(
    SelectedDocumentRecord: TDocumentRecordViewModel
  );
begin

  with DocumentRelationSetHolder do begin

    Append;

    DocumentIdFieldValue := SelectedDocumentRecord.DocumentId;
    DocumentKindIdFieldValue := SelectedDocumentRecord.KindId;
    DocumentNameFieldValue := SelectedDocumentRecord.Name;
    DocumentNumberFieldValue := SelectedDocumentRecord.Number;
    DocumentDateFieldValue := SelectedDocumentRecord.CreationDate;
    DocumentKindNameFieldValue := SelectedDocumentRecord.Kind;

    Post;

  end;

end;

procedure TDocumentRelationsReferenceForm.DataOperationPopupMenuPopup(
  Sender: TObject);
begin

  inherited;

  actOpenRelatedDocumentCard.Visible :=
    Assigned(DataSet) and (not DataSet.IsEmpty);
    
end;

procedure TDocumentRelationsReferenceForm.DataRecordGridTableViewCellDblClick(
  Sender: TcxCustomGridTableView; ACellViewInfo: TcxGridTableDataCellViewInfo;
  AButton: TMouseButton; AShift: TShiftState; var AHandled: Boolean);
begin

  actOpenRelatedDocumentCard.Execute;

end;

class function TDocumentRelationsReferenceForm.GetDBDataTableRecordClass: TDBDataTableRecordClass;
begin

  Result := TDocumentRelationTableRecord;

end;

class function TDocumentRelationsReferenceForm.GetDBDataTableRecordsClass: TDBDataTableRecordsClass;
begin

  Result := TDocumentRelationTableRecords;

end;

function TDocumentRelationsReferenceForm.GetSelectedDocumentRelationRecords: TDocumentRelationTableRecords;
begin

  Result := SelectedRecords as TDocumentRelationTableRecords;

  Result.FFieldDefs := DocumentRelationSetHolder.FieldDefs;
  
end;

procedure TDocumentRelationsReferenceForm.Init(const Caption: String;
  ADataSet: TDataSet);
begin

  inherited;

end;

function TDocumentRelationsReferenceForm.IsRelatedDocumentDataAlreadyAdded(
  const DocumentId, DocumentKindId: Variant
): Boolean;
var
  SearchRelatedDocumentDataResult: Variant;
begin

  SearchRelatedDocumentDataResult :=
    DocumentRelationSetHolder
      .Lookup(
        Format(
          '%s;%s',
          [
            DocumentRelationSetHolder.DocumentIdFieldName,
            DocumentRelationSetHolder.DocumentKindIdFieldName
          ]
        ),
        VarArrayOf([DocumentId, DocumentKindId]),
        DocumentRelationSetHolder.DocumentIdFieldName
      );

  Result :=
    not VarIsNull(SearchRelatedDocumentDataResult)
    and not VarIsEmpty(SearchRelatedDocumentDataResult)
    and SearchRelatedDocumentDataResult;
  
end;

function TDocumentRelationsReferenceForm.OnAddRecord: Boolean;
begin

  AddRelatedDocumentsFromDocumentSelectionReference;

end;

procedure TDocumentRelationsReferenceForm.RaiseEventAboutThatRelatedDocumentCardOpeningRequested;
begin

  if Assigned(FOnRelatedDocumentCardOpeningRequestedEventHandler) then
    FOnRelatedDocumentCardOpeningRequestedEventHandler(
      Self, SelectedDocumentRelationRecords[0]
    );
    
end;

procedure TDocumentRelationsReferenceForm.SetDocumentId(
  const DocumentId: Variant);
begin

  FDocumentId := DocumentId;

end;

procedure TDocumentRelationsReferenceForm.SetDocumentRelationSetHolder(
  const Value: TDocumentRelationSetHolder);
begin

  FDocumentRelationSetHolder := Value;

  SetTableColumnLayout(Value.FieldDefs);
  
  DataSet := Value.DataSet;

  DataSet.First;                   
  
end;

procedure TDocumentRelationsReferenceForm.SetTableColumnLayout(
  const FieldDefs: TDocumentRelationSetFieldDefs);
begin

  with FieldDefs do begin

    IdColumn.DataBinding.FieldName := RecordIdFieldName;
    DocumentIdColumn.DataBinding.FieldName := DocumentIdFieldName;
    DocumentKindIdColumn.DataBinding.FieldName := DocumentKindIdFieldName;
    DocumentKindNameColumn.DataBinding.FieldName := DocumentKindNameFieldName;
    DocumentNumberColumn.DataBinding.FieldName := DocumentNumberFieldName;
    DocumentNameColumn.DataBinding.FieldName := DocumentNameFieldName;
    DocumentDateColumn.DataBinding.FieldName := DocumentDateFieldName;

    DataRecordGridTableView.DataController.KeyFieldNames := RecordIdFieldName;
      
  end;

end;

{ TDocumentRelationTableRecord }

function TDocumentRelationTableRecord.GetDocumentCreationDate: TDateTime;
begin

  Result := Self[FFieldDefs.DocumentDateFieldName];

end;

function TDocumentRelationTableRecord.GetDocumentId: Variant;
begin

  Result := Self[FFieldDefs.DocumentIdFieldName];
  
end;

function TDocumentRelationTableRecord.GetDocumentName: String;
begin

  Result := Self[FFieldDefs.DocumentNameFieldName];
  
end;

function TDocumentRelationTableRecord.GetDocumentNumber: String;
begin

  Result := Self[FFieldDefs.DocumentNumberFieldName];
  
end;

function TDocumentRelationTableRecord.GetDocumentKindId: Variant;
begin

  Result := Self[FFieldDefs.DocumentKindIdFieldName];
  
end;

function TDocumentRelationTableRecord.GetDocumentKindName: String;
begin

  Result := Self[FFieldDefs.DocumentKindNameFieldName];
  
end;

{ TDocumentRelationTableRecordsEnumerator }

constructor TDocumentRelationTableRecordsEnumerator.Create(
  DocumentRelationTableRecords: TDocumentRelationTableRecords);
begin

  inherited Create(DocumentRelationTableRecords);
  
end;

function TDocumentRelationTableRecordsEnumerator.
  GetCurrentDocumentRelationTableRecord: TDocumentRelationTableRecord;
begin

  Result := GetCurrentDBDataTableRecord as TDocumentRelationTableRecord;

  Result.FFieldDefs :=
    (FDBDataTableRecords as TDocumentRelationTableRecords).FieldDefs;
    
end;

{ TDocumentRelationTableRecords }

function TDocumentRelationTableRecords.GetDocumentRelationTableRecordByIndex(
  Index: Integer): TDocumentRelationTableRecord;
begin

  Result := GetDBDataTableRecordByIndex(Index) as TDocumentRelationTableRecord;

  Result.FFieldDefs := FieldDefs;

end;

function TDocumentRelationTableRecords.GetEnumerator: TDocumentRelationTableRecordsEnumerator;
begin

  Result := TDocumentRelationTableRecordsEnumerator.Create(Self);
  
end;

end.

