unit DocumentFilesReferenceFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DBDataTableFormUnit, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters, Menus, cxControls, cxStyles, dxSkinsCore,
  dxSkinsDefaultPainters, dxSkinscxPCPainter, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, DB, cxDBData, ActnList, ImgList, PngImageList,
  cxGridLevel, cxClasses, cxGridCustomView, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxGrid, cxButtons, ComCtrls, pngimage,
  ExtCtrls, StdCtrls, ToolWin,
  ZAbstractRODataset, ZAbstractDataset, ZDataset, ZSqlUpdate, ZConnection,
  ZSequence, DocumentFileSetHolder, cxLocalization,
  DocumentFlowBaseReferenceFormUnit, DBClient, cxCheckBox;

type

  TDocumentFileTableRecord = class (TDBDataTableRecord)

    protected

      function GetDocumentFileId: Variant;
      function GetDocumentFileName: String;
      function GetDocumentFilePath: String;

    public

      property DocumentFileId: Variant read GetDocumentFileId;
      property DocumentFileName: String read GetDocumentFileName;
      property DocumentFilePath: String read GetDocumentFilePath;

  end;

  TDocumentFileTableRecords = class;

  TDocumentFileTableRecordsEnumerator = class (TDBDataTableRecordsEnumerator)

    private

      function GetCurrentDocumentFileTableRecord: TDocumentFileTableRecord;

    public

      constructor Create(DocumentFileTableRecords: TDocumentFileTableRecords);

      property Current: TDocumentFileTableRecord
      read GetCurrentDocumentFileTableRecord;

  end;

  TDocumentFileTableRecords = class (TDBDataTableRecords)

    private

      function GetDocumentFileTableRecordByIndex(
        Index: Integer
      ): TDocumentFileTableRecord;

    public

      function GetEnumerator: TDocumentFileTableRecordsEnumerator;

      property Items[Index: Integer]: TDocumentFileTableRecord
      read GetDocumentFileTableRecordByIndex; default;

  end;

  TOnExistingDocumentFileOpeningRequestedEventHandler =
    procedure (
      Sender: TObject;
      const DocumentFileId: Variant;
      var DocumentFilePath: String
    ) of object;

  TOnDocumentFileRecordAddedEventHandler =
    procedure (
      Sender: TObject;
      DocumentFileTableRecord: TDocumentFileTableRecord
    ) of object;

  TOnDocumentFileRecordRemovedEventHandler =
    procedure (
      Sender: TObject;
      RemovedDocumentFileTableRecord: TDocumentFileTableRecord
    ) of object;

  TOnDocumentFileRecordFocusedEventHandler =
    procedure (
      Sender: TObject;
      FocusedDocumentFileRecord: TDocumentFileTableRecord
    ) of object;
    
  TDocumentFilesReferenceForm = class(TDocumentFlowBaseReferenceForm)
    DocumentFileNameColumn: TcxGridDBColumn;
    DocumentFilePathColumn: TcxGridDBColumn;
    LoadFileDialog: TOpenDialog;
    DocumentFileIdColumn: TcxGridDBColumn;
    OpenDocumentFileMenuItem: TMenuItem;
    actOpenDocumentFile: TAction;
    N5: TMenuItem;
    ClientDataSet1: TClientDataSet;
    procedure actOpenDocumentFileExecute(Sender: TObject);
    procedure DataRecordGridTableViewDblClick(Sender: TObject);
    procedure DataOperationPopupMenuPopup(Sender: TObject);
    procedure DataRecordGridTableViewFocusedRecordChanged(
      Sender: TcxCustomGridTableView; APrevFocusedRecord,
      AFocusedRecord: TcxCustomGridRecord;
      ANewItemRecordFocusingChanged: Boolean);

  protected
    { Private declarations }

    FDocumentFileSetHolder: TDocumentFileSetHolder;

    FOnDocumentFileRecordFocusedEventHandler:
      TOnDocumentFileRecordFocusedEventHandler;

    FOnDocumentFileRecordAddedEventHandler:
      TOnDocumentFileRecordAddedEventHandler;

    FOnDocumentFileRecordRemovedEventHandler:
      TOnDocumentFileRecordRemovedEventHandler;
      
    FOnExistingDocumentFileOpeningRequestedEventHandler:
      TOnExistingDocumentFileOpeningRequestedEventHandler;
      
    procedure Init(const Caption: String; ADataSet: TDataSet); override;

    function GetTotalRecordCountPanelLabel: String; override;

    class function GetDBDataTableRecordClass: TDBDataTableRecordClass; override;
    class function GetDBDataTableRecordsClass: TDBDataTableRecordsClass; override;

    function GetFocusedDocumentFileRecord: TDocumentFileTableRecord;
    
    procedure InsertDocumentFileDataRecord(
      const FileName, FilePath: String
    );

    function OnAddRecord: Boolean; override;
    procedure OnRefreshRecords; override;
    function OnDeleteRecords: Integer; override;
    function OnDeleteCurrentRecord: Boolean; override;


    function IsFileDataAlreadyLoaded(const FileName: String): Boolean;

    procedure LoadDocumentFileData;

    procedure ShowCurrentDocumentFile;

    procedure SetTableColumnLayout(FieldDefs: TDocumentFileSetFieldDefs);

    procedure SetDocumentFileSetHolder(
      const Value: TDocumentFileSetHolder
    );

    procedure RaiseOnDocumentFileRecordFocusedEventHandler(
      FocusedDocumentFileRecord: TDocumentFileTableRecord
    );
    
  public

    property DocumentFileSetHolder: TDocumentFileSetHolder
    read FDocumentFileSetHolder
    write SetDocumentFileSetHolder;

    property OnExistingDocumentFileOpeningRequestedEventHandler:
      TOnExistingDocumentFileOpeningRequestedEventHandler
    read FOnExistingDocumentFileOpeningRequestedEventHandler
    write FOnExistingDocumentFileOpeningRequestedEventHandler;

    property OnDocumentFileRecordFocusedEventHandler:
      TOnDocumentFileRecordFocusedEventHandler
    read FOnDocumentFileRecordFocusedEventHandler
    write FOnDocumentFileRecordFocusedEventHandler;

    property OnDocumentFileRecordRemovedEventHandler:
      TOnDocumentFileRecordRemovedEventHandler
    read FOnDocumentFileRecordRemovedEventHandler
    write FOnDocumentFileRecordRemovedEventHandler;

    property OnDocumentFileRecordAddedEventHandler:
      TOnDocumentFileRecordAddedEventHandler
    read FOnDocumentFileRecordAddedEventHandler
    write FOnDocumentFileRecordAddedEventHandler;

    property FocusedDocumentFileRecord: TDocumentFileTableRecord
    read GetFocusedDocumentFileRecord;
    
  end;

