unit DocumentFileUnit;

interface

uses

  Document,
  DomainObjectUnit,
  DomainObjectListUnit,
  SysUtils,
  Classes;

const

  AVAILABLE_DOCUMENT_FILE_EXTENSION_COUNT = 5;

  AvailableDocumentFileExtensions:
    array [0 .. AVAILABLE_DOCUMENT_FILE_EXTENSION_COUNT - 1] of string =
    ('.doc', '.docx', '.xls', '.xlsx', '.pdf');

type

  TDocumentFile = class (TDomainObject)

    protected

      FDocumentId: Variant;
      FFileName: String;
      FFilePath: String;

      function GetAvailableDocumentFileExtensionsCommaString: String;
      function IsFileExtensionValid(const FileExtension: String): Boolean;
      function IsFileSizeAllowed(const FileSizeInMegaBytes: Single): Boolean;
      
      procedure EnsureThatFileIsValid(const FilePath: String);

      function GetDocumentId: Variant; virtual;
      function GetFileName: String; virtual;
      function GetFilePath: String; virtual;

      procedure SetDocumentId(const Value: Variant); virtual;
      procedure SetFileName(const Value: String); virtual;
      procedure SetFilePath(const Value: String); virtual;

    public

      constructor Create; overload;
      constructor Create(Id: Variant); overload;

      constructor Create(
        Id: Variant;
        const DocumentId: Variant;
        const FileName, FilePath: String
      ); overload;

    published
    
      property DocumentId: Variant
      read GetDocumentId write SetDocumentId;

      property FileName: String
      read GetFileName write SetFileName;

      property FilePath: String
      read GetFilePath write SetFilePath;

  end;

  TDocumentFileClass = class of TDocumentFile;

  TClonableDocumentFile = class (TDocumentFile)

    private

      FCloneeDocumentFile: TDocumentFile;
      FFilePathForCloning: String;
      
      function GetCloneeDocumentFile: TDocumentFile;

      procedure EnsureThatFileExtensionsMatches(
        const FilePathForCloning, CloneeDocumentFilePath: String
      );

    protected

      function GetDocumentId: Variant; override;
      function GetFileName: String; override;
      function GetFilePath: String; override;

      procedure SetDocumentId(const Value: Variant); override;
      procedure SetFileName(const Value: String); override;
      procedure SetFilePath(const Value: String); override;

      procedure FreeNestedBaseDomainObjects; override;
      
    public

      constructor Create(
        CloneeDocumentFile: TDocumentFile;
        const FilePathForCloning: String
      );

      property CloneeDocumentFile: TDocumentFile
      read GetCloneeDocumentFile;
      
  end;

  TDocumentFiles = class;

  TDocumentFilesEnumerator = class (TDomainObjectListEnumerator)

    private

      function GetCurrentDocumentFile: TDocumentFile;

    public

      constructor Create(DocumentFiles: TDocumentFiles);

      property Current: TDocumentFile read GetCurrentDocumentFile;

  end;

  TDocumentFiles = class (TDomainObjectList)

    private

      function GetDocumentFileByIndex(Index: Integer): TDocumentFile;
      procedure SetDocumentFileByIndex(
        Index: Integer;
        DocumentFile: TDocumentFile
      );

    public

      procedure AssignDocument(Document: TDocument);
      
      function GetEnumerator: TDocumentFilesEnumerator;

      property Items[Index: Integer]: TDocumentFile
      read GetDocumentFileByIndex write SetDocumentFileByIndex; default;
      
  end;

  TTDocumentFilesClass = class of TDocumentFiles;

implementation

uses

  Math,
  StrUtils,
  Variants,
  AuxSystemFunctionsUnit;
  
{ TDocumentFile }

constructor TDocumentFile.Create;
begin

  inherited;

end;

constructor TDocumentFile.Create(Id: Variant);
begin

  inherited Create(Id);

end;

constructor TDocumentFile.Create(Id: Variant; const DocumentId: Variant;
  const FileName, FilePath: String);
begin
  
  inherited Create(Id);

  Self.DocumentId := DocumentId;
  Self.FileName := FileName;
  Self.FilePath := FilePath;
  
end;

procedure TDocumentFile.EnsureThatFileIsValid(const FilePath: String);
var FileExtension: String;
    SizeOfFile: Single;

begin

  if not FileExists(FilePath) then
    raise Exception.CreateFmt(
            'Файл с именем "%s" не существует',
            [FilePath]
          );

  FileExtension := ExtractFileExt(FilePath);

  if not IsFileExtensionValid(FileExtension) then
    raise Exception.CreateFmt(
            'Файл "%s" имеет недопустимое расширение "%s".' +
            sLineBreak + 'Допустимые расширения:' +
            GetAvailableDocumentFileExtensionsCommaString,
            [FilePath, FileExtension]
          );

  SizeOfFile := GetFileSize(FilePath) / 1024 / 1024;
  
  if not IsFileSizeAllowed(SizeOfFile) then
    raise Exception.CreateFmt(
            'Файл "%s" имеет не ' +
            ' допустимый размер в %s МБ.' +
            'Размер файла не должен превышать 10 МБ',
            [FilePath, FloatToStr(SizeOfFile)]
          );

