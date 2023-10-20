unit DocumentFileInfoList;

interface

uses

  SysUtils,
  Classes;
  
type

  TDocumentFileInfo = class

    private

      FId: Variant;
      FFileName: String;
      FFilePath: String;

    public

      constructor Create; overload;
      constructor Create(
        const Id: Variant;
        const FileName, FilePath: String
      ); overload;

    published

      property Id: Variant read FId write FId;
      property FileName: String read FFileName write FFileName;
      property FilePath: String read FFilePath write FFilePath;
      
  end;

  TDocumentFileInfoList = class;
  
  TDocumentFileInfoListEnumerator = class (TListEnumerator)

    private

      function GetCurrentDocumentFileInfo: TDocumentFileInfo;

    public

      constructor Create(DocumentFileInfoList: TDocumentFileInfoList);

      property Current: TDocumentFileInfo read GetCurrentDocumentFileInfo;
      
  end;
  
  TDocumentFileInfoList = class (TList)

    private

      function GetDocumentFileInfoByIndex(Index: Integer): TDocumentFileInfo;
      procedure SetDocumentFileInfoByIndex(
        Index: Integer;
        DocumentFileInfo: TDocumentFileInfo
      );

      function GetDocumentFileInfoIndexByFileName(
        const FileName: String
      ): Integer;
      
    protected

      procedure Notify(Ptr: Pointer; Action: TListNotification); override;

    public

      function IndexOf(DocumentFileInfo: TDocumentFileInfo): Integer; overload;
      function IndexOf(const FileName: String): Integer; overload;
      
      function Add(DocumentFileInfo: TDocumentFileInfo): Integer;
      function AddFrom(
        const Id: Variant;
        const FileName, FilePath: String
      ): Integer;
      
      procedure Extract(DocumentFileInfo: TDocumentFileInfo);

      function FindByFileName(const FileName: String): TDocumentFileInfo;
      procedure RemoveByFileName(const FileName: String);
       
      function GetEnumerator: TDocumentFileInfoListEnumerator;

      property Items[Index: Integer]: TDocumentFileInfo
      read GetDocumentFileInfoByIndex
      write SetDocumentFileInfoByIndex; default;
      
  end;

implementation

uses

  Variants;
  
{ TDocumentFileInfo }

constructor TDocumentFileInfo.Create;
begin

  inherited;

  FId := Null;

end;

constructor TDocumentFileInfo.Create(
  const Id: Variant;
  const FileName, FilePath: String
);
begin

  inherited Create;

  FId := Id;
  FFileName := FileName;
  FFilePath := FilePath;

end;

{ TDocumentFileInfoListEnumerator }

constructor TDocumentFileInfoListEnumerator.Create(
  DocumentFileInfoList: TDocumentFileInfoList);
begin

  inherited Create(DocumentFileInfoList);
  
end;

function TDocumentFileInfoListEnumerator.GetCurrentDocumentFileInfo: TDocumentFileInfo;
begin

  Result := TDocumentFileInfo(GetCurrent);
  
end;

{ TDocumentFileInfoList }

function TDocumentFileInfoList.Add(
  DocumentFileInfo: TDocumentFileInfo): Integer;
begin

  inherited Add(DocumentFileInfo);
  
end;

function TDocumentFileInfoList.GetDocumentFileInfoByIndex(
  Index: Integer): TDocumentFileInfo;
begin

  Result := TDocumentFileInfo(Get(Index));
  
end;

function TDocumentFileInfoList.GetDocumentFileInfoIndexByFileName(
  const FileName: String): Integer;
begin

  for Result := 0 to Count - 1 do
    if Self[Result].FileName = FileName then
      Exit;

  Result := -1;
    
end;

function TDocumentFileInfoList.GetEnumerator: TDocumentFileInfoListEnumerator;
begin

  Result := TDocumentFileInfoListEnumerator.Create(Self);
  
end;

function TDocumentFileInfoList.IndexOf(const FileName: String): Integer;
begin

  Result := GetDocumentFileInfoIndexByFileName(FileName);
  
end;

function TDocumentFileInfoList.IndexOf(
  DocumentFileInfo: TDocumentFileInfo): Integer;
begin

  Result := inherited IndexOf(DocumentFileInfo);
  
end;

procedure TDocumentFileInfoList.Notify(Ptr: Pointer; Action: TListNotification);
begin

  if Action = lnDeleted then
    if Assigned(Ptr) then
      TDocumentFileInfo(Ptr).Destroy;

end;

procedure TDocumentFileInfoList.RemoveByFileName(const FileName: String);
var DocumentFileInfo: TDocumentFileInfo;
    Index: Integer;
begin

  Index := IndexOf(FileName);
  
  if Index = -1 then Exit;
  
  DocumentFileInfo := Self[Index];
  
  Delete(Index);
  
  DocumentFileInfo.Destroy;
  
end;

function TDocumentFileInfoList.AddFrom(
  const Id: Variant;
  const FileName, FilePath: String
): Integer;
begin

  Result := Add(TDocumentFileInfo.Create(Id, FileName, FilePath));
  
end;

procedure TDocumentFileInfoList.Extract(DocumentFileInfo: TDocumentFileInfo);
begin

  Extract(DocumentFileInfo);
  
end;

function TDocumentFileInfoList.FindByFileName(
  const FileName: String): TDocumentFileInfo;
var Index: Integer;
begin

  Index := IndexOf(FileName);

  if Index >= 0 then
    Result := Self[Index]

  else Result := nil;
  
end;

procedure TDocumentFileInfoList.SetDocumentFileInfoByIndex(Index: Integer;
  DocumentFileInfo: TDocumentFileInfo);
begin

  Put(Index, DocumentFileInfo);
  
end;

end.