var
  DocumentFilesReferenceForm: TDocumentFilesReferenceForm;

implementation

uses

  AuxFileFunctions,
  AuxWindowsFunctionsUnit,
  AuxSystemFunctionsUnit;

{$R *.dfm}

{ TDocumentFilesReferenceForm }

procedure TDocumentFilesReferenceForm.actOpenDocumentFileExecute(Sender: TObject);
begin

  ShowCurrentDocumentFile;

end;

procedure TDocumentFilesReferenceForm.DataOperationPopupMenuPopup(
  Sender: TObject);
begin

  inherited;

  actOpenDocumentFile.Visible := RecordCount > 0;

end;

procedure TDocumentFilesReferenceForm.DataRecordGridTableViewDblClick(
  Sender: TObject);
begin

  actOpenDocumentFile.Execute;

end;

procedure TDocumentFilesReferenceForm.DataRecordGridTableViewFocusedRecordChanged(
  Sender: TcxCustomGridTableView; APrevFocusedRecord,
  AFocusedRecord: TcxCustomGridRecord; ANewItemRecordFocusingChanged: Boolean);
begin

  inherited DataRecordGridTableViewFocusedRecordChanged(
    Sender, APrevFocusedRecord, AFocusedRecord, ANewItemRecordFocusingChanged
  );

  if Assigned(AFocusedRecord) then
    RaiseOnDocumentFileRecordFocusedEventHandler(FocusedDocumentFileRecord);

