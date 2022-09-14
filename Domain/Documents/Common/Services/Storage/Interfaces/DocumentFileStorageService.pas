unit DocumentFileStorageService;

interface

uses

  DomainException,
  DomainObjectValueUnit,
  DocumentFileUnit,
  Document,
  IGetSelfUnit,
  SysUtils,
  Classes;

type

  TDocumentFileStorageInfo = class (TDomainObjectValue)

    private

      FFileName: String;
      FFilePath: String;

    public

      constructor Create(
        const FileName, FilePath: String
      );

    published

      property FileName: String read FFileName;
      property FilePath: String read FFilePath;
      
  end;

  TDocumentFileStorageInfos = class;

  TDocumentFileStorageInfosEnumerator = class (TListEnumerator)

    private

      function GetCurrentDocumentFileStorageInfo: TDocumentFileStorageInfo;

    public

      constructor Create(DocumentFileStorageInfos: TDocumentFileStorageInfos);

      property Current: TDocumentFileStorageInfo
      read GetCurrentDocumentFileStorageInfo;
      
  end;

  TDocumentFileStorageInfos = class (TList)

    private

      function GetDocumentFileStorageInfoByIndex(Index: Integer): TDocumentFileStorageInfo;
      procedure SetDocumentFileStorageInfoByIndex(
        Index: Integer;
        DocumentFileStorageInfo: TDocumentFileStorageInfo
      );

    protected

      procedure Notify(Ptr: Pointer; Action: TListNotification); override;

    public

      procedure Add(DocumentFileStorageInfo: TDocumentFileStorageInfo);
      procedure AddFrom(const FileName, FilePath: String);

      function GetEnumerator: TDocumentFileStorageInfosEnumerator;

      property Items[Index: Integer]: TDocumentFileStorageInfo
      read GetDocumentFileStorageInfoByIndex
      write SetDocumentFileStorageInfoByIndex; default;
      
  end;

  TDocumentFilePathGeneratorException = class (TDomainException)

  end;
  
  IDocumentFilePathGenerator = interface

    function GeneratePathForDocumentFile(
      DocumentFile: TDocumentFile;
      const AdditionalPartOfPath:String = ''
    ): String;

  end;

  TDocumentFileStorageServiceException = class (TDomainException)

  end;
  
  IDocumentFileStorageService = interface (IGetSelf)
  ['{87F41DF2-FE13-4CFA-B2F1-6DCE5C431D70}']

    function GetFileStoragePath: String;

    function GetDocumentFilePathGenerator: IDocumentFilePathGenerator;
    procedure SetDocumentFilePathGenerator(Value: IDocumentFilePathGenerator);

    procedure PutDocumentFiles(
      DocumentFiles: TDocumentFiles
    );

    procedure RemoveDocumentFiles(
      DocumentFiles: TDocumentFiles
    );

    procedure UpdateDocumentFilesFor(
      DocumentFiles: TDocumentFiles;
      const DocumentId: Variant
    );

    procedure Cleanup;
    
    procedure RemoveAllFilesForDocument(const DocumentId: Variant);

    function GetFile(const DocumentFileId: Variant): String;
    function GetAllFilesForDocument(const DocumentId: Variant): TDocumentFileStorageInfos;

    property DocumentFilePathGenerator: IDocumentFilePathGenerator
    read GetDocumentFilePathGenerator write SetDocumentFilePathGenerator;

    property FileStoragePath: String read GetFileStoragePath;
    
  end;
  
implementation

{ TDocumentFileStorageInfosEnumerator }

constructor TDocumentFileStorageInfosEnumerator.Create(
  DocumentFileStorageInfos: TDocumentFileStorageInfos);
begin

  inherited Create(DocumentFileStorageInfos);
  
end;

function TDocumentFileStorageInfosEnumerator.GetCurrentDocumentFileStorageInfo: TDocumentFileStorageInfo;
begin

  Result := TDocumentFileStorageInfo(GetCurrent);

end;

{ TDocumentFileStorageInfos }

procedure TDocumentFileStorageInfos.Add(DocumentFileStorageInfo: TDocumentFileStorageInfo);
begin

  inherited Add(DocumentFileStorageInfo);
  
end;

procedure TDocumentFileStorageInfos.AddFrom(const FileName, FilePath: String);
begin

  Add(TDocumentFileStorageInfo.Create(FileName, FilePath));
  
end;

function TDocumentFileStorageInfos.GetDocumentFileStorageInfoByIndex(
  Index: Integer): TDocumentFileStorageInfo;
begin

  Result := TDocumentFileStorageInfo(Get(Index));
  
end;

function TDocumentFileStorageInfos.GetEnumerator: TDocumentFileStorageInfosEnumerator;
begin

  Result := TDocumentFileStorageInfosEnumerator.Create(Self);
  
end;

procedure TDocumentFileStorageInfos.Notify(Ptr: Pointer; Action: TListNotification);
begin

  if Action = lnDeleted then
    if Assigned(Ptr) then
      TDocumentFileStorageInfo(Ptr).Destroy;

end;

procedure TDocumentFileStorageInfos.SetDocumentFileStorageInfoByIndex(Index: Integer;
  DocumentFileStorageInfo: TDocumentFileStorageInfo);
begin

  Put(Index, DocumentFileStorageInfo);

end;


{ TDocumentFileStorageInfo }

constructor TDocumentFileStorageInfo.Create(const FileName, FilePath: String);
begin

  inherited Create;

  FFileName := FIleName;
  FFilePath := FilePath;
  
end;

end.
