{ refactor: заменить доменные объекты объектами DTO }
unit IDocumentFileServiceClientUnit;

interface

uses

  ApplicationService,
  DocumentFileUnit,
  Document,
  IGetSelfUnit,
  SysUtils,
  Classes;

type

  TDocumentFileData = class

    private

      FFileName: String;
      FFilePath: String;

    public

      constructor Create(
        const FileName, FilePath: String
      );

    published

      property FileName: String read FFileName write FFileName;
      property FilePath: String read FFilePath write FFilePath;
      
  end;

  TDocumentFileDataList = class;

  TDocumentFileDataListEnumerator = class (TListEnumerator)

    private

      function GetCurrentDocumentFileData: TDocumentFileData;

    public

      constructor Create(DocumentFileDataList: TDocumentFileDataList);

      property Current: TDocumentFileData
      read GetCurrentDocumentFileData;
      
  end;

  TDocumentFileDataList = class (TList)

    private

      function GetDocumentFileDataByIndex(Index: Integer): TDocumentFileData;
      procedure SetDocumentFileDataByIndex(
        Index: Integer;
        DocumentFileData: TDocumentFileData
      );

    protected

      procedure Notify(Ptr: Pointer; Action: TListNotification); override;

    public

      procedure Add(DocumentFileData: TDocumentFileData);
      procedure AddFrom(const FileName, FilePath: String);

      function GetEnumerator: TDocumentFileDataListEnumerator;

      property Items[Index: Integer]: TDocumentFileData
      read GetDocumentFileDataByIndex
      write SetDocumentFileDataByIndex; default;
      
  end;
  
  IDocumentFilePathGenerator = interface

    function GeneratePathForDocumentFile(
      DocumentFile: TDocumentFile;
      const AdditionalPartOfPath:String = ''
    ): String;

  end;

  TDocumentFileServiceClientException = class (TApplicationServiceException)

  end;
  
  IDocumentFileServiceClient = interface (IApplicationService)

    function GetFileStoragePath: String;
    
    function GetFile(const DocumentFileId: Variant): String;

  end;
  
implementation

{ TDocumentFileDataListEnumerator }

constructor TDocumentFileDataListEnumerator.Create(
  DocumentFileDataList: TDocumentFileDataList);
begin

  inherited Create(DocumentFileDataList);
  
end;

function TDocumentFileDataListEnumerator.GetCurrentDocumentFileData: TDocumentFileData;
begin

  Result := TDocumentFileData(GetCurrent);

end;

{ TDocumentFileDataList }

procedure TDocumentFileDataList.Add(DocumentFileData: TDocumentFileData);
begin

  inherited Add(DocumentFileData);
  
end;

procedure TDocumentFileDataList.AddFrom(const FileName, FilePath: String);
begin

  Add(TDocumentFileData.Create(FileName, FilePath));
  
end;

function TDocumentFileDataList.GetDocumentFileDataByIndex(
  Index: Integer): TDocumentFileData;
begin

  Result := TDocumentFileData(Get(Index));
  
end;

function TDocumentFileDataList.GetEnumerator: TDocumentFileDataListEnumerator;
begin

  Result := TDocumentFileDataListEnumerator.Create(Self);
  
end;

procedure TDocumentFileDataList.Notify(Ptr: Pointer; Action: TListNotification);
begin

  if Action = lnDeleted then
    if Assigned(Ptr) then
      TDocumentFileData(Ptr).Destroy;

end;

procedure TDocumentFileDataList.SetDocumentFileDataByIndex(Index: Integer;
  DocumentFileData: TDocumentFileData);
begin

  Put(Index, DocumentFileData);

end;


{ TDocumentFileData }

constructor TDocumentFileData.Create(const FileName, FilePath: String);
begin

  inherited Create;

  FFileName := FIleName;
  FFilePath := FilePath;
  
end;

end.