end;

class function TDocumentFilesReferenceForm.GetDBDataTableRecordClass: TDBDataTableRecordClass;
begin

  Result := TDocumentFileTableRecord;
  
end;

class function TDocumentFilesReferenceForm.GetDBDataTableRecordsClass: TDBDataTableRecordsClass;
begin

  Result := TDocumentFileTableRecords;
  
end;

function TDocumentFilesReferenceForm.GetFocusedDocumentFileRecord: TDocumentFileTableRecord;
begin

  Result := GetFocusedRecord as TDocumentFileTableRecord;

end;

function TDocumentFilesReferenceForm.GetTotalRecordCountPanelLabel: String;
begin

  Result := 'Количество файлов: ';
  
end;

procedure TDocumentFilesReferenceForm.Init(
  const Caption: String;
  ADataSet: TDataSet
);
begin

  inherited;

end;

procedure TDocumentFilesReferenceForm.InsertDocumentFileDataRecord(
  const FileName, FilePath: String);
var
    AddedDocumentFileTableRecord: TDocumentFileTableRecord;
begin

  if IsFileOpen(FilePath) then begin

    ShowWarningMessage(
      Self.Handle,
      Format(
        'Файл "%s" открыт. Для добавления ' +
        'данного файла его необходимо закрыть',
        [FileName]
      ),
      'Сообщение'
    );

    Exit;
    
  end;

  if IsFileDataAlreadyLoaded(FileName) then begin

    ShowWarningMessage(
      Self.Handle,
      'Данные файла "' + FileName + '" уже были добавлены ранее',
      'Предупреждение'
    );

    Exit;

  end;

  BeginUpdate;

  try

    DocumentFileSetHolder.AddDocumentFileRecord(FileName, FilePath);

  finally

    EndUpdate;

  end;

  try

    AddedDocumentFileTableRecord := nil;
    
    if Assigned(FOnDocumentFileRecordAddedEventHandler) then begin

      AddedDocumentFileTableRecord :=
        CreateTableRecordViewModelForCurrentRow as TDocumentFileTableRecord;

      FOnDocumentFileRecordAddedEventHandler(
        Self, AddedDocumentFileTableRecord
      );
      
    end;

  finally
    
    FreeAndNil(AddedDocumentFileTableRecord);

  end;

end;

function TDocumentFilesReferenceForm.IsFileDataAlreadyLoaded(const FileName: String): Boolean;
var SearchFileDataRecordResult: Variant;
begin

  if not DataSet.Active then
    DataSet.Open;

  SearchFileDataRecordResult :=
    DocumentFileSetHolder
      .DataSet
        .Lookup(
          DocumentFileSetHolder.FileNameFieldName,
          FileName,
          DocumentFileSetHolder.FileNameFieldName
        );

  Result :=
    not VarIsNull(SearchFileDataRecordResult)
    and not VarIsEmpty(SearchFileDataRecordResult);
  
end;

procedure TDocumentFilesReferenceForm.LoadDocumentFileData;
var FileName, FilePath: String;
begin

  if not LoadFileDialog.Execute then Exit;

  FilePath := LoadFileDialog.FileName;
  FileName := ExtractFileName(FilePath);

  InsertDocumentFileDataRecord(FileName, FilePath);
  
end;

function TDocumentFilesReferenceForm.OnAddRecord: Boolean;
begin

  LoadDocumentFileData;

end;

function TDocumentFilesReferenceForm.OnDeleteCurrentRecord: Boolean;
var RemovedDocumentFileTableRecord: TDocumentFileTableRecord;
begin

  try

    RemovedDocumentFileTableRecord :=
      CreateTableRecordViewModelForCurrentRow as TDocumentFileTableRecord;

    Result := inherited OnDeleteCurrentRecord;

    if Assigned(OnDocumentFileRecordRemovedEventHandler) then
      FOnDocumentFileRecordRemovedEventHandler(
        Self, RemovedDocumentFileTableRecord
      );
    
  finally

    FreeAndNil(RemovedDocumentFileTableRecord);
    
  end;
  