end;

function TDocumentFile.GetAvailableDocumentFileExtensionsCommaString: String;
var AvailableFileExtension: String;
begin

  for AvailableFileExtension in AvailableDocumentFileExtensions do
    if Result = '' then
      Result := AvailableFileExtension

    else Result := Result + ', ' + AvailableFileExtension;

end;

function TDocumentFile.GetDocumentId: Variant;
begin

  Result := FDocumentId;
  
end;

function TDocumentFile.GetFileName: String;
begin

  Result := FFileName;
  
end;

function TDocumentFile.GetFilePath: String;
begin

  Result := FFilePath;

end;

function TDocumentFile.IsFileExtensionValid(
  const FileExtension: String
): Boolean;
var CurrentAvailableDocumentFileExtension: String;
begin

  for CurrentAvailableDocumentFileExtension in
      AvailableDocumentFileExtensions

  do if

    LowerCase(CurrentAvailableDocumentFileExtension) =
    LowerCase(FileExtension)

  then begin

    Result := True;
    Exit;

  end;

  Result := False;
  
end;

function TDocumentFile.IsFileSizeAllowed(
  const FileSizeInMegaBytes: Single
): Boolean;
begin

  Result := FileSizeInMegaBytes < 10;

end;

procedure TDocumentFile.SetDocumentId(const Value: Variant);
begin

  FDocumentId := Value;
  
end;

procedure TDocumentFile.SetFileName(const Value: String);
begin

  FFileName := Value;
  
end;

procedure TDocumentFile.SetFilePath(const Value: String);
begin

  {
  if InvariantsComplianceRequested then
    EnsureThatFileIsValid(Value); }
    
  FFilePath := Value;
  
end;

{ TDocumentFilesEnumerator }

constructor TDocumentFilesEnumerator.Create(DocumentFiles: TDocumentFiles);
begin

  inherited Create(DocumentFiles);

end;

function TDocumentFilesEnumerator.GetCurrentDocumentFile: TDocumentFile;
begin

  Result := GetCurrentDomainObject as TDocumentFile;
  
end;

{ TDocumentFiles }

procedure TDocumentFiles.AssignDocument(Document: TDocument);
var DocumentFile: TDocumentFile;
begin

  if not Assigned(Document) or VarIsNull(Document.Identity) then
    raise Exception.Create(
            'Попытка соотнести Файлы ' +
            'с неизвестным документом'
          );
  
  for DocumentFile in Self do
    DocumentFile.DocumentId := Document.Identity;
    
end;

function TDocumentFiles.GetDocumentFileByIndex(Index: Integer): TDocumentFile;
begin

  Result := GetDomainObjectByIndex(Index) as TDocumentFile;

end;

function TDocumentFiles.GetEnumerator: TDocumentFilesEnumerator;
begin

  Result := TDocumentFilesEnumerator.Create(Self);
  
end;

procedure TDocumentFiles.SetDocumentFileByIndex(Index: Integer;
  DocumentFile: TDocumentFile);
begin

  SetDomainObjectByIndex(Index, DocumentFile);
  
end;

{ TClonableDocumentFile }

constructor TClonableDocumentFile.Create(
  CloneeDocumentFile: TDocumentFile;
  const FilePathForCloning: String
);
begin

  EnsureThatFileExtensionsMatches(
    FilePathForCloning, CloneeDocumentFile.FilePath
  );

  inherited Create;

  Self.FilePath := FilePathForCloning;

  FCloneeDocumentFile := CloneeDocumentFile;
  
end;

procedure TClonableDocumentFile.EnsureThatFileExtensionsMatches(
  const FilePathForCloning, CloneeDocumentFilePath: String
);
begin

  if

      CompareStr(
        LowerCase(ExtractFileExt(FilePathForCloning)),
        LowerCase(ExtractFileExt(CloneeDocumentFilePath))
      ) <> 0

  then
    raise Exception.Create(
            'Расширение клонируемого файла ' +
            'документа не совпадает с ' +
            'расширением, заданным для ' +
            'клонирования'
          );

end;

procedure TClonableDocumentFile.FreeNestedBaseDomainObjects;
begin


end;

function TClonableDocumentFile.GetCloneeDocumentFile: TDocumentFile;
begin

  Result := FCloneeDocumentFile;
  
end;

function TClonableDocumentFile.GetDocumentId: Variant;
begin

  Result := FCloneeDocumentFile.DocumentId;
  
end;

function TClonableDocumentFile.GetFileName: String;
begin

  Result := FCloneeDocumentFile.FileName;
  
end;

function TClonableDocumentFile.GetFilePath: String;
begin

  Result := FFilePathForCloning;

end;

procedure TClonableDocumentFile.SetDocumentId(const Value: Variant);
begin

  FCloneeDocumentFile.Identity := Value;

end;

procedure TClonableDocumentFile.SetFileName(const Value: String);
begin

  FCloneeDocumentFile.FileName := Value;

end;

procedure TClonableDocumentFile.SetFilePath(const Value: String);
begin

  FFilePathForCloning := Value;

end;

end.