end;

function TDocumentFilesReferenceForm.OnDeleteRecords: Integer;
begin

  Result := inherited OnDeleteRecords;

end;

procedure TDocumentFilesReferenceForm.OnRefreshRecords;
begin
  
  inherited;

end;

procedure TDocumentFilesReferenceForm.RaiseOnDocumentFileRecordFocusedEventHandler(
  FocusedDocumentFileRecord: TDocumentFileTableRecord);
begin

  if Assigned(FOnDocumentFileRecordFocusedEventHandler) then begin

    FOnDocumentFileRecordFocusedEventHandler(
      Self, FocusedDocumentFileRecord
    );

  end;

end;

procedure TDocumentFilesReferenceForm.SetDocumentFileSetHolder(
  const Value: TDocumentFileSetHolder);
begin

  FDocumentFileSetHolder := Value;

  SetTableColumnLayout(Value.FieldDefs);
  
  DataSet := Value.DataSet;

end;

procedure TDocumentFilesReferenceForm.SetTableColumnLayout(
  FieldDefs: TDocumentFileSetFieldDefs);
begin

  with FieldDefs do begin

    DocumentFileIdColumn.DataBinding.FieldName := IdFieldName;
    DocumentFileNameColumn.DataBinding.FieldName := FileNameFieldName;
    DocumentFilePathColumn.DataBinding.FieldName := FilePathFieldName;

    DataRecordGridTableView.DataController.KeyFieldNames := FileNameFieldName;
    
  end;

end;

procedure TDocumentFilesReferenceForm.ShowCurrentDocumentFile;
var DocumentFilePath: String;
begin

  try

    Screen.Cursor := crHourGlass;
    
    if VarIsNull(DocumentFileSetHolder.IdFieldValue) then
    begin

      DocumentFilePath :=
        DocumentFileSetHolder.FileNameFieldValue;

    end

    else if Assigned(FOnExistingDocumentFileOpeningRequestedEventHandler) then
    begin

      FOnExistingDocumentFileOpeningRequestedEventHandler(
        Self,
        DocumentFileSetHolder.IdFieldValue,
        DocumentFilePath
      );

    end;

    if DocumentFilePath <> '' then
      OpenDocument(DocumentFilePath);

  finally

    Screen.Cursor := crDefault;

  end;
  
end;

{ TDocumentFileTableRecord }

function TDocumentFileTableRecord.GetDocumentFileId: Variant;
begin

  Result := Self['id'];
  
end;

function TDocumentFileTableRecord.GetDocumentFileName: String;
begin

  Result := Self['file_name'];
  
end;

function TDocumentFileTableRecord.GetDocumentFilePath: String;
begin

  Result := Self['file_path'];
  
end;

{ TDocumentFileTableRecordsEnumerator }

constructor TDocumentFileTableRecordsEnumerator.Create(
  DocumentFileTableRecords: TDocumentFileTableRecords);
begin

  inherited Create(DocumentFileTableRecords);
  
end;

function TDocumentFileTableRecordsEnumerator.
  GetCurrentDocumentFileTableRecord: TDocumentFileTableRecord;
begin

  Result := GetCurrentDBDataTableRecord as TDocumentFileTableRecord;

end;

{ TDocumentFileTableRecords }

function TDocumentFileTableRecords.GetDocumentFileTableRecordByIndex(
  Index: Integer): TDocumentFileTableRecord;
begin

  Result := GetDBDataTableRecordByIndex(Index) as TDocumentFileTableRecord;

end;

function TDocumentFileTableRecords.GetEnumerator: TDocumentFileTableRecordsEnumerator;
begin

  Result := TDocumentFileTableRecordsEnumerator.Create(Self);
  
end;

end.
